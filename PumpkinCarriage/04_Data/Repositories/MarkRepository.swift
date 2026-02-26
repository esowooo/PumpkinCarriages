






import Foundation
// MARK: - Protocol

@MainActor
protocol MarkRepository {
    func readAll() async -> [Mark]
    func readByMarkId(_ id: String) async -> Mark?
    func readByUserId(_ userId: String) async -> Mark?
    
    /// Policy: one Mark per userId.
    func create(_ mark: Mark) async throws
    func update(_ mark: Mark) throws
    func updateMarkVendorList(userId: String, vendorId: String) throws
    func delete(id: String) throws
    
    func checkIfMarked(userId: String, vendorId: String) async -> Bool
    func ensureMarkExists(forUserId userId: String) async
}

@MainActor
enum MarkRepositoryError: Error {
    case duplicateUser
    case notFound
}

// MARK: - Mock (in-memory)
/// Mock repository backed by the global `marks` array for prototype compatibility.
@MainActor
final class MockMarkRepository: MarkRepository {
    static let shared = MockMarkRepository(
        marks: MarkMockSeed.makeMarks()
    )
    
    private var marks: [Mark]
    private init(
        marks: [Mark]
    ) {
        self.marks = marks
    }
    
    func readAll() async -> [Mark] {
        marks
    }
    
    func readByMarkId(_ id: String) async -> Mark? {
        marks.first(where: { $0.id == id })
    }
    
    func readByUserId(_ userId: String) async -> Mark? {
        marks.first(where: { $0.userId == userId })
    }
    
    func checkIfMarked(userId: String, vendorId: String) async -> Bool {
        guard let userMarks = await readByUserId(userId) else { return false
        }
        if userMarks.vendorId.contains(vendorId) {
            return true
        }
        return false
    }
    
    /// Safety guard: ensure a Mark exists for the given userId.
    func ensureMarkExists(forUserId userId: String) async {
        if await readByUserId(userId) != nil { return }
        
        marks.append(
            Mark(
                id: UUID().uuidString,
                userId: userId,
                vendorId: [],
                createdAt: Date()
            )
        )
    }
    
    func create(_ mark: Mark) async throws {
        if await readByUserId(mark.userId) != nil {
            throw MarkRepositoryError.duplicateUser
        }
        marks.append(mark)
    }
    
    func update(_ mark: Mark) throws {
        guard let idx = marks.firstIndex(where: { $0.id == mark.id }) else {
            throw MarkRepositoryError.notFound
        }
        
        // Prevent collisions if userId changed.
        if marks.contains(where: { $0.id != mark.id && $0.userId == mark.userId }) {
            throw MarkRepositoryError.duplicateUser
        }
        marks[idx] = mark
    }
    
    func updateMarkVendorList(userId: String, vendorId: String) throws {
        guard let index = marks.firstIndex(where: { $0.userId == userId }) else {
            throw MarkRepositoryError.notFound
        }
        if marks[index].vendorId.contains(vendorId) {
            marks[index].vendorId.removeAll(where: { $0 == vendorId })
        } else {
            marks[index].vendorId.append(vendorId)
        }
    }
    
    func delete(id: String) throws {
        guard let idx = marks.firstIndex(where: { $0.id == id }) else {
            throw MarkRepositoryError.notFound
        }
        marks.remove(at: idx)
    }
}


// MARK: - Mock Data
enum MarkMockSeed {
    static func makeMarks() -> [Mark] {
        [
            Mark(id: "f1", userId: "user1", vendorId: ["studioA", "studioB", "hmB", "dressA"], createdAt: Date()),
            Mark(id: "f2", userId: "vendor1", vendorId: ["studioC", "dressA"], createdAt: Date()),
            Mark(id: "f3", userId: "admin1", vendorId: ["dressB", "hmA"], createdAt: Date())
        ]
    }
}
