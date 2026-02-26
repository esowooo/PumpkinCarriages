






import Foundation

struct ImageSlot: Identifiable, Equatable {
    enum Source: Equatable {
        case existing(imageId: String)
        case draft(draftId: String)

        var stableId: String {
            switch self {
            case .existing(let imageId): return imageId
            case .draft(let draftId):   return draftId
            }
        }
    }

    var source: Source
    var sortOrder: Int
    var preferredStoragePath: String?

    // Identifiable
    var id: String { source.stableId }

    init(source: Source, sortOrder: Int, preferredStoragePath: String? = nil) {
        self.source = source
        self.sortOrder = sortOrder
        self.preferredStoragePath = preferredStoragePath
    }
}

enum VendorImageEditor {

    // MARK: - Reset
    static func reset(
        from summary: VendorSummary,
        existingImages: [VendorImage],
        thumbnail: VendorThumbnailRef?,
        imageItems: inout [ImageSlot],
        thumbnailItemId: inout String?,
        deletedExistingImageIds: inout Set<String>,
        drafts: inout [ImageDraft]
    ) {
        deletedExistingImageIds = []
        drafts = []

        let ordered = existingImages.sorted { $0.sortOrder < $1.sortOrder }
        imageItems = ordered.enumerated().map { idx, img in
            
            let preferredPath =
                img.variants.first(where: { $0.kind == .medium })?.storagePath
                ?? img.variants.first(where: { $0.kind == .original })?.storagePath
                ?? img.variants.first?.storagePath

            return ImageSlot(
                source: .existing(imageId: img.id),
                sortOrder: idx,
                preferredStoragePath: preferredPath
            )
        }

        if let thumbId = thumbnail?.imageId,
           imageItems.contains(where: { $0.id == thumbId }) {
            thumbnailItemId = thumbId
        } else {
            thumbnailItemId = imageItems.first?.id
        }
   
    }

    // MARK: - Normalize
    static func normalizeOrder(
        imageItems: inout [ImageSlot],
        drafts: inout [ImageDraft],
        thumbnailItemId: inout String?
    ) {
        for idx in imageItems.indices {
            imageItems[idx].sortOrder = idx

            if case .draft(let draftId) = imageItems[idx].source,
               let dIdx = drafts.firstIndex(where: { $0.id == draftId }) {
                drafts[dIdx].sortOrder = idx
            }
        }

        if let thumb = thumbnailItemId,
           imageItems.contains(where: { $0.id == thumb }) == false {
            thumbnailItemId = imageItems.first?.id
        }
    }

    // MARK: - Add Drafts
    static func addDraftImages(
        _ incomingDrafts: [ImageDraft],
        imageItems: inout [ImageSlot],
        draftsStore: inout [ImageDraft],
        thumbnailItemId: inout String?,
        maxImageCount: Int,
        onLimitReached: () -> Void
    ) {
        guard !incomingDrafts.isEmpty else { return }

        let existingIds = Set(imageItems.map { $0.id })
        let uniqueDrafts = incomingDrafts.filter { existingIds.contains($0.id) == false }
        guard !uniqueDrafts.isEmpty else { return }

        let capacity = max(0, maxImageCount - imageItems.count)
        guard capacity > 0 else { onLimitReached(); return }

        let drafts = Array(uniqueDrafts.prefix(capacity))
        let base = imageItems.count

        for (offset, var draft) in drafts.enumerated() {
            if imageItems.count >= maxImageCount { break }

            draft.sortOrder = base + offset
            upsertDraft(draft, draftsStore: &draftsStore)

            imageItems.append(
                ImageSlot(
                    source: .draft(draftId: draft.id),
                    sortOrder: draft.sortOrder
                )
            )
        }

        if thumbnailItemId == nil {
            thumbnailItemId = imageItems.first?.id
        }

        normalizeOrder(imageItems: &imageItems, drafts: &draftsStore, thumbnailItemId: &thumbnailItemId)
    }

    private static func upsertDraft(_ draft: ImageDraft, draftsStore: inout [ImageDraft]) {
        if let idx = draftsStore.firstIndex(where: { $0.id == draft.id }) {
            draftsStore[idx] = draft
        } else {
            draftsStore.append(draft)
        }
    }

    // MARK: - Submit helpers
    static func orderedDraftsForUpload(imageItems: [ImageSlot], drafts: [ImageDraft]) -> [ImageDraft] {
        let draftIds: [String] = imageItems.compactMap {
            if case .draft(let draftId) = $0.source { return draftId }
            return nil
        }
        return draftIds.compactMap { id in drafts.first(where: { $0.id == id }) }
    }

    static func buildFinalImages(
        imageItems: [ImageSlot],
        deletedExistingImageIds: Set<String>,
        existingById: [String: VendorImage],
        uploadedById: [String: VendorImage]
    ) -> [VendorImage] {
        var result: [VendorImage] = []
        result.reserveCapacity(imageItems.count)

        for item in imageItems {
            switch item.source {
            case .existing(let imageId):
                if deletedExistingImageIds.contains(imageId) { continue }
                if let img = existingById[imageId] { result.append(img) }

            case .draft(let draftId):
                if let img = uploadedById[draftId] { result.append(img) }
            }
        }

        for idx in result.indices {
            result[idx].sortOrder = idx
        }
        return result
    }

    static func resolvedThumbnailImageId(thumbnailItemId: String?, finalImages: [VendorImage]) -> String? {
        guard !finalImages.isEmpty else { return nil }
        if let thumb = thumbnailItemId,
           finalImages.contains(where: { $0.id == thumb }) {
            return thumb
        }
        return finalImages.first?.id
    }
}
