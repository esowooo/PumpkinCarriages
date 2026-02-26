






import Foundation

@MainActor
@Observable
class VendorManageViewModel {
    
    private var portalVendorReadRepository: any VendorPortalVendorReadRepository { Repositories.shared.vendorRead.portal }
    
    var currentUser: User?
    var shouldDismissOnAlert: Bool = false
    var managedVendors: [VendorSummary] = []
    
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
    
    
    //MARK: - Access Check
    func checkAccessPermission(user: User?) {
        guard let user = user,
              user.role == Role.vendor else {
            shouldDismissOnAlert = true
            createAlert(
                title: String(localized: "vmanvm.alert.permissionDenied.title"),
                message: String(localized: "vmanvm.alert.permissionDenied.msg")
            )
            return
        }
        currentUser = user
    }
    
    //MARK: - Fetch Managed Vendors (Prototype)
    func readManagedVendors() async {
        guard let currentUser = currentUser else {
            shouldDismissOnAlert = true
            createAlert(
                title: String(localized: "vmanvm.alert.error.title"),
                message: String(localized: "vmanvm.alert.accessConfirmFailed.msg")
            )
            return
        }
        
        do {
            // Vendor can see only their own (store/repo scope should enforce visibility).
            managedVendors = try await portalVendorReadRepository.readVendorSummaries(
                userId: currentUser.id,
                query: VendorQuery()
            )
            
            // Defensive: if any archived slipped through in mock, hide them for vendors.
            managedVendors.removeAll(where: { $0.status == .archived })
            
        } catch {
            createAlert(
                title: String(localized: "vmanvm.alert.loadFailed.title"),
                message: String(localized: "vmanvm.alert.tryAgain.msg"),
                error: error
            )
        }
    }
}
