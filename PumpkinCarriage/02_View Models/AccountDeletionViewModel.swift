import Foundation

@Observable
class AccountDeletionViewModel {
    private var userRepository: any UserRepository { Repositories.shared.user }
    
    /// Starts a "soft delete" by marking the user as inactive in the local repository.
    /// NOTE: Actual deletion should be performed later by a backend job / Cloud Function.
    func softDeleteUser(userId: String, sessionManager: SessionManager) throws {
        try userRepository.delete(id: userId)
        // Immediately sign out locally so the app session is invalidated.
        sessionManager.signOut()
    }
    
}
