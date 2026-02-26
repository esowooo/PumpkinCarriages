import Foundation

@Observable
class MarkViewModel {
    
    var vendorList: [VendorSummary] = []
    private var markRepository: any MarkRepository { Repositories.shared.mark }
    private var openVendorReadRepository: any OpenVendorReadRepository { Repositories.shared.vendorRead.open }

    var markFetchError: Bool = false
    
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
        
    //MARK: - Read Marked Vendors
    @MainActor
    func readMarkedVendors(userId: String) async {
        markFetchError = false

        await markRepository.ensureMarkExists(forUserId: userId)

        guard let mark = await markRepository.readByUserId(userId) else {
            vendorList = []
            markFetchError = true
            return
        }

        do {
            vendorList = try await openVendorReadRepository
                .readOpenMarkSummaries(ids: mark.vendorId, preserveOrder: true)
        } catch {
            vendorList = []
            markFetchError = true
            createAlert(title: String(localized: "mkvm.alert.loadFailed.title"), message: String(localized: "mkvm.alert.loadFailed.msg"), error: error)
        }
    }
    

}
