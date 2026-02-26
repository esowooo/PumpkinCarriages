






import Foundation

/// Register DTO.
/// - Purpose: keep UI input state in one container, normalize/compare easily,
///   and build a `User` for persistence.
/// - Note: password is treated as a literal
struct UserRegisterForm: Equatable {

    // UI-friendly fields
    var email: String
    var username: String
    var password: String

    // Currently inactive on UI, but kept for future parity
    var selectedCountry: Country
    var selectedCity: City
    var selectedRole: Role

    init(
        email: String = "",
        username: String = "",
        password: String = "",
        selectedCountry: Country = .none,
        selectedCity: City = .none,
        selectedRole: Role = .user
    ) {
        self.email = email
        self.username = username
        self.password = password
        self.selectedCountry = selectedCountry
        self.selectedCity = selectedCity
        self.selectedRole = selectedRole
    }

    /// Normalized snapshot for equality / dirty tracking.
    /// - Trims email/username, keeps password literal.
    func snapshot() -> Snapshot {
        Snapshot(
            email: Validation.trimmed(email).lowercased(),
            username: Validation.trimmed(username),
            password: password,
            selectedCountry: selectedCountry,
            selectedCity: selectedCity,
            selectedRole: selectedRole
        )
    }

    /// Applies normalization in-place so subsequent logic persists normalized values.
    mutating func normalizeInPlace() {
        email = Validation.trimmed(email)
        username = Validation.trimmed(username)
        // password: do NOT trim
    }

    /// Creates a new `User` from this form.
    /// - Note: the caller can pass in a `userId` if they want deterministic ids.
    func buildUser(userId: String = UUID().uuidString, now: Date = .now) -> User {
        let normalizedEmail = Validation.trimmed(email)
        let normalizedUsername = Validation.trimmed(username)

        return User(
            id: userId,
            username: normalizedUsername,
            password: password,
            email: normalizedEmail,
            localeCountry: selectedCountry,
            localeCity: selectedCity,
            role: selectedRole,
            createdAt: now,
            updatedAt: now,
            isActive: true
        )
    }

    struct Snapshot: Equatable {
        let email: String
        let username: String
        let password: String
        let selectedCountry: Country
        let selectedCity: City
        let selectedRole: Role
    }
}
