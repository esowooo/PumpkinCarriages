import Foundation

@MainActor
@Observable
class SessionManager {

    var sessionState: SessionState = .signedOut
    var authLevel: AuthLevel = .guest
    var currentUser: User?

    private var markRepository: any MarkRepository { Repositories.shared.mark }

    // MARK: - Public Auth API

    func signIn(user: User) {
        currentUser = user
        sessionState = .signedIn
        authLevel = .authenticated

        // Prototype: ensure mark exists
        Task { @MainActor in
            await ensureMarkExistsIfNeeded(for: user)
        }
    }

    func signInAsGuest() {
        currentUser = nil
        sessionState = .signedIn
        authLevel = .guest
    }

    func signOut() {
        currentUser = nil
        sessionState = .signedOut
        authLevel = .guest
    }

    func startAuthFlow() {
        signOut()
    }


//    func reauthenticate(password: String) async -> ReauthResult {
//        guard let user = Auth.auth().currentUser,
//              let email = user.email else {
//            return .requiresSignIn
//        }
//
//        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
//
//        do {
//            try await user.reauthenticate(with: credential)
//            return .success
//        } catch {
//            return .other(error)
//        }
//    }

    // MARK: - User Mark Existence Check (Prototype)

    private func ensureMarkExistsIfNeeded(for user: User) async {
        await markRepository.ensureMarkExists(forUserId: user.id)
    }
}

enum SessionState {
    case signedIn, signedOut
}

enum AuthLevel: Equatable {
    case guest
    case authenticated
}
    
