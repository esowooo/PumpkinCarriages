import Foundation

@MainActor
@Observable
class AdminVendorDetailViewModel {
    private var adminVendorReadRepository: any AdminVendorReadRepository { Repositories.shared.vendorRead.admin }
    private var vendorWriteService: any VendorWriteService { Services.shared.vendorWrite }
    
    var vendorSummary: VendorSummary
    var vendorDetail: VendorDetail?
    var vendorProfileImage: VendorProfileImage?
    
    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
    }
    
    
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
    
    //MARK: - Initial Setup
    @MainActor
    func loadInitialState(vendorId: String, currentUserId: String?) async {

        guard let currentUserId = currentUserId else {
            return
        }
        
        // async
        async let summaryTask: Void = refreshVendorSummary(userId: currentUserId, vendorId: vendorId)

        // In parallel, load detail + images
        async let detailTask: Void = readVendorDetail(userId: currentUserId, vendorId: vendorId)
        async let imageTask: Void = readVendorImage(userId: currentUserId, vendorId: vendorId)

        // 3) await detail/image
        _ = await (summaryTask, detailTask, imageTask)
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
            createMessage(title: String(localized: "avdvm.message.warning.title"), message: String(localized: "avdvm.message.refreshSummaryFailed.msg"), error: error)
        }
    }
    
    //Read VendorDetail
    @MainActor
    private func readVendorDetail(userId: String, vendorId: String) async {
        do {
            let detail = try await adminVendorReadRepository.readAdminDetail(id: vendorId)
            self.vendorDetail = detail
        } catch {
            createMessage(title: String(localized: "avdvm.message.warning.title"), message: String(localized: "avdvm.message.loadDetailFailed.msg"), error: error)
        }
    }
    
    //Read VendorImage
    @MainActor
    private func readVendorImage(userId: String, vendorId: String) async {
        do {
            let profile = try await adminVendorReadRepository.readAdminProfileImage(id: vendorId)
            self.vendorProfileImage = profile
        } catch {
            createMessage(title: String(localized: "avdvm.message.warning.title"), message: String(localized: "avdvm.message.loadImagesFailed.msg"), error: error)
        }
    }
    
    @MainActor
    func changeStatus(vendorId: String, status: VendorStatus, actor: User?) async -> Bool {

        guard let actor else {
            createAlert(title: String(localized: "avdvm.alert.error.title"), message: String(localized: "avdvm.alert.sessionExpired.msg"))
            return false
        }

        guard actor.role == .admin else {
            createAlert(title: String(localized: "avdvm.alert.permissionDenied.title"), message: String(localized: "avdvm.alert.onlyAdminCanChangeStatus.msg"))
            return false
        }

        do {
            let updated = try await vendorWriteService.updateSummaryStatus(
                vendorId: vendorId,
                status: status,
                actor: actor
            )
            vendorSummary = updated
            createMessage(
                title: String(localized: "avdvm.message.updated.title"),
                message: String(format: String(localized: "avdvm.message.statusChanged.format"), String(describing: status))
            )
            return true
        } catch {
            createAlert(title: String(localized: "avdvm.alert.failed.title"), message: String(localized: "avdvm.alert.changeStatusFailed.msg"), error: error)
            return false
        }
    }
}
