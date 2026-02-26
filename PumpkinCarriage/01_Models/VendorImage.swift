






import Foundation

struct VendorProfileImage: Codable, Identifiable, Hashable {
    let id: String // VendorSummary.id
    var images: [VendorImage]
}

struct VendorImage: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var sortOrder: Int
    var variants: [VendorImageVariant]
    var createdAt: Date = .now
    var uploadedByUserId: String?
    var status: VendorImageStatus = .active
    var caption: String?
}

extension VendorImage {
    func storagePath(prefer kinds: [VendorImageVariantKind]) -> String? {
        for k in kinds {
            if let p = variants.first(where: { $0.kind == k })?.storagePath { return p }
        }
        return variants.first?.storagePath
    }
}


enum VendorImageVariantKind: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case original
    case thumbnail
    case medium
}

struct VendorImageVariant: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var kind: VendorImageVariantKind
    // Firebase Storage path
    // Eg: "vendors/<vendorId>/<imageId>/original.jpg"
    var storagePath: String
    var width: Int?
    var height: Int?
    var byteSize: Int?
    var contentType: String? // "image/jpeg" 등
    var checksum: String?
}

enum VendorImageStatus: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case active
    case processing
    case hidden
    case failed
}

enum VendorImageUseCase {
    static let list: [VendorImageVariantKind] = [.thumbnail, .medium, .original]
    static let carousel: [VendorImageVariantKind] = [.medium, .original]
    static let viewer: [VendorImageVariantKind] = [.original, .medium, .thumbnail]
}
