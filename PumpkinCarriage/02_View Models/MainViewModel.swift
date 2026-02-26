import Foundation

@Observable
class MainViewModel {
    
    private var openVendorReadRepository: any OpenVendorReadRepository { Repositories.shared.vendorRead.open }

    
    var bannerImages: [String] = ["main1", "main2", "main3", "main4", "main5", "main6"]
    var currentIndex = 0
    
    var showMainListView = false
    var category: VendorCategory = .all
    
    var vendorList: [VendorSummary] = []
    
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
    func fetchTop10Vendors() async {
        do {
            vendorList = try await openVendorReadRepository.readOpenTopSummaries(limit: 10)
        } catch {
            createAlert(title: String(localized: "mvm.alert.loadFailed.title"), message: String(localized: "mvm.alert.loadFailed.msg"), error: error)
        }
    }
    
    
    func moveToNextBanner() {
        guard !bannerImages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % bannerImages.count
    }
    
}
