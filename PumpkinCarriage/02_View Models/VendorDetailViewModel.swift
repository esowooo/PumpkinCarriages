import Foundation

@Observable
class VendorDetailViewModel {
    
    private var openVendorReadRepository: any OpenVendorReadRepository { Repositories.shared.vendorRead.open }
    private var markRepository: any MarkRepository { Repositories.shared.mark }
    private var vendorWriteService: any VendorWriteService { Services.shared.vendorWrite }
    
    private let publicId: String

    var vendorSummary: VendorSummary?
    var vendorDetail: VendorDetail?
    var vendorProfileImage: VendorProfileImage?
    
    init(publicId: String, initialSummary: VendorSummary? = nil) {
        self.publicId = publicId
        self.vendorSummary = initialSummary
    }
    
    var isMarked = false
    
    //error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    var showMessage: Bool = false
    
    //MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
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
    
    @MainActor
    private func resolveVendorSummaryByPublicId() async {
        do {
            if let latest = try await openVendorReadRepository.readOpenSummary(publicId: publicId) {
                vendorSummary = latest
            }
        } catch {
            createMessage(
                title: String(localized: "vdvm.message.warning.title"),
                message: String(localized: "vdvm.message.refreshSummaryFailed.msg"),
                error: error
            )
        }
    }
    
    @MainActor
    func loadInitialState(currentUserId: String?) async {

        if vendorSummary == nil {
            await resolveVendorSummaryByPublicId()
        }

        guard let vendorId = vendorSummary?.id else {
            createMessage(
                title: String(localized: "vdvm.message.warning.title"),
                message: String(localized: "vdvm.message.vendorNotFound.msg")
            )
            return
        }

        async let detailTask: Void = readVendorDetail(vendorId: vendorId)
        async let imageTask: Void = readVendorImage(vendorId: vendorId)

        if let userId = currentUserId {
            await checkIfMarked(userId: userId, vendorId: vendorId)
        } else {
            isMarked = false
        }

        _ = await (detailTask, imageTask)
    }
    
    //MARK: - Initial Setup Methods
    // Refresh summary in the background to avoid stale data.
    @MainActor
    func refreshVendorSummary(vendorId: String) async {
        do {
            // If your OpenVendorReadRepository uses a different name, adjust this call.
            if let latest = try await openVendorReadRepository.readOpenSummary(id: vendorId) {
                vendorSummary = latest
            }
        } catch {
            // Non-fatal: keep showing the passed-in summary.
            createMessage(title: String(localized: "vdvm.message.warning.title"), message: String(localized: "vdvm.message.refreshSummaryFailed.msg"), error: error)
        }
    }
    
    //Read VendorDetail
    @MainActor
    func readVendorDetail(vendorId: String) async {
        do {
            let detail = try await openVendorReadRepository.readOpenDetail(id: vendorId)
            self.vendorDetail = detail
        } catch {
            createMessage(title: String(localized: "vdvm.message.warning.title"), message: String(localized: "vdvm.message.loadDetailFailed.msg"), error: error)
        }
    }
    
    //Read VendorImage
    @MainActor
    func readVendorImage(vendorId: String) async {
        do {
            let profile = try await openVendorReadRepository.readOpenProfileImage(id: vendorId)
            self.vendorProfileImage = profile
        } catch {
            createMessage(title: String(localized: "vdvm.message.warning.title"), message: String(localized: "vdvm.message.loadImagesFailed.msg"), error: error)
        }
    }
    
    //Read if User Marked Vendor
    func checkIfMarked(userId: String, vendorId: String) async {
        isMarked = await markRepository.checkIfMarked(userId: userId, vendorId: vendorId)
    }
    
    
    //MARK: - Update Methods
    //Update Mark
    func updateMark(userId: String, vendorId: String) async {
        do {
            try markRepository.updateMarkVendorList(userId: userId, vendorId: vendorId)
        } catch {
            createMessage(title: String(localized: "vdvm.message.warning.title"), message: String(localized: "vdvm.message.updateBookmarkFailed.msg"), error: error)
        }
    }

    //Update Vendor
    func applyVendorMarkCount(
        vendorId: String,
        wasMarked: Bool
    ) async {
        guard var summary = vendorSummary else {
            createMessage(
                title: String(localized: "vdvm.message.warning.title"),
                message: String(localized: "vdvm.message.vendorNotFound.msg")
            )
            return
        }

        let delta = wasMarked ? -1 : 1

        // Optimistic UI update
        summary.markCount = max(0, summary.markCount + delta)
        vendorSummary = summary

        do {
            let updated = try await vendorWriteService.updateSummaryMarkCount(
                vendorId: vendorId,
                delta: delta
            )
            summary.markCount = updated.markCount
            vendorSummary = summary
        } catch {
            // Rollback optimistic UI update
            summary.markCount = max(0, summary.markCount - delta)
            vendorSummary = summary

            createMessage(
                title: String(localized: "vdvm.message.warning.title"),
                message: String(localized: "vdvm.message.updateBookmarkCountFailed.msg"),
                error: error
            )
        }
    }
    
    //Update mark count for vendor
    func toggleBookmark(vendorId: String,currentUser: User?) async {
        // 1. User Sigin Status Check
        guard let user = currentUser else {
            createAlert(title: String(localized: "vdvm.alert.error.title"), message: String(localized: "vdvm.alert.signInToUseBookmarks.msg"))
            return
        }

        // 2. pre-Determine pre-toggle state (source of truth)
        let wasMarked = await markRepository.checkIfMarked(userId: user.id, vendorId: vendorId)
        
        // 3. Update User's Mark
        await updateMark(userId: user.id, vendorId: vendorId)
        
        // 4. Update MarkCount for Vendor (Move to Firebase Cloud Functions)
        await applyVendorMarkCount(vendorId: vendorId, wasMarked: wasMarked)
        
        // 5. Update UI
        isMarked = !wasMarked
    }
    
    
}
