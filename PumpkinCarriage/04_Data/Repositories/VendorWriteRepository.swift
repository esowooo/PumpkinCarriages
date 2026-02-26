






import Foundation

// MARK: - Write Repository (thin adapter)
@MainActor
protocol VendorWriteRepository {

    // MARK: - Summary
    func createSummary(_ summary: VendorSummary) async throws
    func updateSummary(_ summary: VendorSummary) async throws
    func softDeleteSummary(id: String) async throws
    func deleteSummary(id: String) async throws

    // MARK: - Detail
    func createDetail(_ detail: VendorDetail) async throws
    func updateDetail(_ detail: VendorDetail) async throws
    func deleteDetail(id: String) async throws

    // MARK: - Profile Images
    func createProfileImage(_ profile: VendorProfileImage) async throws
    func updateProfileImage(_ profile: VendorProfileImage) async throws
    func deleteProfileImage(id: String) async throws
}

@MainActor
final class MockVendorWriteRepository: VendorWriteRepository {

    static let shared = MockVendorWriteRepository(store: MockVendorStore.shared)
    private let store: VendorStore

    private init(store: VendorStore) {
        self.store = store
    }

    // MARK: - Summary
    func createSummary(_ summary: VendorSummary) async throws {
        try await store.createSummary(summary)
    }

    func updateSummary(_ summary: VendorSummary) async throws {
        try await store.updateSummary(summary)
    }

    func deleteSummary(id: String) async throws {
        try await store.deleteSummary(id: id)
    }
    
    func softDeleteSummary(id: String) async throws {
        try await store.softDeleteSummary(id: id)
    }

    // MARK: - Detail
    func createDetail(_ detail: VendorDetail) async throws {
        try await store.createDetail(detail)
    }

    func updateDetail(_ detail: VendorDetail) async throws {
        try await store.updateDetail(detail)
    }

    func deleteDetail(id: String) async throws {
        try await store.deleteDetail(id: id)
    }

    // MARK: - Profile Images
    func createProfileImage(_ profile: VendorProfileImage) async throws {
        try await store.createProfileImage(profile)
    }

    func updateProfileImage(_ profile: VendorProfileImage) async throws {
        try await store.updateProfileImage(profile)
    }

    func deleteProfileImage(id: String) async throws {
        try await store.deleteProfileImage(id: id)
    }
}
