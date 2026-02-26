import Foundation

// MARK: - Protocol
@MainActor
protocol UserRepository {
    // Login is email-based now, username is optional.
    //func all() -> [User]
    //func find(byId id: String) -> User?
    func findByEmail(_ email: String) -> User?   // primary method
    func findByUsername(_ username: String) -> User?  // for backward compatibility

    func exists(email: String) -> Bool
    func exists(username: String) -> Bool

    func create(_ user: User) throws
    func update(_ user: User) throws
    func updateRole(userId: String, role: Role) throws
    func delete(id: String) throws   // softDelete (isActive=false)
}

@MainActor
enum UserRepositoryError: Error {
    case duplicateEmail
    case duplicateUsername
    case notFound
}

// MARK: - Mock (in-memory)

/// Mock repository backed by the global `users` array for prototype compatibility.
///
/// Notes:
/// - This keeps existing code that still reads `users` working.
/// - When you migrate fully to repositories, you can remove the global `users` and keep storage private here.
@MainActor
final class MockUserRepository: UserRepository {
    static let shared = MockUserRepository(
        users: UserMockSeed.makeUsers()
    )
    
    private var users: [User]
    
    private init(
        users: [User]
    ) {
        self.users = users
    }

//    func all() -> [User] {
//        users.filter { $0.isActive }
//    }
//
//    func find(byId id: String) -> User? {
//        users.first(where: { $0.id == id && $0.isActive })
//    }

    func findByEmail(_ email: String) -> User? {
        let key = email.lowercased()
        return users.first(where: { $0.email.lowercased() == key })
    }

    func findByUsername(_ username: String) -> User? {
        let key = username.lowercased()
        return users.first(where: { $0.username.lowercased() == key })
    }

    func exists(email: String) -> Bool {
        return findByEmail(email) != nil
    }

    func exists(username: String) -> Bool {
        return findByUsername(username) != nil
    }

    func create(_ user: User) throws {
        if exists(email: user.email) {
            throw UserRepositoryError.duplicateEmail
        }
        if exists(username: user.username) {
            throw UserRepositoryError.duplicateUsername
        }
        users.append(user)
    }

    func update(_ user: User) throws {
        guard let idx = users.firstIndex(where: { $0.id == user.id }) else {
            throw UserRepositoryError.notFound
        }

        // Prevent collisions with other accounts
        let emailKey = user.email.lowercased()
        if users.contains(where: { $0.id != user.id && $0.email.lowercased() == emailKey }) {
            throw UserRepositoryError.duplicateEmail
        }

        let usernameKey = user.username.lowercased()
        if users.contains(where: { $0.id != user.id && $0.username.lowercased() == usernameKey }) {
            throw UserRepositoryError.duplicateUsername
        }

        users[idx] = user
    }
    
    func updateRole(userId: String, role: Role) throws {
        guard let idx = users.firstIndex(where: { $0.id == userId }) else {
            throw UserRepositoryError.notFound
        }

        var updated = users[idx]
        updated.role = role
        updated.updatedAt = Date()
        users[idx] = updated
    }

    func delete(id: String) throws {
        guard let idx = users.firstIndex(where: { $0.id == id }) else {
            throw UserRepositoryError.notFound
        }

        var updated = users[idx]
        updated.isActive = false
        updated.updatedAt = Date()
        users[idx] = updated
    }
}


enum UserMockSeed {
    static func makeUsers() -> [User] {
        [
            User(
                id: "user1",
                username: "test1",
                password: "test123",
                email: "test1@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .user,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            ),
            User(
                id: "admin1",
                username: "test2",
                password: "test123",
                email: "test2@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .admin,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            ),
            User(
                id: "vendor1",
                username: "test3",
                password: "test123",
                email: "test3@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .vendor,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            ),
            User(
                id: "vendor2",
                username: "test4",
                password: "test123",
                email: "test4@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .vendor,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            ),
            User(
                id: "vendor3",
                username: "test5",
                password: "test123",
                email: "test5@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .vendor,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            ),
            User(
                id: "vendor4",
                username: "test6",
                password: "test123",
                email: "test6@test.com",
                localeCountry: .none,
                localeCity: .none,
                role: .user,
                createdAt: Date(),
                updatedAt: Date(),
                isActive: true
            )
        ]
    }
    
}

