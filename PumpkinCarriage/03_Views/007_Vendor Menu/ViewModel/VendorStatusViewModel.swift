import Foundation

@MainActor
@Observable
class VendorStatusViewModel {

    private var portalVendorReadRepository: any VendorPortalVendorReadRepository { Repositories.shared.vendorRead.portal }
    private var statusApplicationRepository: any StatusApplicationRepository { Repositories.shared.statusApplication }
    private var vendorWriteService: any VendorWriteService { Services.shared.vendorWrite }

    struct StatusSheetContext: Identifiable {
        let id = UUID()
        let action: StatusRequestAction
        let vendorName: String
        let vendorStatus: VendorStatus
        let vendorCountry: Country
    }

    var vendorSummary: VendorSummary
    var vendorDetail: VendorDetail?
    var vendorProfileImage: VendorProfileImage?
    private(set) var latestStatusApplication: VendorStatusApplication? = nil
    private(set) var lastSubmissionAt: Date? = nil
    private(set) var lastSubmissionKind: VendorStatusApplicationEventType? = nil
    
    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
    }

    var currentUser: User? = nil
    var status: VendorStatus { vendorSummary.status }

    var action: StatusRequestAction = .applyForActivation
    var sheetContext: StatusSheetContext?
    var isLoading = true
    var shouldDismissOnAlert = false
    var showEdit = false

    // UI per status
    var canEdit: Bool { status == .active || status == .hidden || status == .rejected }
    var canRequestToHide: Bool { status == .active }
    var canRequestToDelete: Bool { status == .active || status == .hidden || status == .rejected }

    var isHidden: Bool { status == .hidden }
    var isRejected: Bool { status == .rejected }
    var isPending: Bool { status == .pending }

    enum SubmitResult {
        case ok(action: StatusRequestAction, target: VendorStatus)
        case duplicatePending(action: StatusRequestAction)
        case vendorNotFound
        case invalidAction
    }

    func successMessage(action: StatusRequestAction, target: VendorStatus) -> String {
        switch action {
        case .applyForActivation, .resubmitForReview, .requestToHide, .requestToArchive:
            return String(localized: "vsvm.success.requestReceived")
        }
    }

    // MARK: - Alerts
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    var showMessage: Bool = false

    func createAlert(title: String, message: String, error: Error? = nil) {
        if let error = error { print(error.localizedDescription) }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func createMessage(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showMessage = true
    }

    // MARK: - Access Check (Prototype)
    func checkAccessPermission(user: User?) -> Bool {
        guard let user = user, user.role == Role.vendor else {
            shouldDismissOnAlert = true
            createAlert(
                title: String(localized: "vsvm.alert.permissionDenied.title"),
                message: String(localized: "vsvm.alert.permissionDenied.msg")
            )
            isLoading = false
            currentUser = nil
            return false
        }
        currentUser = user
        return true
    }

    // MARK: - Initial Setup
    func loadInitialState(vendorId: String, currentUserId: String?) async {
        isLoading = true
        defer { isLoading = false }

        guard let currentUserId else {
            createAlert(
                title: String(localized: "vsvm.alert.error.title"),
                message: String(localized: "vsvm.alert.userContextMissing.msg")
            )
            return
        }

        async let summaryTask: Void = refreshVendorSummary(userId: currentUserId, vendorId: vendorId)
        async let detailTask: Void = readVendorDetail(userId: currentUserId, vendorId: vendorId)
        async let appTask: Void = refreshLatestStatusApplication(vendorId: vendorId)

        _ = await (summaryTask, detailTask, appTask)
    }
    
    
    private func refreshVendorSummary(userId: String, vendorId: String) async {
        do {
            if let latest = try await portalVendorReadRepository.readVendorSummary(userId: userId, id: vendorId) {
                vendorSummary = latest
            }
        } catch {
            createAlert(title: String(localized: "vsvm.alert.warning.title"), message: String(localized: "vsvm.alert.refreshSummaryFailed.msg"), error: error)
        }
    }

    private func readVendorDetail(userId: String, vendorId: String) async {
        do {
            let detail = try await portalVendorReadRepository.readVendorDetail(userId: userId, id: vendorId)
            self.vendorDetail = detail
        } catch {
            createAlert(title: String(localized: "vsvm.alert.warning.title"), message: String(localized: "vsvm.alert.loadDetailFailed.msg"), error: error)
        }
    }
    
    // MARK: - Status Application (Latest + Last Submission)
    private func refreshLatestStatusApplication(vendorId: String) async {
        // NOTE: repository is sync (mock) right now.
        latestStatusApplication = statusApplicationRepository.readByVendorId(vendorId)

        guard let app = latestStatusApplication else {
            lastSubmissionAt = nil
            lastSubmissionKind = nil
            return
        }

        let events = statusApplicationRepository.listEvents(statusApplicationId: app.id)

        if let last = events
            .filter({ $0.type == .submitted || $0.type == .resubmitted })
            .max(by: { $0.occurredAt < $1.occurredAt }) {

            lastSubmissionAt = last.occurredAt
            lastSubmissionKind = last.type
        } else {
            lastSubmissionAt = nil
            lastSubmissionKind = nil
        }
    }

    func lastSubmissionDisplayText() -> String? {
        guard let kind = lastSubmissionKind else { return nil }
        switch kind {
        case .submitted:
            return String(localized: "vsv.timeline.submitted")
        case .resubmitted:
            return String(localized: "vsv.timeline.resubmitted")
        default:
            return nil
        }
    }

    // MARK: - Application Processing
    func submitStatusRequest(
        _ app: VendorStatusApplication,
        action: StatusRequestAction,
        completion: (SubmitResult) -> Void
    ) {
        guard let target = validateSubmit(app: app, action: action, completion: completion) else {
            return
        }

        let now = Date()
        let actorUserId = currentUser?.id ?? app.applicantUserId

        do {
            let savedApp = try statusApplicationRepository.submitOrResubmit(
                app,
                actorUserId: actorUserId,
                now: now
            )

            let previousStatus = applyOptimisticStatus(target: target, now: now)
            completion(.ok(action: action, target: target))

            persistVendorStatusUpdate(
                savedApp: savedApp,
                target: target,
                previousStatus: previousStatus
            )

        } catch {
            handleSubmitError(error, action: action, completion: completion)
        }
    }
    
    func presentStatusRequestSheet(_ newAction: StatusRequestAction) {
        sheetContext = .init(
            action: newAction,
            vendorName: vendorSummary.name,
            vendorStatus: vendorSummary.status,
            vendorCountry: vendorSummary.locationCountry
        )
    }

    private func canCreatePendingRequest(vendorId: String, type: VendorStatusRequestType) -> Bool {
        !statusApplicationRepository.hasPending(vendorId: vendorId, requestType: type)
    }

    private func nextStatus(for action: StatusRequestAction, current: VendorStatus) -> VendorStatus? {
        switch action {
        case .applyForActivation, .resubmitForReview:
            return .pending
        case .requestToHide:
            return .hidden
        case .requestToArchive:
            return .archived
        }
    }

    private func validateSubmit(
        app: VendorStatusApplication,
        action: StatusRequestAction,
        completion: (SubmitResult) -> Void
    ) -> VendorStatus? {
        guard canCreatePendingRequest(vendorId: app.vendorId, type: app.requestType) else {
            createAlert(
                title: String(localized: "vsvm.alert.duplicatePending.title"),
                message: String(localized: "vsvm.alert.duplicatePending.msg")
            )
            completion(.duplicatePending(action: action))
            return nil
        }

        guard let target = nextStatus(for: action, current: vendorSummary.status) else {
            completion(.invalidAction)
            return nil
        }

        return target
    }

    private func applyOptimisticStatus(target: VendorStatus, now: Date) -> VendorStatus {
        let previous = vendorSummary.status
        vendorSummary.status = target
        vendorSummary.updatedAt = now
        return previous
    }

    private func persistVendorStatusUpdate(
        savedApp: VendorStatusApplication,
        target: VendorStatus,
        previousStatus: VendorStatus
    ) {
        Task { @MainActor in
            guard let actor = currentUser else {
                vendorSummary.status = previousStatus
                createAlert(
                    title: String(localized: "vsvm.alert.saveFailed.title"),
                    message: String(localized: "vsvm.alert.saveFailed.userContextMissing.msg")
                )
                return
            }

            do {
                let updated = try await vendorWriteService.updateSummaryStatus(
                    vendorId: savedApp.vendorId,
                    status: target,
                    actor: actor
                )
                vendorSummary = updated

                // Best-effort audit event
                try? statusApplicationRepository.appendVendorStatusApplied(
                    applicationId: savedApp.id,
                    actorUserId: actor.id,
                    occurredAt: Date()
                )

            } catch {
                // revert if persistence fails
                vendorSummary.status = previousStatus
                createAlert(
                    title: String(localized: "vsvm.alert.saveFailed.title"),
                    message: String(localized: "vsvm.alert.saveFailed.updateStatusFailed.msg"),
                    error: error
                )
            }
        }
    }

    private func handleSubmitError(
        _ error: Error,
        action: StatusRequestAction,
        completion: (SubmitResult) -> Void
    ) {
        if let repoError = error as? StatusApplicationRepositoryError {
            switch repoError {
            case .duplicatePending:
                createAlert(
                    title: String(localized: "vsvm.alert.duplicatePending.title"),
                    message: String(localized: "vsvm.alert.duplicatePending.msg"),
                    error: repoError
                )
                completion(.duplicatePending(action: action))

            case .notFound:
                createAlert(
                    title: String(localized: "vsvm.alert.error.title"),
                    message: String(localized: "vsvm.alert.statusAppNotFound.msg"),
                    error: repoError
                )
                completion(.vendorNotFound)
            }
            return
        }

        createAlert(
            title: String(localized: "vsvm.alert.error.title"),
            message: String(localized: "vsvm.alert.submitFailed.msg"),
            error: error
        )
        completion(.vendorNotFound)
    }
}

