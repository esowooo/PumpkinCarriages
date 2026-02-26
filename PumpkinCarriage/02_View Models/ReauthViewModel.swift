import Foundation

@MainActor
@Observable
final class ReauthViewModel {

    private var authService: any AuthService { Services.shared.auth }

    // TODO: remove defaults before release
    var email: String = ""
    var password: String = ""
    var showPassword: Bool = false

    // error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false

    private func createAlert(title: String, message: String, error: Error? = nil) {
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

    /// Reauth WITHOUT mutating the current session.
    func reauth(expectedUserId: String) -> ReauthResult {
        guard validate() else { return .wrongCredential }

        do {
            let user = try authService.reauth(email: email, password: password)

            if user.id != expectedUserId {
                createAlert(
                    title: String(localized: "rvm.alert.differentUser.title"),
                    message: String(localized: "rvm.alert.differentUser.msg")
                )
                return .differentUser
            }

            return .success(userId: user.id)

        } catch AuthError.invalidEmail {
            createAlert(
                title: String(localized: "rvm.alert.invalidEmail.title"),
                message: String(localized: "rvm.alert.invalidEmail.msg")
            )
            return .wrongCredential

        } catch AuthError.inactiveUser {
            createAlert(
                title: String(localized: "rvm.alert.inactiveUser.title"),
                message: String(localized: "rvm.alert.inactiveUser.msg")
            )
            return .inactiveUser
        } catch AuthError.invalidPassword(let hasHint) {
            if hasHint {
                createAlert(
                    title: String(localized: "rvm.alert.invalidPassword.title"),
                    message: String(localized: "rvm.alert.invalidPassword.hintMsg")
                )
            } else {
                createAlert(
                    title: String(localized: "rvm.alert.invalidPassword.title"),
                    message: String(localized: "rvm.alert.invalidPassword.msg")
                )
            }
            return .wrongCredential

        } catch {
            createAlert(
                title: String(localized: "rvm.alert.loginFailed.title"),
                message: String(localized: "rvm.alert.unexpected.msg"),
                error: error
            )
            return .wrongCredential
        }
    }
}

enum ReauthResult {
    case success(userId: String)
    case wrongCredential
    case differentUser
    case requiresSignIn
    case inactiveUser
}
