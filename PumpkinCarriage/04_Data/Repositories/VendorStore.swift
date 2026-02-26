import Foundation

/// Store is the single source of truth for data access.
/// For network, implement this with Firestore/REST and push filtering/ordering/limit to the server.
@MainActor
protocol VendorStore {
    // MARK: - Summary (List/Main)
    func createSummary(_ summary: VendorSummary) async throws
    func readSummary(scope: VendorReadScope, id: String) async throws -> VendorSummary?
    func readSummaries(spec: VendorQuerySpec) async throws -> [VendorSummary]
    func updateSummary(_ summary: VendorSummary) async throws
    /// Soft delete (in-app): status -> .archived
    func softDeleteSummary(id: String) async throws

    /// Hard delete (remove): rollback/test only
    func deleteSummary(id: String) async throws


    // MARK: - Detail (Detail page)
    func createDetail(_ detail: VendorDetail) async throws
    func readDetail(scope: VendorReadScope, id: String) async throws -> VendorDetail?
    func updateDetail(_ detail: VendorDetail) async throws
    func deleteDetail(id: String) async throws


    // MARK: - Profile Images (Image-only model)
    func createProfileImage(_ profile: VendorProfileImage) async throws
    func readProfileImage(scope: VendorReadScope, id: String) async throws -> VendorProfileImage?
    func updateProfileImage(_ profile: VendorProfileImage) async throws
    func deleteProfileImage(id: String) async throws
}

// MARK: - Store Errors
enum VendorStoreError: Error {
    case alreadyExists
    case notFound
}


// MARK: - Mock Store (in-memory)
/// Mock store that wraps the global in-memory `vendors` array.
/// Note: `vendors` must exist elsewhere in your project.
@MainActor
final class MockVendorStore: VendorStore {

    static let shared = MockVendorStore(
        summaries: VendorMockSeed.makeSummaries(),
        details: VendorMockSeed.makeDetails(),
        profiles: VendorMockSeed.makeProfiles()
    )

    private var summaries: [VendorSummary]
    private var details: [VendorDetail]
    private var profiles: [VendorProfileImage]

    private init(
        summaries: [VendorSummary],
        details: [VendorDetail],
        profiles: [VendorProfileImage]
    ) {
        self.summaries = summaries
        self.details = details
        self.profiles = profiles

        for v in summaries {
            if self.details.first(where: { $0.id == v.id }) == nil {
                self.details.append(
                    VendorDetail(
                        id: v.id,
                        contactEmail: nil,
                        contactPhone: nil,
                        description: LocalizedText(),
                        externalLinks: []
                    )
                )
            }
            if self.profiles.first(where: { $0.id == v.id }) == nil {
                self.profiles.append(
                    VendorProfileImage(
                        id: v.id,
                        images: []
                    )
                )
            }
        }
    }

    // MARK: - Summary
    func createSummary(_ summary: VendorSummary) async throws {
        guard summaries.contains(where: { $0.id == summary.id }) == false else {
            throw VendorStoreError.alreadyExists
        }
        summaries.append(summary)
    }
    
    func readSummary(scope: VendorReadScope, id: String) async throws -> VendorSummary? {
        guard let v = summaries.first(where: { $0.id == id }) else { return nil }

        switch scope {
        case .open:
            guard v.status != .archived else { return nil }
            return v.isVisibleToCustomers ? v : nil

        case .portal(let userId):
            guard v.manager == userId else { return nil }
            guard v.status != .archived else { return nil }
            return v

        case .admin:
            return v
        }
    }
    
    

    func readSummaries(spec: VendorQuerySpec) async throws -> [VendorSummary] {
        let base: [VendorSummary]

        switch spec.scope {
        case .open:
            base = summaries
                .filter { $0.isVisibleToCustomers }
                .filter { $0.status != .archived }

        case .portal(let userId):
            base = summaries
                .filter { $0.manager == userId }
                .filter { $0.status != .archived }

        case .admin:
            base = summaries
        }

        return VendorQueryEngineLocal.apply(base, query: spec.query)
    }

    func updateSummary(_ summary: VendorSummary) async throws {
        guard let idx = summaries.firstIndex(where: { $0.id == summary.id }) else {
            throw VendorStoreError.notFound
        }
        summaries[idx] = summary
    }

    
    //Soft Delete in-app, anonymize done by cloud function
    func softDeleteSummary(id: String) async throws {
        guard let idx = summaries.firstIndex(where: { $0.id == id }) else {
            throw VendorStoreError.notFound
        }

        var v = summaries[idx]
        v.status = .archived
        v.updatedAt = .now
        summaries[idx] = v

        // NOTE: Detail/Profile/Storage are NOT deleted here.
        // Hard-delete/anonymize should be handled by server-side jobs.
    }
    
    // Hard delete (remove) — rollback/test only
    func deleteSummary(id: String) async throws {
        guard summaries.contains(where: { $0.id == id }) else {
            throw VendorStoreError.notFound
        }

        summaries.removeAll(where: { $0.id == id })
        details.removeAll(where: { $0.id == id })
        profiles.removeAll(where: { $0.id == id })
    }

    // MARK: - Detail
    func createDetail(_ detail: VendorDetail) async throws {
        guard details.contains(where: { $0.id == detail.id }) == false else {
            throw VendorStoreError.alreadyExists
        }
        details.append(detail)
    }
    
    func readDetail(scope: VendorReadScope, id: String) async throws -> VendorDetail? {
        guard (try await readSummary(scope: scope, id: id)) != nil else { return nil }
        return details.first(where: { $0.id == id })
    }

    func updateDetail(_ detail: VendorDetail) async throws {
        guard let idx = details.firstIndex(where: { $0.id == detail.id }) else {
            throw VendorStoreError.notFound
        }
        details[idx] = detail
    }

    func deleteDetail(id: String) async throws {
        details.removeAll(where: { $0.id == id })
    }

    // MARK: - Profile Images
    func createProfileImage(_ profile: VendorProfileImage) async throws {
        guard profiles.contains(where: { $0.id == profile.id }) == false else {
            throw VendorStoreError.alreadyExists
        }
        profiles.append(profile)
    }
    
    func readProfileImage(scope: VendorReadScope, id: String) async throws -> VendorProfileImage? {
        guard (try await readSummary(scope: scope, id: id)) != nil else { return nil }
        return profiles.first(where: { $0.id == id })
    }

    func updateProfileImage(_ profile: VendorProfileImage) async throws {
        guard let idx = profiles.firstIndex(where: { $0.id == profile.id }) else {
            throw VendorStoreError.notFound
        }
        profiles[idx] = profile
    }

    func deleteProfileImage(id: String) async throws {
        profiles.removeAll(where: { $0.id == id })
    }
}
