






import Foundation

@Observable
class VendorReviewViewModel {
    
    private var portalVendorReadRepository: any VendorPortalVendorReadRepository { Repositories.shared.vendorRead.portal }
    
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
            if let latest = try await portalVendorReadRepository.readVendorSummary(userId: userId, id: vendorId) {
                vendorSummary = latest
            }
        } catch {
            // Non-fatal: keep showing the passed-in summary.
            createMessage(
                title: String(localized: "vrvm.message.warning.title"),
                message: String(localized: "vrvm.message.refreshSummaryFailed.msg"),
                error: error
            )
        }
    }
    
    //Read VendorDetail
    @MainActor
    private func readVendorDetail(userId: String, vendorId: String) async {
        do {
            let detail = try await portalVendorReadRepository.readVendorDetail(userId: userId,id: vendorId)
            self.vendorDetail = detail
        } catch {
            createMessage(
                title: String(localized: "vrvm.message.warning.title"),
                message: String(localized: "vrvm.message.loadDetailFailed.msg"),
                error: error
            )
        }
    }
    
    //Read VendorImage
    @MainActor
    private func readVendorImage(userId: String, vendorId: String) async {
        do {
            let profile = try await portalVendorReadRepository.readVendorProfileImage(userId: userId,id: vendorId)
            self.vendorProfileImage = profile
        } catch {
            createMessage(
                title: String(localized: "vrvm.message.warning.title"),
                message: String(localized: "vrvm.message.loadImagesFailed.msg"),
                error: error
            )
        }
    }
    
    
}
