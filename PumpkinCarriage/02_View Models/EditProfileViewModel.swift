import Foundation

@MainActor
@Observable
class EditProfileViewModel {

    private var userRepository: any UserRepository { Repositories.shared.user }

    var currentUser: User? = nil
    var showPassword = false

    // Baseline / Dirty tracking (UserForm-based)
    private var baselineUser: User?
    private var baselineForm: UserUpdateForm?

    private var proposedForm: UserUpdateForm {
        UserUpdateForm(
            email: email,
            username: username,
            password: password,
            selectedCountry: selectedCountry,
            selectedCity: selectedCity,
            selectedRole: selectedRole
        )
    }

    var hasChanges: Bool {
        // Before setupUser runs, avoid weird UX during initial render.
        guard let baselineForm else { return false }
        return proposedForm.snapshot() != baselineForm.snapshot()
    }

    var showDiscardAlert = false

    // User Instance (bound to UI)
    var id: String = ""
    var username: String = ""

    // MARK: - Remove at firebase implementation
    var password: String = ""

    var localeCountry: Country = .none
    var localeCity: City = .none
    var role: Role = .user
    var updatedAt: Date = Date()
    var email: String = ""
    var createdAt: Date = Date()

    // Selections (UI)
    var selectedCountry: Country = .none
    var selectedCity: City = .none
    var selectedRole: Role = .user

    // Error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    var showMessage: Bool = false

    // MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil) {
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    func createMessage(title: String, message: String, error: Error? = nil) {
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showMessage = true
    }

    // MARK: - Validation
    func validate() -> Bool {
        // Normalize per input policy
        let normalizedEmail = Validation.trimmed(email)
        let normalizedUsername = Validation.trimmed(username)

        // Persist normalized values so update uses the same.
        email = normalizedEmail
        username = normalizedUsername

        // Required fields for profile editing
        if let error = Validation.validateRequired(email, username) {
            createAlert(title: error.title, message: error.message)
            return false
        }

        if let error = Validation.validateEmail(email) {
            createAlert(title: error.title, message: error.message)
            return false
        }

        if let error = Validation.validateUsername(username) {
            createAlert(title: error.title, message: error.message)
            return false
        }

        // Password is optional on profile edit (prototype). If user entered one, validate it.
        if !password.isEmpty {
            if let error = Validation.validatePassword(password) {
                createAlert(title: error.title, message: error.message)
                return false
            }
        }

        // Duplicate checks (avoid false positives when keeping current values)
        let originalEmail = currentUser?.email
        let originalUsername = currentUser?.username

        if email != originalEmail {
            if userRepository.exists(email: email) {
                createAlert(title: String(localized: "epvm.alert.dupEmail.title"), message: String(localized: "epvm.alert.dupEmail.msg"))
                return false
            }
        }

        if username != originalUsername {
            if userRepository.exists(username: username) {
                createAlert(title: String(localized: "epvm.alert.dupUsername.title"), message: String(localized: "epvm.alert.dupUsername.msg"))
                return false
            }
        }

        return true
    }

    // MARK: - Save Change (Prototype)
    func applyChanges() -> Bool {
        // No changes: allow dismiss like a Back action
        guard hasChanges else { return true }

        guard validate() else { return false }

        // Keep legacy stored fields in sync (optional, but keeps consistency with current code)
        localeCountry = selectedCountry
        localeCity = selectedCity
        role = selectedRole

        guard let baseline = baselineUser else {
            createAlert(title: String(localized: "epvm.alert.error.title"), message: String(localized: "epvm.alert.missingBaseline.msg"))
            return false
        }

        let updatedUser = proposedForm.buildUpdatedUser(from: baseline)

        do {
            try userRepository.update(updatedUser)
            currentUser = updatedUser

            // Update baseline so subsequent edits compare against the saved state
            baselineUser = updatedUser
            baselineForm = UserUpdateForm(user: updatedUser)

            return true
        } catch UserRepositoryError.duplicateEmail {
            createAlert(title: String(localized: "epvm.alert.dupEmail.title"), message: String(localized: "epvm.alert.dupEmail.msg"))
            return false
        } catch UserRepositoryError.duplicateUsername {
            createAlert(title: String(localized: "epvm.alert.dupUsername.title"), message: String(localized: "epvm.alert.dupUsername.msg"))
            return false
        } catch UserRepositoryError.notFound {
            createAlert(title: String(localized: "epvm.alert.error.title"), message: String(localized: "epvm.alert.userNotFound.msg"))
            return false
        } catch {
            createAlert(title: String(localized: "epvm.alert.error.title"), message: String(localized: "epvm.alert.generic.msg"), error: error)
            return false
        }
    }

    // MARK: - UI setup
    func setupUser() {
        guard let user = currentUser else { return }

        baselineUser = user
        baselineForm = UserUpdateForm(user: user)

        id = user.id
        username = user.username
        password = user.password
        localeCountry = user.localeCountry
        localeCity = user.localeCity
        role = user.role
        updatedAt = user.updatedAt
        email = user.email
        createdAt = user.createdAt

        selectedCountry = user.localeCountry
        selectedCity = user.localeCity
        selectedRole = user.role
    }
}
