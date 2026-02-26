import Foundation
import SwiftUI

//MARK: - Image Read
protocol ImageResolveRepository {
    func resolve(storagePath: String) -> ImageResource?
}

enum ImageResource: Hashable {
    case asset(name: String)
    case localFile(url: URL)
    case remote(url: URL)
}

struct MockImageResolveRepository: ImageResolveRepository {
    static let shared = MockImageResolveRepository()
    
    
    func resolve(storagePath: String) -> ImageResource? {
        if storagePath.hasPrefix("asset:") {
            let name = storagePath.replacingOccurrences(of: "asset:", with: "")
            return .asset(name: name)
        }

        if storagePath.hasPrefix("file:") {
            let path = storagePath.replacingOccurrences(of: "file:", with: "")
            return .localFile(url: URL(fileURLWithPath: path))
        }

        if let url = URL(string: storagePath),
           url.scheme == "https" || url.scheme == "http" {
            return .remote(url: url)
        }

        return nil
    }
}

//MARK: - Image Upload
protocol ImageUploadRepository {
    func upload(data: Data, vendorId: String, imageId: String, kind: VendorImageVariantKind) async throws -> String
    func delete(storagePath: String) async throws
}


//Mock Upload (Local Files)
enum ImageUploadRepositoryError: Error {
    case invalidStoragePath
    case unsupportedStorageScheme
}

/// Stores image bytes to the app's Documents directory and returns a `file:` storagePath.
///
/// Path format:
/// - Documents/vendors/<vendorId>/<imageId>/<kind>.jpg
/// StoragePath returned:
/// - "file:<absolute_file_path>"
struct MockImageUploadRepository: ImageUploadRepository {
    static let shared = MockImageUploadRepository()

    func upload(
        data: Data,
        vendorId: String,
        imageId: String,
        kind: VendorImageVariantKind
    ) async throws -> String {
        let base = try documentsDirectory()
        let dir = base
            .appendingPathComponent("vendors", isDirectory: true)
            .appendingPathComponent(vendorId, isDirectory: true)
            .appendingPathComponent(imageId, isDirectory: true)

        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        // For mock, we persist as JPEG bytes.
        let fileURL = dir.appendingPathComponent("\(kind.rawValue).jpg", isDirectory: false)

        // Overwrite if exists (common for re-upload during edit).
        try data.write(to: fileURL, options: [.atomic])

        return "file:\(fileURL.path)"
    }

    func delete(storagePath: String) async throws {
        guard storagePath.hasPrefix("file:") else {
            // In mock, we only manage local file storage.
            throw ImageUploadRepositoryError.unsupportedStorageScheme
        }

        let path = storagePath.replacingOccurrences(of: "file:", with: "")
        guard !path.isEmpty else {
            throw ImageUploadRepositoryError.invalidStoragePath
        }

        let url = URL(fileURLWithPath: path)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }

    private func documentsDirectory() throws -> URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ImageUploadRepositoryError.invalidStoragePath
        }
        return url
    }
}
