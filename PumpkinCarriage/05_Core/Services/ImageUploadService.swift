




import Foundation
import UIKit
import ImageIO
import UniformTypeIdentifiers

// MARK: - Image Upload Service (orchestration)
/// Upload configuration optimized for iPhone-only usage today.
///
/// Note:
/// - We resize on-device (UIKit) to minimize upload size.
/// - When adding iPad/macOS or server-side processing later, consider moving resize/variant generation
///   to a shared pipeline or Cloud Function.
struct ImageUploadConfig: Hashable, Sendable {
    /// Which variants to upload.
    ///
    /// Default policy (network-minimized): upload only `thumbnail` and `medium`.
    /// The viewer will fall back to `medium` when `original` is absent.
    /// when adding Web Service add .original
    var kinds: [VendorImageVariantKind] = [.thumbnail, .medium]

    /// JPEG compression quality.
    var jpegQuality: CGFloat = 0.75

    /// Max pixel for each variant. Images larger than this will be downscaled.
    var thumbnailMaxPixel: CGFloat = 320
    var mediumMaxPixel: CGFloat = 1280
    var originalMaxPixel: CGFloat = 2560

    nonisolated static let networkMinimized: ImageUploadConfig = .init()
}

struct ImageUploadResult: Hashable, Sendable {
    let images: [VendorImage]
    let thumbnail: VendorThumbnailRef?
}


protocol ImageUploadService {
    func uploadVendorImages(
        vendorId: String,
        drafts: [ImageDraft],
        uploaderUserId: String?,
        config: ImageUploadConfig
    ) async throws -> ImageUploadResult

    func applyVendorImageChanges(
        vendorId: String,
        existingImages: [VendorImage],
        imageItems: [ImageSlot],
        deletedExistingImageIds: Set<String>,
        thumbnailItemId: String?,
        drafts: [ImageDraft],
        uploaderUserId: String?,
        config: ImageUploadConfig
    ) async throws -> ImageUploadResult
    
    
    /// Best-effort cleanup for storage paths referenced by `VendorImage.variants`.
    /// Use this for:
    /// - rollback on persistence failure (newly uploaded images)
    /// - deleting user-removed existing images after a successful save
    func cleanupStorage(for images: [VendorImage]) async
    
}

enum ImageUploadServiceError: Error {
    case emptyDrafts
    case jpegEncodingFailed
}

/// Default implementation that orchestrates:
/// - (1) local resize per variant
/// - (2) upload via `ImageUploadRepository`
/// - (3) build `VendorImage` + `VendorImageVariant`
/// - (4) rollback uploaded files on failure
final class DefaultImageUploadService: ImageUploadService {

    private let uploadRepo: any ImageUploadRepository

    init(uploadRepo: any ImageUploadRepository) {
        self.uploadRepo = uploadRepo
    }
    
    private func buildThumbnailRef(
        images: [VendorImage],
        thumbnailImageId: String?
    ) -> VendorThumbnailRef? {
        guard
            let id = thumbnailImageId,
            let img = images.first(where: { $0.id == id }),
            let v = img.variants.first(where: { $0.kind == .thumbnail })
                ?? img.variants.first
        else { return nil }

        return VendorThumbnailRef(imageId: id, storagePath: v.storagePath)
    }

    func uploadVendorImages(
        vendorId: String,
        drafts: [ImageDraft],
        uploaderUserId: String? = nil,
        config: ImageUploadConfig = .networkMinimized
    ) async throws -> ImageUploadResult {

        guard !drafts.isEmpty else { throw ImageUploadServiceError.emptyDrafts }

        // Preserve user selection order. Sort order policy for now:
        // - thumbnailImageId will be the image with `sortOrder == 0`.
        // - Later, when UI allows a user-picked representative image, swap the selection logic.
        let orderedDrafts = drafts

        var uploadedPaths: [String] = []
        do {
            var vendorImages: [VendorImage] = []
            vendorImages.reserveCapacity(orderedDrafts.count)

            for draft in orderedDrafts {
                let imageId = draft.id
                let vendorImage = try await uploadOne(
                    vendorId: vendorId,
                    imageId: imageId,
                    sortOrder: draft.sortOrder,
                    draft: draft,
                    uploaderUserId: uploaderUserId,
                    config: config,
                    uploadedPaths: &uploadedPaths
                )
                vendorImages.append(vendorImage)
            }

            let thumbId = vendorImages.first(where: { $0.sortOrder == 0 })?.id
            let thumbRef = buildThumbnailRef(images: vendorImages, thumbnailImageId: thumbId)

            return ImageUploadResult(images: vendorImages, thumbnail: thumbRef)

        } catch {
            // Rollback: delete any files uploaded so far.
            for path in uploadedPaths {
                try? await uploadRepo.delete(storagePath: path)
            }
            throw error
        }
    }
    
    

    private func uploadOne(
        vendorId: String,
        imageId: String,
        sortOrder: Int,
        draft: ImageDraft,
        uploaderUserId: String?,
        config: ImageUploadConfig,
        uploadedPaths: inout [String]
    ) async throws -> VendorImage {

        var variants: [VendorImageVariant] = []
        variants.reserveCapacity(config.kinds.count)

        for kind in config.kinds {
            let outputImage = draft.uiImage.resizedForUpload(kind: kind, config: config)
            guard let data = outputImage.jpegDataStrippingMetadata(quality: config.jpegQuality) else {
                throw ImageUploadServiceError.jpegEncodingFailed
            }

            let storagePath = try await uploadRepo.upload(
                data: data,
                vendorId: vendorId,
                imageId: imageId,
                kind: kind
            )
            uploadedPaths.append(storagePath)

            let (w, h) = outputImage.pixelSize
            variants.append(
                VendorImageVariant(
                    kind: kind,
                    storagePath: storagePath,
                    width: w,
                    height: h,
                    byteSize: data.count,
                    contentType: "image/jpeg",
                    checksum: nil
                )
            )
        }

        return VendorImage(
            id: imageId,
            sortOrder: sortOrder,
            variants: variants,
            createdAt: .now,
            uploadedByUserId: uploaderUserId,
            status: .active,
            caption: nil
        )
    }
    
