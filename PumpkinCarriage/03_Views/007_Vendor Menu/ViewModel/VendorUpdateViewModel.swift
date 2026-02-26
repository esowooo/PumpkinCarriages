






import Foundation
import SwiftUI

@MainActor
@Observable
class VendorUpdateViewModel {
    
    private var vendorWriteService: any VendorWriteService { Services.shared.vendorWrite }
    private var portalVendorReadRepository: any VendorPortalVendorReadRepository { Repositories.shared.vendorRead.portal }
    
    var vendorSummary: VendorSummary?
    var form: VendorForm

    // Latest read / hydration state
    var vendorDetail: VendorDetail? = nil
    var vendorProfileImage: VendorProfileImage? = nil
    var isLoadingVendor: Bool = false

    // MARK: - Dirty tracking
    private struct Snapshot: Equatable {
        let formSig: FormSignature
        let imageItemsSig: [String]
        let deletedExistingImageIds: [String]
        let thumbnailItemId: String?
    }

    private struct FormSignature: Equatable {
        let name: String
        let manager: String
        let country: Country
        let city: City
        let district: String
        let districtOther: String
        let addressDetail: String
        let email: String
        let phoneCountryCode: PhoneCountryCode
        let phone: String
        let languages: [Language]
        let category: VendorCategory
        let descriptionByLang: [Language: String]
        let status: VendorStatus
        let externalLinks: [VendorForm.ExternalLinkDraft]
        let imageDrafts: [ImageDraftSignature]
    }

    private struct ImageDraftSignature: Equatable {
        let id: String
        let sortOrder: Int
        let caption: String?

        init(_ draft: ImageDraft) {
            self.id = draft.id
            self.sortOrder = draft.sortOrder
            self.caption = draft.caption
        }
    }

    private var originalSnapshot: Snapshot? = nil

    var hasChanges: Bool {
        // Register flow: no baseline -> treat as changed so validation/submit works.
        guard vendorSummary != nil, let originalSnapshot else { return true }
        return makeSnapshot() != originalSnapshot
    }

    private func makeSnapshot() -> Snapshot {
        let formSig = FormSignature(
            name: form.name,
            manager: form.manager,
            country: form.country,
            city: form.city,
            district: form.district,
            districtOther: form.districtOther,
            addressDetail: form.addressDetail,
            email: form.email,
            phoneCountryCode: form.phoneCountryCode,
            phone: form.phone,
            languages: form.languages,
            category: form.category,
            descriptionByLang: form.descriptionByLang,
            status: form.status,
            externalLinks: form.externalLinkDrafts,
            imageDrafts: form.imageDrafts.map { ImageDraftSignature($0) }
        )

        // Represent the image editor state with a stable string signature.
        // We intentionally exclude any UIImage bytes; we only care about identity + order + source.
        let itemsSig: [String] = imageItems.map { item in
            switch item.source {
            case .existing(let imageId):
                return "E:\(imageId)"
            case .draft(let draftId):
                return "D:\(draftId)"
            }
        }

        return Snapshot(
            formSig: formSig,
            imageItemsSig: itemsSig,
            deletedExistingImageIds: deletedExistingImageIds.sorted(),
            thumbnailItemId: thumbnailItemId
        )
    }

    private func captureOriginalSnapshotIfPossible() {
        // Only meaningful for update flow.
        guard vendorSummary != nil else { return }
        originalSnapshot = makeSnapshot()
    }

    
    init() {
        self.vendorSummary = nil
        self.form = VendorForm()
    }

    /// Optional fast path: show something immediately (header/prefill) while we fetch latest.
    func applyInitialSummary(_ summary: VendorSummary) {
        self.vendorSummary = summary
        self.form = VendorForm(vendor: summary)
        // NOTE: We do not capture the baseline here; update screen must use the latest hydrated data.
    }

    var imageItems: [ImageSlot] = []
    var thumbnailItemId: String? = nil
    private var deletedExistingImageIds: Set<String> = []
    private let maxImageCount: Int = 7
    
