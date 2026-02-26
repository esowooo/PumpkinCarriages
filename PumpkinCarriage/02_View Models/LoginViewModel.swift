import Foundation

@Observable
class LoginViewModel {
    private var authService: any AuthService { Services.shared.auth }
    
    //TODO: - Remove before release (testing purpose)
    var email: String = ""
    var password: String = ""
    var showPassword: Bool = false
    
    var presentRegisterView: Bool = false
    
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
    
    private func show(_ error: ValidationError) {
        createAlert(title: error.title, message: error.message)
    }
    
    //MARK: - Validation (Prototype)
    func validate() -> Bool {
        
        if let error = Validation.validateRequired(email, password) {
            show(error)
            return false
        }
        
        if let error = Validation.validateEmail(email) {
            show(error)
            return false
        }
        
        if let error = Validation.validatePassword(password) {
            show(error)
            return false
        }
        
        return true
    }
    
    
    
    //MARK: - Login (Prototype)
    func authentication(sessionManager: SessionManager) -> User? {

        guard validate() else { return nil }

        do {
            return try authService.signIn(
                email: email,
                password: password,
                sessionManager: sessionManager
            )
        } 
        catch AuthError.invalidEmail {
            createAlert(title: String(localized: "lvm.alert.invalidEmail.title"), message: String(localized: "lvm.alert.invalidEmail.msg"))
            return nil
        } catch AuthError.inactiveUser {
            createAlert(
                title: String(localized: "lvm.alert.loginFailed.title"),
                message: String(localized: "lvm.alert.inactiveUser.msg")
            )
            return nil
        } catch AuthError.invalidPassword(let hasHint) {
            if hasHint {
                createAlert(
                    title: String(localized: "lvm.alert.invalidPassword.title"),
                    message: String(localized: "lvm.alert.invalidPassword.hintMsg")
                )
            } else {
                createAlert(title: String(localized: "lvm.alert.invalidPassword.title"), message: String(localized: "lvm.alert.invalidPassword.msg"))
            }
            return nil
        } catch {
            createAlert(title: String(localized: "lvm.alert.loginFailed.title"), message: String(localized: "lvm.alert.unexpected.msg"), error: error)
            return nil
        }
    }
    
    
}