    func applyVendorImageChanges(
            vendorId: String,
            existingImages: [VendorImage],
            imageItems: [ImageSlot],
            deletedExistingImageIds: Set<String>,
            thumbnailItemId: String?,
            drafts: [ImageDraft],
            uploaderUserId: String? = nil,
            config: ImageUploadConfig = .networkMinimized
        ) async throws -> ImageUploadResult {

            // 1) Order and identify upload target based on Grid order
            let draftsToUpload = VendorImageEditor.orderedDraftsForUpload(
                imageItems: imageItems,
                drafts: drafts
            )

            // 2) No previous data upload
            var uploadedById: [String: VendorImage] = [:]
            if !draftsToUpload.isEmpty {
                let uploadResult = try await uploadVendorImages(
                    vendorId: vendorId,
                    drafts: draftsToUpload,
                    uploaderUserId: uploaderUserId,
                    config: config
                )
                uploadedById = Dictionary(uniqueKeysWithValues: uploadResult.images.map { ($0.id, $0) })
            }

            // 3) Previous data
            let existingById = Dictionary(uniqueKeysWithValues: existingImages.map { ($0.id, $0) })

            // 4) final images to upload
            let finalImages = VendorImageEditor.buildFinalImages(
                imageItems: imageItems,
                deletedExistingImageIds: deletedExistingImageIds,
                existingById: existingById,
                uploadedById: uploadedById
            )

            // 5) final thumbnail decision
            let finalThumbnailId = VendorImageEditor.resolvedThumbnailImageId(
                thumbnailItemId: thumbnailItemId,
                finalImages: finalImages
            )

            let thumbRef = buildThumbnailRef(images: finalImages, thumbnailImageId: finalThumbnailId)
            return ImageUploadResult(images: finalImages, thumbnail: thumbRef)
        }
    
    func cleanupStorage(for images: [VendorImage]) async {
        let paths = Self.collectDeletableStoragePaths(from: images)
        for path in paths {
            try? await uploadRepo.delete(storagePath: path)
        }
    }

    private static func collectDeletableStoragePaths(from images: [VendorImage]) -> [String] {
        var set: Set<String> = []
        for image in images {
            for v in image.variants {
                let p = v.storagePath
                // Avoid deleting local asset placeholders.
                guard !p.hasPrefix("asset:") else { continue }
                set.insert(p)
            }
        }
        return Array(set)
    }
}

// MARK: - UIKit resize helpers (iPhone-only today)
private extension UIImage {
    
    /// Encode JPEG while stripping metadata (EXIF/GPS/etc.).
    ///
    /// Notes:
    /// - This intentionally does NOT copy any source image properties.
    /// - For most PhotosPicker images, your current resize + re-encode already drops metadata,
    ///   but this makes it explicit and future-proof (e.g., if an original data pass-through is added later).
    func jpegDataStrippingMetadata(quality: CGFloat) -> Data? {
        // Prefer CGImage path (most reliable with ImageIO).
        if let cgImage = self.cgImage {
            let outData = NSMutableData()
            let jpegUTI = UTType.jpeg.identifier as CFString
            guard let destination = CGImageDestinationCreateWithData(outData, jpegUTI, 1, nil) else {
                return nil
            }

            // Do not include metadata dictionaries (EXIF/GPS). Only set compression quality.
            let options: CFDictionary = [
                kCGImageDestinationLossyCompressionQuality: quality
            ] as CFDictionary

            CGImageDestinationAddImage(destination, cgImage, options)
            guard CGImageDestinationFinalize(destination) else {
                return nil
            }
            return outData as Data
        }

        // Fallback: re-encode via UIKit.
        // (Typically also strips metadata, but keep as a safe fallback for CIImage-backed cases.)
        return self.jpegData(compressionQuality: quality)
    }

    var pixelSize: (Int?, Int?) {
        let w = Int(size.width * scale)
        let h = Int(size.height * scale)
        return (w > 0 ? w : nil, h > 0 ? h : nil)
    }

    func resizedForUpload(kind: VendorImageVariantKind, config: ImageUploadConfig) -> UIImage {
        switch kind {
        case .thumbnail:
            return resizedToFit(maxPixel: config.thumbnailMaxPixel) ?? self
        case .medium:
            return resizedToFit(maxPixel: config.mediumMaxPixel) ?? self
        case .original:
            // iPhone-only assumption: cap original to reduce network usage.
            // If you later need full-resolution originals, raise this cap or upload original separately.
            return resizedToFit(maxPixel: config.originalMaxPixel) ?? self
        }
    }

    /// Returns a new image downscaled to fit within `maxPixel` on the longest side.
    /// If the image is already smaller than `maxPixel`, returns `self`.
    func resizedToFit(maxPixel: CGFloat) -> UIImage? {
        let pixelW = size.width * scale
        let pixelH = size.height * scale
        guard pixelW > 0, pixelH > 0 else { return nil }

        let maxSide = max(pixelW, pixelH)
        guard maxSide > maxPixel else { return self }

        let ratio = maxPixel / maxSide
        let newSize = CGSize(width: pixelW * ratio, height: pixelH * ratio)

        let format = UIGraphicsImageRendererFormat()
        // We operate in pixel space already, so fix renderer scale to 1.
        format.scale = 1

        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