    var isSubmitting: Bool = false
    var shouldDismissOnAlert: Bool = false
    var showUpdateConfirm: Bool = false
    
    
    // Session Current User
    var currentUser: User?
    
    //error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    //var showMessage: Bool = false
    
    //MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    
    //MARK: - Access Check
    func checkAccessPermission(user: User?) {
        guard let user = user,
              user.role == Role.vendor else {
            createAlert(
                title: String(localized: "vuvm.alert.permissionDenied.title"),
                message: String(localized: "vuvm.alert.permissionDenied.msg")
            )
            shouldDismissOnAlert = true
            currentUser = nil
            return
        }
        currentUser = user
    }
    
    /// Update screen must be based on the latest data.
    /// This method loads Summary + Detail + ProfileImage and then hydrates the editor state.
    func loadLatestVendorForEditing() async {
        guard let vendorId = vendorSummary?.id else { return }

        isLoadingVendor = true
        defer { isLoadingVendor = false }

        guard let user = currentUser else {
            createAlert(
                title: String(localized: "vuvm.alert.permissionDenied.title"),
                message: String(localized: "vuvm.alert.loginAgain.msg")
            )
            shouldDismissOnAlert = true
            return
        }

        do {
            // Always read latest from portal scope (VendorUpdateView is vendor portal screen)
            guard let latestSummary = try await portalVendorReadRepository.readVendorSummary(userId: user.id, id: vendorId) else {
                createAlert(
                    title: String(localized: "vuvm.alert.error.title"),
                    message: String(localized: "vuvm.alert.vendorNotFound.msg")
                )
                shouldDismissOnAlert = true
                return
            }

            // Detail is required for the update screen. If it doesn't exist, treat as a fatal load error.
            let latestDetailOpt = try await portalVendorReadRepository.readVendorDetail(userId: user.id, id: vendorId)
            guard let latestDetail = latestDetailOpt else {
                createAlert(
                    title: String(localized: "vuvm.alert.error.title"),
                    message: String(localized: "vuvm.alert.vendorDetailNotFound.msg")
                )
                shouldDismissOnAlert = true
                return
            }

            // Profile image can be absent (e.g., no images yet) – fall back to empty.
            let latestProfileOpt = try await portalVendorReadRepository.readVendorProfileImage(userId: user.id, id: vendorId)
            let latestProfile = latestProfileOpt ?? VendorProfileImage(id: vendorId, images: [])

            // Commit latest
            self.vendorSummary = latestSummary
            self.vendorDetail = latestDetail
            self.vendorProfileImage = latestProfile

            // Hydrate form (summary + detail)
            self.form = VendorForm(summary: latestSummary, detail: latestDetail)

            // Hydrate image editor state
            VendorImageEditor.reset(
                from: latestSummary,
                existingImages: latestProfile.images,
                thumbnail: latestSummary.thumbnail,
                imageItems: &imageItems,
                thumbnailItemId: &thumbnailItemId,
                deletedExistingImageIds: &deletedExistingImageIds,
                drafts: &form.imageDrafts
            )

            // Baseline for dirty-tracking (avoid network updates when nothing changed)
            captureOriginalSnapshotIfPossible()

        } catch {
            createAlert(
                title: String(localized: "vuvm.alert.error.title"),
                message: String(localized: "vuvm.alert.loadVendorFailed.msg"),
                error: error
            )
            shouldDismissOnAlert = true
        }
    }
    
    //MARK: - Block accessing vendor in Pending/Archived Status
    func denyVendorAccess() {
        guard let vendorSummary else { return }   // allow register
        
        if vendorSummary.status.canEditVendorContent { return }
        
        createAlert(
            title: String(localized: "vuvm.alert.updateNotAllowed.title"),
            message: String(localized: "vuvm.alert.updateNotAllowed.msg")
        )
        shouldDismissOnAlert = true
    }
    
