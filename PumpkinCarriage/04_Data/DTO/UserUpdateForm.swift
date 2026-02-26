






import Foundation

/// DTO (form model) for editing a User.
/// - Purpose: keep UI state in one container, support normalization/validation, and simplify dirty-tracking.
struct UserUpdateForm: Equatable {

    // UI-editable fields
    var email: String
    var username: String

    // Prototype only (planned to be removed when Firebase/Auth is introduced)
    var password: String

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

    init(user: User) {
        self.email = user.email
        self.username = user.username
        self.password = user.password
        self.selectedCountry = user.localeCountry
        self.selectedCity = user.localeCity
        self.selectedRole = user.role
    }

    /// Snapshot for dirty-tracking. Applies the app's input policy.
    /// - email/username: trimmed
    /// - password: literal (do NOT trim)
    func snapshot() -> Snapshot {
        Snapshot(
            email: Validation.trimmed(email),
            username: Validation.trimmed(username),
            password: password,
            localeCountry: selectedCountry,
            localeCity: selectedCity,
            role: selectedRole
        )
    }

    struct Snapshot: Equatable {
        var email: String
        var username: String
        var password: String
        var localeCountry: Country
        var localeCity: City
        var role: Role
    }

    /// Apply normalization to the DTO in-place.
    mutating func normalizeInPlace() {
        email = Validation.trimmed(email)
        username = Validation.trimmed(username)
        // password: do NOT trim
    }

    /// Build an updated User using immutable fields from the existing user.
    func buildUpdatedUser(from existing: User) -> User {
        User(
            id: existing.id,
            username: Validation.trimmed(username),
            password: password,
            email: Validation.trimmed(email),
            localeCountry: selectedCountry,
            localeCity: selectedCity,
            role: selectedRole,
            createdAt: existing.createdAt,
            updatedAt: Date(),
            isActive: existing.isActive
        )
    }
}
