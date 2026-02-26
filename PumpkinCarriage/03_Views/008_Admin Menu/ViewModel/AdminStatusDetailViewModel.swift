import Foundation

@Observable
final class AdminStatusDetailViewModel {
    
    private var adminVendorReadRepository: any AdminVendorReadRepository { Repositories.shared.vendorRead.admin }
    private var statusApplicationRepository: any StatusApplicationRepository { Repositories.shared.statusApplication }
    private var vendorWriteService: any VendorWriteService { Services.shared.vendorWrite }

    
    var vendorSummary: VendorSummary
    var vendorDetail: VendorDetail?
    var vendorProfileImage: VendorProfileImage?
    
    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
    }
    
    var shouldDismissOnAlert = false
    
    struct DecisionResult {
        let updatedApplication: VendorStatusApplication
        let updatedVendor: VendorSummary
    }
    var events: [VendorStatusApplicationEvent] = []
    
    //error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    
    //MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    //MARK: - Access Check (Prototype)
    func checkAccessPermission(user: User?) -> User? {
        guard let user = user,
              user.role == Role.admin else {
            createAlert(
                title: String(localized: "asdm.alert.permissionDenied.title"),
                message: String(localized: "asdm.alert.permissionDenied.msg")
            )
            return nil
        }
        return user
    }
    
    //MARK: - Initial Setup
    @MainActor
    func loadInitialState(applicationId: String, vendorId: String, currentUserId: String?) async {
        guard let currentUserId = currentUserId else { return }

        async let summaryTask: Void = refreshVendorSummary(userId: currentUserId, vendorId: vendorId)
        async let detailTask: Void = readVendorDetail(userId: currentUserId, vendorId: vendorId)
        async let imageTask: Void = readVendorImage(userId: currentUserId, vendorId: vendorId)
        async let eventsTask: Void = readApplicationEvents(applicationId: applicationId)

        _ = await (summaryTask, detailTask, imageTask, eventsTask)
    }

    @MainActor
    private func readApplicationEvents(applicationId: String) async {
        let events = statusApplicationRepository.listEvents(statusApplicationId: applicationId)
        self.events = events
    }
    
    //MARK: - Initial Setup Methods
    // Refresh summary in the background to avoid stale data.
    @MainActor
    private func refreshVendorSummary(userId: String, vendorId: String) async {
        do {
            // If your OpenVendorReadRepository uses a different name, adjust this call.
            if let latest = try await adminVendorReadRepository.readAdminSummary(id: vendorId) {
                vendorSummary = latest
            }
        } catch {
            // Non-fatal: keep showing the passed-in summary.
            createAlert(title: String(localized: "asdm.alert.warning.title"), message: String(localized: "asdm.alert.refreshSummaryFailed.msg"), error: error)
        }
    }
    
    //Read VendorDetail
    @MainActor
    private func readVendorDetail(userId: String, vendorId: String) async {
        do {
            let detail = try await adminVendorReadRepository.readAdminDetail(id: vendorId)
            self.vendorDetail = detail
        } catch {
            createAlert(title: String(localized: "asdm.alert.warning.title"), message: String(localized: "asdm.alert.loadDetailFailed.msg"), error: error)
        }
    }
    
    //Read VendorImage
    @MainActor
    private func readVendorImage(userId: String, vendorId: String) async {
        do {
            let profile = try await adminVendorReadRepository.readAdminProfileImage(id: vendorId)
            self.vendorProfileImage = profile
        } catch {
            createAlert(title: String(localized: "asdm.alert.warning.title"), message: String(localized: "asdm.alert.loadImagesFailed.msg"), error: error)
        }
    }
    

    // MARK: - Rejection Helpers
    func defaultRejectionReason(for type: VendorStatusRequestType) -> RejectionTemplate {
        switch type {
        case .requestActive:
            return .inappropriateContent
        case .requestHidden:
            return .policyViolation
        case .requestArchived:
            return .missingRequiredInfo
        }
    }

    func composeRejectionReason(note: String) -> String {
        let note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        if note.isEmpty {
            return String(localized: "asdm.rejection.fallback")
        }
        return note
    }

    // MARK: - Approve / Reject Actions
    @MainActor
    func approve(
        application: VendorStatusApplication,
        vendor: VendorSummary,
        adminUser: User
    ) async throws -> DecisionResult {

        let updatedApplication = try statusApplicationRepository.updateDecision(
            applicationId: application.id,
            decision: .approved,
            reviewedByUserId: adminUser.id,
            reviewedAt: Date(),
            rejectionReason: nil
        )

        var updatedVendor = vendor
        updatedVendor.status = vendorWriteService.resolveStatusAfterDecision(
            requestType: application.requestType,
            decision: .approved,
            currentStatusAtSubmission: application.currentStatus,
            existingVendorStatus: vendor.status
        )
        updatedVendor.updatedAt = Date()

        // Persist vendor status update (use returned summary as the source of truth)
        let persistedVendor = try await vendorWriteService.updateSummaryStatus(
            vendorId: updatedVendor.id,
            status: updatedVendor.status,
            actor: adminUser
        )

        vendorSummary = persistedVendor
        return .init(updatedApplication: updatedApplication, updatedVendor: persistedVendor)
    }

    @MainActor
    func reject(
        application: VendorStatusApplication,
        vendor: VendorSummary,
        adminUser: User,
        rejectionReason: String
    ) async throws -> DecisionResult {

        let updatedApplication = try statusApplicationRepository.updateDecision(
            applicationId: application.id,
            decision: .rejected,
            reviewedByUserId: adminUser.id,
            reviewedAt: Date(),
            rejectionReason: rejectionReason
        )

        var updatedVendor = vendor
        updatedVendor.status = vendorWriteService.resolveStatusAfterDecision(
            requestType: application.requestType,
            decision: .rejected,
            currentStatusAtSubmission: application.currentStatus,
            existingVendorStatus: vendor.status
        )
        updatedVendor.updatedAt = Date()

        // Persist vendor status update (use returned summary as the source of truth)
        let persistedVendor = try await vendorWriteService.updateSummaryStatus(
            vendorId: updatedVendor.id,
            status: updatedVendor.status,
            actor: adminUser
        )

        vendorSummary = persistedVendor
        return .init(updatedApplication: updatedApplication, updatedVendor: persistedVendor)
    }
}



