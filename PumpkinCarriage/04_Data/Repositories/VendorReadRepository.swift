import Foundation

// MARK: - Read Repositories (open / portal / admin)
@MainActor
protocol OpenVendorReadRepository {
    // Summary
    func readOpenSummary(id: String) async throws -> VendorSummary?
    func readOpenSummaries(query: VendorQuery) async throws -> [VendorSummary]
    func readOpenTopSummaries(limit: Int) async throws -> [VendorSummary]
    func readOpenMarkSummaries(ids: [String], preserveOrder: Bool) async throws -> [VendorSummary]
    func readOpenSummary(publicId: String) async throws -> VendorSummary?

    // Detail
    func readOpenDetail(id: String) async throws -> VendorDetail?

    // Profile Images
    func readOpenProfileImage(id: String) async throws -> VendorProfileImage?
}

@MainActor
protocol VendorPortalVendorReadRepository {
    // Summary
    func readVendorSummary(userId: String, id: String) async throws -> VendorSummary?
    func readVendorSummaries(userId: String, query: VendorQuery) async throws -> [VendorSummary]

    // Detail
    func readVendorDetail(userId: String, id: String) async throws -> VendorDetail?

    // Profile Images
    func readVendorProfileImage(userId: String, id: String) async throws -> VendorProfileImage?
}

@MainActor
protocol AdminVendorReadRepository {
    // Summary
    func readAdminSummary(id: String) async throws -> VendorSummary?
    func readAdminSummaries(query: VendorQuery) async throws -> [VendorSummary]

    // Detail
    func readAdminDetail(id: String) async throws -> VendorDetail?

    // Profile Images
    func readAdminProfileImage(id: String) async throws -> VendorProfileImage?
}

// MARK: - Mock implementations (thin adapters over Store)
@MainActor
final class MockOpenVendorReadRepository: OpenVendorReadRepository {
    private let store: VendorStore

    init(store: VendorStore) {
        self.store = store
    }

    func readOpenSummary(id: String) async throws -> VendorSummary? {
        try await store.readSummary(scope: .open, id: id)
    }

    func readOpenSummaries(query: VendorQuery) async throws -> [VendorSummary] {
        let spec = VendorQueryCompiler.compile(scope: .open, query: query)
        return try await store.readSummaries(spec: spec)
    }
    
    func readOpenTopSummaries(limit: Int) async throws -> [VendorSummary] {
        var q = VendorQuery()
        q.limit = limit
        q.order = .byMarkCount
        return try await readOpenSummaries(query: q)
    }
    
    func readOpenSummary(publicId: String) async throws -> VendorSummary? {
        // Mock-only: scan open summaries and match by publicId.
        // In Firestore, this will become a query (publicId == ...), or publicId-as-docId.
        var q = VendorQuery()
        q.limit = 10_000

        let summaries = try await readOpenSummaries(query: q)
        return summaries.first(where: { $0.publicId == publicId && $0.isVisibleToCustomers })
    }
    
    func readOpenMarkSummaries(ids: [String], preserveOrder: Bool) async throws -> [VendorSummary] {
        guard !ids.isEmpty else { return [] }
        
        var results: [VendorSummary] = []
        results.reserveCapacity(ids.count)
        
        for id in ids {
            if let summary = try await store.readSummary(scope: .open, id: id) {
                if summary.isVisibleToCustomers {
                    results.append(summary)
                }
            }
        }
        
        if preserveOrder {
            let indexById: [String: Int] = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($0.element, $0.offset) })
            results.sort { (a, b) in
                (indexById[a.id] ?? Int.max) < (indexById[b.id] ?? Int.max)
            }
        } else {
            results.sort {
                if $0.name != $1.name { return $0.name > $1.name }
                let nameCmp = $0.name.localizedCaseInsensitiveCompare($1.name)
                if nameCmp != .orderedSame { return nameCmp == .orderedAscending }
                return $0.id < $1.id
            }
        }
        
        return results
    }

    func readOpenDetail(id: String) async throws -> VendorDetail? {
        try await store.readDetail(scope: .open, id: id)
    }

    func readOpenProfileImage(id: String) async throws -> VendorProfileImage? {
        try await store.readProfileImage(scope: .open, id: id)
    }
}

@MainActor
final class MockVendorPortalVendorReadRepository: VendorPortalVendorReadRepository {
    private let store: VendorStore

    init(store: VendorStore) {
        self.store = store
    }

    func readVendorSummary(userId: String, id: String) async throws -> VendorSummary? {
        try await store.readSummary(scope: .portal(userId: userId), id: id)
    }

    func readVendorSummaries(userId: String, query: VendorQuery) async throws -> [VendorSummary] {
        let spec = VendorQueryCompiler.compile(scope: .portal(userId: userId), query: query)
        return try await store.readSummaries(spec: spec)
    }

    func readVendorDetail(userId: String, id: String) async throws -> VendorDetail? {
        try await store.readDetail(scope: .portal(userId: userId), id: id)
    }

    func readVendorProfileImage(userId: String, id: String) async throws -> VendorProfileImage? {
        try await store.readProfileImage(scope: .portal(userId: userId), id: id)
    }
}

@MainActor
final class MockAdminVendorReadRepository: AdminVendorReadRepository {
    private let store: VendorStore

    init(store: VendorStore) {
        self.store = store
    }

    func readAdminSummary(id: String) async throws -> VendorSummary? {
        try await store.readSummary(scope: .admin, id: id)
    }

    func readAdminSummaries(query: VendorQuery) async throws -> [VendorSummary] {
        let spec = VendorQueryCompiler.compile(scope: .admin, query: query)
        return try await store.readSummaries(spec: spec)
    }

    func readAdminDetail(id: String) async throws -> VendorDetail? {
        try await store.readDetail(scope: .admin, id: id)
    }

    func readAdminProfileImage(id: String) async throws -> VendorProfileImage? {
        try await store.readProfileImage(scope: .admin, id: id)
    }
}
