import Foundation

// MARK: - Protocol (append-only, no delete)
@MainActor
protocol UserConsentRepository {
    
    // List consents for a user (optionally filter by docType)
    func list(userId: String, docType: ConsentDocType?) -> [UserConsent]
    // Get a specific consent by id
    func get(id: String) -> UserConsent?
    // Append a new consent record (no update/delete)
    func create(_ consent: UserConsent) throws
    
    
    // Helpers
    func latest(userId: String, docType: ConsentDocType) -> UserConsent?
    
    func hasAgreedToLatest(userId: String, docType: ConsentDocType, latestVersion: String) -> Bool
}

@MainActor
enum UserConsentRepositoryError: Error {
    case duplicateId
}

// MARK: - Mock (in-memory, append-only)
@MainActor
final class MockUserConsentRepository: UserConsentRepository {
    static let shared = MockUserConsentRepository()

    private var consents: [UserConsent]

    private init(consents: [UserConsent] = []) {
        self.consents = consents
    }

    func list(userId: String, docType: ConsentDocType? = nil) -> [UserConsent] {
        consents.filter { $0.userId == userId && (docType == nil || $0.docType == docType!) }
            .sorted(by: { $0.agreedAt > $1.agreedAt })
    }

    func get(id: String) -> UserConsent? {
        consents.first { $0.id == id }
    }

    func create(_ consent: UserConsent) throws {
        if consents.contains(where: { $0.id == consent.id }) {
            throw UserConsentRepositoryError.duplicateId
        }
        consents.append(consent)
    }

    func latest(userId: String, docType: ConsentDocType) -> UserConsent? {
        list(userId: userId, docType: docType).first
    }

    func hasAgreedToLatest(userId: String, docType: ConsentDocType, latestVersion: String) -> Bool {
        guard let latestConsent = latest(userId: userId, docType: docType) else { return false }
        return latestConsent.docVersion == latestVersion
    }
}