    // District
    func districtToSave(_ selection: DistrictSelection) -> String? {
        switch selection {
        case .none:
            return nil
        case .predefined(let district):
            return Validation.nonEmptyTrimmed(district)
        case .other(let district):
            return Validation.nonEmptyTrimmed(district)
        }
    }
    
    func districtSelection(district: String, other: String) -> DistrictSelection {
        let d = Validation.trimmed(district)
        if d.isEmpty || d == District.none { return .none }
        if d == District.other { return .other(Validation.trimmed(other)) }
        return .predefined(d)
    }
    
    
    //External Link
    func addExternalLinkDraft() {
        guard form.externalLinkDrafts.count < 5 else { return }
        guard form.externalLinkType != .none else {
            createAlert(
                title: String(localized: "vuvm.alert.invalidLinkType.title"),
                message: String(localized: "vuvm.alert.invalidLinkType.msg")
            )
            return
        }
        form.externalLinkDrafts.append(.init(type: form.externalLinkType, path: ""))
    }
    
    func removeExternalLinkDraft(id: String) {
        guard let idx = form.externalLinkDrafts.firstIndex(where: { $0.id == id }) else { return }
        form.externalLinkDrafts.remove(at: idx)
    }
    
    func buildExternalLinks() -> [ExternalLink] {
        form.externalLinkDrafts.compactMap { draft in
            let path = Validation.trimmed(draft.path)
            guard draft.type != .none, !path.isEmpty else { return nil }
            return ExternalLink(id: draft.id, type: draft.type, path: path)
        }
    }
    
    
    //MARK: - Validation Input Struct
    private struct ValidatedInput {
        let name: String
        let district: String
        let addressDetail: String
        let contactEmail: String?
        let contactPhone: String?
        let externalLinks: [ExternalLink]
    }
    
