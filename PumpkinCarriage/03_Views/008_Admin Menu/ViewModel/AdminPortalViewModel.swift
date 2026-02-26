






import Foundation

@Observable
class AdminPortalViewModel {
    
    var currentUser: User?
    var shouldDismissOnAlert = false

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
    func checkAccessPermission(user: User?) {
        guard let user = user,
              user.role == Role.admin else {
            shouldDismissOnAlert = true
            createAlert(
                title: String(localized: "apvm.alert.permissionDenied.title"),
                message: String(localized: "apvm.alert.permissionDenied.msg")
            )
            return
        }
        currentUser = user
    }

    
}
