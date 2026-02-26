import Foundation

struct User: Codable {

    let id: String
    var username: String
    //MARK: - Remove at firebase implementation
    var password: String
    var email: String
    var localeCountry: Country
    var localeCity: City
    var role: Role
    var createdAt: Date
    var updatedAt: Date
    var isActive: Bool
}

enum Role: String, Codable {
    case user
    case admin
    case vendor

    var displayName: String {
        switch self {
        case .user: return "User"
        case .admin: return "Admin"
        case .vendor: return "Vendor"
        }
    }
}


enum ConsentDocType: String, Codable {
    case terms
    case privacy
    case privacyChoices
    case deletionRetention

}

struct UserConsent: Codable {
    let id: String
    let userId: String
    var docType: ConsentDocType
    var docVersion: String       // e.g. "2026-02-13"
    var agreedAt: Date
    var locale: String           // e.g. "ja", "ko", "en"
    var surface: String          // e.g. "ios_app"
}

extension User {
    static let guest: User = User(
        id: "guest",
        username: "Guest",
        password: "",
        email: "",
        localeCountry: .none,
        localeCity: .none,
        role: .user,
        createdAt: Date(),
        updatedAt: Date(),
        isActive: true
    )
}