    //MARK: - Validation
    private func validatedInput() -> ValidatedInput? {
        
        
        
        // Trim once (local only)
        let nameTrim = Validation.trimmed(form.name)
        let emailTrim = Validation.trimmed(form.email)
        let phoneTrim = Validation.trimmed(form.phone)
        let addressDetailTrim = Validation.trimmed(form.addressDetail)
        let descJPTrim = Validation.trimmed(form.descriptionByLang[.jp] ?? "")
        
        
        // Store Name
        guard !nameTrim.isEmpty else {
            createAlert(
                title: String(localized: "vuvm.validation.storeName.invalid.title"),
                message: String(localized: "vuvm.validation.storeName.invalid.msg")
            )
            return nil
        }
        // Store Name: English-only check
        if let err = Validation.validateEnglishOnly(nameTrim, field: "Store Name") {
            createAlert(title: err.title, message: err.message)
            return nil
        }
        
        // Category
        if form.category == .all {
            createAlert(
                title: String(localized: "vuvm.validation.category.invalid.title"),
                message: String(localized: "vuvm.validation.category.invalid.msg")
            )
            return nil
        }
        
        // Country
        if form.country == .none {
            createAlert(
                title: String(localized: "vuvm.validation.country.invalid.title"),
                message: String(localized: "vuvm.validation.country.invalid.msg")
            )
            return nil
        }
        
        // City
        if form.city == .none {
            createAlert(
                title: String(localized: "vuvm.validation.city.invalid.title"),
                message: String(localized: "vuvm.validation.city.invalid.msg")
            )
            return nil
        }
        
        // District (selection -> save value)
        let selection = districtSelection(district: form.district, other: form.districtOther)
        guard let districtToSave = districtToSave(selection) else {
            createAlert(
                title: String(localized: "vuvm.validation.district.invalid.title"),
                message: String(localized: "vuvm.validation.district.invalid.msg")
            )
            return nil
        }
        // District: English-only check
        if let err = Validation.validateEnglishOnly(districtToSave, field: "District") {
            createAlert(title: err.title, message: err.message)
            return nil
        }
        
        // Address Detail
        guard !addressDetailTrim.isEmpty else {
            createAlert(
                title: String(localized: "vuvm.validation.address.invalid.title"),
                message: String(localized: "vuvm.validation.address.invalid.msg")
            )
            return nil
        }
        // Address Detail: English-only check
        if let err = Validation.validateEnglishOnly(addressDetailTrim, field: "Address Detail") {
            createAlert(title: err.title, message: err.message)
            return nil
        }
        
        // Email (optional - format check only)
        if !emailTrim.isEmpty {
            if let error = Validation.validateEmail(emailTrim) {
                createAlert(title: error.title, message: error.message)
                return nil
            }
        }
        
        // Phone (optional - format check only)
        if let error = Validation.validateOptionalPhone(
            local: phoneTrim,
            countryCode: form.phoneCountryCode,
            minDigits: 10
        ) {
            createAlert(title: error.title, message: error.message)
            return nil
        }
        
        // Languages (at least one required)
        if form.languages.isEmpty {
            createAlert(
                title: String(localized: "vuvm.validation.language.required.title"),
                message: String(localized: "vuvm.validation.language.required.msg")
            )
            return nil
        }
        
        // Description (JP required)
        guard !descJPTrim.isEmpty else {
            createAlert(
                title: String(localized: "vuvm.validation.description.required.title"),
                message: String(localized: "vuvm.validation.description.required.msg")
            )
            return nil
        }
        if descJPTrim.count < 10 {
            createAlert(
                title: String(localized: "vuvm.validation.description.tooShort.title"),
                message: String(localized: "vuvm.validation.description.tooShort.msg")
            )
            return nil
        }
        
        // External Links (if rows exist they must be valid)
        let linkTuples = form.externalLinkDrafts.map { (type: $0.type, path: Validation.trimmed($0.path)) }
        if let error = Validation.validateExternalLinks(linkTuples) {
            createAlert(title: error.title, message: error.message)
            return nil
        }
        
        // Optional phone to save
        let phoneToSave: String?
        if phoneTrim.isEmpty || form.phoneCountryCode == .none {
            phoneToSave = nil
        } else {
            phoneToSave = form.phoneCountryCode.rawValue + phoneTrim
        }
        
        // Build links (trim paths)
        let linksToSave = buildExternalLinks()
        
        return ValidatedInput(
            name: nameTrim,
            district: districtToSave,
            addressDetail: addressDetailTrim,
            contactEmail: emailTrim.isEmpty ? nil : emailTrim,
            contactPhone: phoneToSave,
            externalLinks: linksToSave
        )
    }
    
    
    //MARK: - Draft Images (Grid Policy)
    func attachImages(_ drafts: [ImageDraft]) {
        addDraftImages(drafts)
    }
    
    func addDraftImages(_ drafts: [ImageDraft]) {
        VendorImageEditor.addDraftImages(
            drafts,
            imageItems: &imageItems,
            draftsStore: &form.imageDrafts,
            thumbnailItemId: &thumbnailItemId,
            maxImageCount: maxImageCount,
            onLimitReached: { [weak self] in
                guard let self = self else { return }
                self.createAlert(
                    title: String(localized: "vuvm.alert.imageLimit.title"),
                    message: String(format: String(localized: "vuvm.alert.imageLimit.format"), self.maxImageCount)
                )
            }
        )
    }

    func removeImage(itemId: String) {
        guard let idx = imageItems.firstIndex(where: { $0.id == itemId }) else { return }
        let item = imageItems[idx]

        switch item.source {
        case .existing(let imageId):
            deletedExistingImageIds.insert(imageId)
        case .draft(let draftId):
            form.imageDrafts.removeAll(where: { $0.id == draftId })
        }

        imageItems.remove(at: idx)

        // If removed item was the thumbnail, fallback.
        if thumbnailItemId == itemId {
            thumbnailItemId = imageItems.first?.id
        }

        VendorImageEditor.normalizeOrder(
            imageItems: &imageItems,
            drafts: &form.imageDrafts,
            thumbnailItemId: &thumbnailItemId
        )
    }

    func setThumbnail(itemId: String) {
        guard imageItems.contains(where: { $0.id == itemId }) else { return }
        thumbnailItemId = itemId
    }

