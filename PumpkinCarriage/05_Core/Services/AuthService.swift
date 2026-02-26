import Foundation

@MainActor
protocol AuthService {
    /// Authenticates and signs the session in if successful.
    /// - Note: Email is trimmed; password is treated as literal (not trimmed).
    func signIn(email: String, password: String, sessionManager: SessionManager) throws -> User

    /// Re-authenticates credentials WITHOUT mutating the current signed-in session.
    /// Use this for confirmation flows (e.g., before opening a protected screen).
    func reauth(email: String, password: String) throws -> User

    /// Guest sign-in convenience.
    func signInAsGuest(sessionManager: SessionManager)
}

@MainActor
enum AuthError: Error {
    case invalidEmail
    case inactiveUser
    case invalidPassword(hasWhitespaceHint: Bool)
}

@MainActor
final class DefaultAuthService: AuthService {

    private let userRepo: any UserRepository

    init(userRepo: any UserRepository) {
        self.userRepo = userRepo
    }

    func signIn(email: String, password: String, sessionManager: SessionManager) throws -> User {
        let matchedUser = try authenticate(email: email, password: password)
        sessionManager.signIn(user: matchedUser)
        return matchedUser
    }

    func reauth(email: String, password: String) throws -> User {
        try authenticate(email: email, password: password)
    }

    private func authenticate(email: String, password: String) throws -> User {
        let emailTrim = Validation.trimmed(email)

        guard let matchedUser = userRepo.findByEmail(emailTrim) else {
            throw AuthError.invalidEmail
        }

        guard matchedUser.isActive else {
            throw AuthError.inactiveUser
        }

        guard matchedUser.password == password else {
            let hasHint = password.hasPrefix(" ") || password.hasSuffix(" ")
            throw AuthError.invalidPassword(hasWhitespaceHint: hasHint)
        }

        return matchedUser
    }

    func signInAsGuest(sessionManager: SessionManager) {
        sessionManager.signInAsGuest()
    }
}