enum RejectionCategory: String, CaseIterable {
    case content
    case metadata
    case policy
    case manualInput

    var displayName: String {
        switch self {
        case .content: return String(localized: "asdm.rejectCategory.content")
        case .metadata: return String(localized: "asdm.rejectCategory.metadata")
        case .policy: return String(localized: "asdm.rejectCategory.policy")
        case .manualInput: return String(localized: "asdm.rejectCategory.manual")
        }
    }
}


enum RejectionTemplate: CaseIterable, Identifiable {
    case inappropriateContent
    case duplicateListing
    case invalidContact
    case rightsUnclear
    case missingRequiredInfo
    case policyViolation
    case outOfScopeService
    case unsupportedRegion
    case cannotVerifyBusiness
    case misleadingInfo
    case spamOrPromotion
    case lowQualityAssets
    case languageUnsupported
    case translationIssue
    case conflictingOwnershipClaim
    case other

    var id: Self { self }

    var category: RejectionCategory {
        switch self {
        case .inappropriateContent, .rightsUnclear, .lowQualityAssets,
             .languageUnsupported, .translationIssue, .spamOrPromotion:
            return .content
        case .duplicateListing, .invalidContact, .missingRequiredInfo, .misleadingInfo:
            return .metadata
        case .policyViolation, .conflictingOwnershipClaim, .outOfScopeService,
             .unsupportedRegion, .cannotVerifyBusiness:
            return .policy
        case .other:
            return .manualInput
        }
    }

    var displayName: String {
        switch self {
        case .other: return String(localized: "asdm.rejectTpl.other")
        case .inappropriateContent: return String(localized: "asdm.rejectTpl.inappropriateContent")
        case .duplicateListing: return String(localized: "asdm.rejectTpl.duplicateListing")
        case .invalidContact: return String(localized: "asdm.rejectTpl.invalidContact")
        case .rightsUnclear: return String(localized: "asdm.rejectTpl.rightsUnclear")
        case .missingRequiredInfo: return String(localized: "asdm.rejectTpl.missingRequiredInfo")
        case .policyViolation: return String(localized: "asdm.rejectTpl.policyViolation")
        case .outOfScopeService: return String(localized: "asdm.rejectTpl.outOfScopeService")
        case .unsupportedRegion: return String(localized: "asdm.rejectTpl.unsupportedRegion")
        case .cannotVerifyBusiness: return String(localized: "asdm.rejectTpl.cannotVerifyBusiness")
        case .misleadingInfo: return String(localized: "asdm.rejectTpl.misleadingInfo")
        case .spamOrPromotion: return String(localized: "asdm.rejectTpl.spamOrPromotion")
        case .lowQualityAssets: return String(localized: "asdm.rejectTpl.lowQualityAssets")
        case .languageUnsupported: return String(localized: "asdm.rejectTpl.languageUnsupported")
        case .translationIssue: return String(localized: "asdm.rejectTpl.translationIssue")
        case .conflictingOwnershipClaim: return String(localized: "asdm.rejectTpl.conflictingOwnershipClaim")
        }
    }

    var preview: String {
        switch self {
        case .other:
            return ""
        case .inappropriateContent:
            return String(localized: "asdm.rejectPreview.inappropriateContent")
        case .duplicateListing:
            return String(localized: "asdm.rejectPreview.duplicateListing")
        case .invalidContact:
            return String(localized: "asdm.rejectPreview.invalidContact")
        case .rightsUnclear:
            return String(localized: "asdm.rejectPreview.rightsUnclear")
        case .missingRequiredInfo:
            return String(localized: "asdm.rejectPreview.missingRequiredInfo")
        case .policyViolation:
            return String(localized: "asdm.rejectPreview.policyViolation")
        case .outOfScopeService:
            return String(localized: "asdm.rejectPreview.outOfScopeService")
        case .unsupportedRegion:
            return String(localized: "asdm.rejectPreview.unsupportedRegion")
        case .cannotVerifyBusiness:
            return String(localized: "asdm.rejectPreview.cannotVerifyBusiness")
        case .misleadingInfo:
            return String(localized: "asdm.rejectPreview.misleadingInfo")
        case .spamOrPromotion:
            return String(localized: "asdm.rejectPreview.spamOrPromotion")
        case .lowQualityAssets:
            return String(localized: "asdm.rejectPreview.lowQualityAssets")
        case .languageUnsupported:
            return String(localized: "asdm.rejectPreview.languageUnsupported")
        case .translationIssue:
            return String(localized: "asdm.rejectPreview.translationIssue")
        case .conflictingOwnershipClaim:
            return String(localized: "asdm.rejectPreview.conflictingOwnershipClaim")
        }
    }
}