    func moveImage(fromId: String, toId: String) {
        guard fromId != toId,
              let fromIndexOriginal = imageItems.firstIndex(where: { $0.id == fromId }),
              let toIndexOriginal = imageItems.firstIndex(where: { $0.id == toId }) else { return }

        let moved = imageItems.remove(at: fromIndexOriginal)
        let targetIndexAfterRemoval = imageItems.firstIndex(where: { $0.id == toId })

        var insertIndex: Int
        if let targetIndexAfterRemoval {
            if fromIndexOriginal < toIndexOriginal {
                insertIndex = targetIndexAfterRemoval + 1
            } else {
                insertIndex = targetIndexAfterRemoval
            }
        } else {
            insertIndex = imageItems.count
        }

        insertIndex = max(0, min(insertIndex, imageItems.count))
        imageItems.insert(moved, at: insertIndex)

        VendorImageEditor.normalizeOrder(
            imageItems: &imageItems,
            drafts: &form.imageDrafts,
            thumbnailItemId: &thumbnailItemId
        )
    }
    
    
    
    func submit() {
        shouldDismissOnAlert = false
        showUpdateConfirm = false
        
        guard !isSubmitting else { return }
        // Update flow: if nothing changed, avoid hitting the network.
        if vendorSummary != nil, hasChanges == false {
            createAlert(
                title: String(localized: "vuvm.alert.noChanges.title"),
                message: String(localized: "vuvm.alert.noChanges.msg")
            )
            shouldDismissOnAlert = true
            return
        }
        guard let input = validatedInput() else { return }
        
        Task { await submitAsync(using: input) }
    }
    
    private func submitAsync(using input: ValidatedInput) async {
        guard !isSubmitting else { return }
        isSubmitting = true
        defer { isSubmitting = false }

        // Reconfirm Login Status
        guard let currentUser = currentUser,
              currentUser.role == Role.vendor else {
            createAlert(
                title: String(localized: "vuvm.alert.permissionDenied.title"),
                message: String(localized: "vuvm.alert.sessionInvalid.msg")
            )
            shouldDismissOnAlert = true
            return
        }


        let serviceInput = VendorValidatedInput(
            name: input.name,
            district: input.district,
            addressDetail: input.addressDetail,
            description: form.makeDescriptionLocalizedText(),
            contactEmail: input.contactEmail,
            contactPhone: input.contactPhone,
            externalLinks: input.externalLinks
        )

        do {
            if let vendorId = vendorSummary?.id {
                let saved = try await vendorWriteService.updateVendor(
                    vendorId: vendorId,
                    input: serviceInput,
                    form: form,
                    imageItems: imageItems,
                    deletedExistingImageIds: deletedExistingImageIds,
                    thumbnailItemId: thumbnailItemId,
                    drafts: form.imageDrafts,
                    uploader: currentUser,
                    config: .networkMinimized
                )

                self.vendorSummary = saved
                await loadLatestVendorForEditing()

                alertTitle = String(localized: "vuvm.success.updated.title")
                alertMessage = ""
                shouldDismissOnAlert = true
                showAlert = true

            } else {
                let saved = try await vendorWriteService.registerVendor(
                    input: serviceInput,
                    form: form,
                    imageItems: imageItems,
                    thumbnailItemId: thumbnailItemId,
                    drafts: form.imageDrafts,
                    uploader: currentUser,
                    config: .networkMinimized
                )

                self.vendorSummary = saved
                await loadLatestVendorForEditing()

                alertTitle = String(localized: "vuvm.success.registered.title")
                alertMessage = String(localized: "vuvm.success.registered.msg")
                shouldDismissOnAlert = true
                showAlert = true
            }
        } catch let e as VendorWriteServiceError {
            createAlert(title: e.title, message: e.message, error: e.underlying)
        } catch {
            createAlert(
                title: String(localized: "vuvm.alert.error.title"),
                message: String(localized: "vuvm.alert.tryAgain.msg"),
                error: error
            )
        }
    }
}
