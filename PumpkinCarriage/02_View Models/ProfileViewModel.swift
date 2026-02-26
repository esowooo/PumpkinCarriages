import Foundation

@MainActor
@Observable
class ProfileViewModel {
    
    
    var user: User = User.guest
    
    //Profile Menu
    //var showHistory = false
    var showSetting = false
    var showNotifications = false
    var showFAQ = false
    var showInquiry = false
    //var showGuide = false
    //var showApply = false
    
    //Vendor Menu
    var showVendorPortal = false
    
    //Login Confirmation
    var showLoginConfirmation = false
    var pendingDestination: ProtectedDestination? = nil
    var activeDestination: ProtectedDestination? = nil
    
    enum ProtectedDestination: Identifiable, Hashable {
        //case editProfile(userId: String)
        case applyVendor(userId: String)

        var id: String {
            switch self {
            //case .editProfile(let userId): return "editProfile-\(userId)"
            case .applyVendor(let userId): return "applyVendor-\(userId)"
            }
        }
    }
    
    //Admin Menu
    var showAdminPortal = false
    
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
    
    
    func fetchCurrentUser(session: SessionManager) {
        if session.sessionState == .signedIn {
            if let currentUser = session.currentUser {
                self.user = currentUser
            } else {
                self.user = User.guest
            }
        } else {
            self.user = User.guest
        }
    }
    
    
    func accessVendorPortal() -> Bool {
        if self.user.role == Role.vendor {
            return true
        } else {
            createMessage(title: String(localized: "pvm.message.error.title"), message: String(localized: "pvm.message.loginFirst.msg"))
            return false
        }
    }
    
    func accessAdminPortal() -> Bool {
        if self.user.role == Role.admin {
            return true
        } else {
            createMessage(title: String(localized: "pvm.message.error.title"), message: String(localized: "pvm.message.loginFirst.msg"))
            return false
        }
    }
    
}

