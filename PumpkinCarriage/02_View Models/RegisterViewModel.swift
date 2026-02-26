import Foundation

@Observable
class RegisterViewModel {

    private var userRepository: any UserRepository { Repositories.shared.user }
    private var markRepository: any MarkRepository { Repositories.shared.mark }
    private var userConsentRepository: any UserConsentRepository { Repositories.shared.userConsent }

    private let webDocsClient = WebDocsClient()

    var form: UserRegisterForm = .init()
    
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

    //MARK: - Register (Prototype)
    func register() async -> User? {
        let now = Date()
        if validate() {
            form.normalizeInPlace()
            let user = form.buildUser(userId: UUID().uuidString, now: now)
            do {
                try userRepository.create(user)
            } catch UserRepositoryError.duplicateEmail {
                createAlert(title: String(localized: "regvm.alert.dupEmail.title"), message: String(localized: "regvm.alert.dupEmail.msg"))
                return nil
            } catch UserRepositoryError.duplicateUsername {
                createAlert(title: String(localized: "regvm.alert.dupUsername.title"), message: String(localized: "regvm.alert.dupUsername.msg"))
                return nil
            } catch {
                createAlert(title: String(localized: "regvm.alert.registerFailed.title"), message: String(localized: "regvm.alert.unexpected.msg"), error: error)
                return nil
            }

            await createMark(userId: user.id)
            await createInitialConsents(for: user)
            return user
        }
        return nil
    }

    //MARK: - Generate Empty Mark for this User (Prototype)
    func createMark(userId: String) async {
        let newMark = Mark(id: UUID().uuidString, userId: userId, vendorId: [], createdAt: Date())

        do {
            try await markRepository.create(newMark)
        } catch MarkRepositoryError.duplicateUser {
            // Prototype safety: if a mark already exists for this user, keep going.
            // You can convert this into a hard error later if you want strictness.
            return
        } catch {
            createAlert(title: String(localized: "regvm.alert.createMarkFailed.title"), message: String(localized: "regvm.alert.unexpected.msg"), error: error)
        }
    }

    private func preferredWebLang() -> String {
        let code: String
        if #available(iOS 16.0, *) {
            code = Locale.current.language.languageCode?.identifier ?? "ja"
        } else {
            code = Locale.current.identifier
        }
        switch code.prefix(2) {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // EN not served; fall back to JA
        default: return "ja"
        }
    }

    private func createInitialConsents(for user: User) async {
        let lang = preferredWebLang()
        let now = Date()
        let pairs: [(ConsentDocType, String)] = [(.terms, "terms"), (.privacy, "privacy")]
        for (docType, docKey) in pairs {
            do {
                let version = try await webDocsClient.fetchLegalLatestVersion(preferredLang: lang, docKey: docKey)
                let consent = UserConsent(
                    id: UUID().uuidString,
                    userId: user.id,
                    docType: docType,
                    docVersion: version,
                    agreedAt: now,
                    locale: lang,
                    surface: "ios_app"
                )
                do {
                    try await MainActor.run {
                        try userConsentRepository.create(consent)
                    }
                } catch {
                    throw error
                }
            } catch {
                // Non-fatal: proceed with registration even if consent logging fails.
                print("[RegisterViewModel] Failed to create consent for \(docType):", error)
            }
        }
    }

    //MARK: - Validation (Prototype)
    func validate() -> Bool {
        let normalizedEmail = Validation.trimmed(form.email)
        let normalizedUsername = Validation.trimmed(form.username)
        let password = form.password

        // Require email, username and password
        if let error = Validation.validateRequired(normalizedEmail, normalizedUsername, password) {
            createAlert(title: error.title, message: error.message)
            return false
        }
        if let error = Validation.validateEmail(normalizedEmail) {
            createAlert(title: error.title, message: error.message)
            return false
        }
        if let error = Validation.validatePassword(password) {
            createAlert(title: error.title, message: error.message)
            return false
        }
        // Always validate username
        if let error = Validation.validateUsername(normalizedUsername) {
            createAlert(title: error.title, message: error.message)
            return false
        }

        if userRepository.exists(email: normalizedEmail) {
            createAlert(title: String(localized: "regvm.alert.dupEmail.title"), message: String(localized: "regvm.alert.dupEmail.msg"))
            return false
        }
        // Always check username duplication
        if userRepository.exists(username: normalizedUsername) {
            createAlert(title: String(localized: "regvm.alert.dupUsername.title"), message: String(localized: "regvm.alert.dupUsername.msg"))
            return false
        }

        return true
    }
}
