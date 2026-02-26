import Foundation

// MARK: - Vendor Write Service (UseCase)
/// ViewModel should validate user input first, then call this service.
/// This service orchestrates:
/// - image changes (upload/new order/thumbnail) via ImageUploadService
/// - vendor persistence via VendorWriteRepository
/// - best-effort rollback of newly uploaded images when persistence fails
@MainActor
protocol VendorWriteService {

    func registerVendor(
        input: VendorValidatedInput,
        form: VendorForm,
        imageItems: [ImageSlot],
        thumbnailItemId: String?,
        drafts: [ImageDraft],
        uploader: User,
        config: ImageUploadConfig
    ) async throws -> VendorSummary

    func updateVendor(
        vendorId: String,
        input: VendorValidatedInput,
        form: VendorForm,
        imageItems: [ImageSlot],
        deletedExistingImageIds: Set<String>,
        thumbnailItemId: String?,
        drafts: [ImageDraft],
        uploader: User,
        config: ImageUploadConfig
    ) async throws -> VendorSummary

    func updateSummaryStatus(
        vendorId: String,
        status: VendorStatus,
        actor: User
    ) async throws -> VendorSummary

    func updateSummaryMarkCount(
        vendorId: String,
        delta: Int
    ) async throws -> VendorSummary

    /// Policy helper: resolves the vendor status after an admin decision for a status request.
    /// - Parameters:
    ///   - requestType: The vendor's requested status change type.
    ///   - decision: Admin decision for the request.
    ///   - currentStatusAtSubmission: The vendor status captured at the time the request was submitted.
    ///   - existingVendorStatus: The vendor status currently stored.
    func resolveStatusAfterDecision(
        requestType: VendorStatusRequestType,
        decision: VendorStatusDecision,
        currentStatusAtSubmission: VendorStatus,
        existingVendorStatus: VendorStatus
    ) -> VendorStatus
    
    func softDeleteVendor(
        vendorId: String,
        actor: User
    ) async throws -> VendorSummary
}

struct VendorValidatedInput {
    let name: String
    let district: String
    let addressDetail: String
    let description: LocalizedText
    let contactEmail: String?
    let contactPhone: String?
    let externalLinks: [ExternalLink]

    init(
        name: String,
        district: String,
        addressDetail: String,
        description: LocalizedText,
        contactEmail: String?,
        contactPhone: String?,
        externalLinks: [ExternalLink]
    ) {
        self.name = name
        self.district = district
        self.addressDetail = addressDetail
        self.description = description
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
        self.externalLinks = externalLinks
    }
}

struct VendorWriteServiceError: Error {
    let title: String
    let message: String
    let underlying: Error?

    init(title: String, message: String, underlying: Error? = nil) {
        self.title = title
        self.message = message
        self.underlying = underlying
    }
}

@MainActor
final class DefaultVendorWriteService: VendorWriteService {
    
    private let vendorWriteRepo: any VendorWriteRepository
    private let vendorReadRepo: VendorReadRepositoryBundle
    private let imageUploadService: any ImageUploadService
    
    
    init(
        vendorWriteRepo: any VendorWriteRepository,
        vendorReadRepo: VendorReadRepositoryBundle,
        imageUploadService: any ImageUploadService
    ) {
        self.vendorWriteRepo = vendorWriteRepo
        self.vendorReadRepo = vendorReadRepo
        self.imageUploadService = imageUploadService
    }
    
    // MARK: - Register
    func registerVendor(
        input: VendorValidatedInput,
        form: VendorForm,
        imageItems: [ImageSlot],
        thumbnailItemId: String?,
        drafts: [ImageDraft],
        uploader: User,
        config: ImageUploadConfig = .networkMinimized
    ) async throws -> VendorSummary {
        
        guard uploader.role != .user else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.registerOnlyVendorOrAdmin.msg")
            )
        }
        
        let now = Date()
        let newVendorId = UUID().uuidString
        let newPublicId = UUID().uuidString
        
        // 1) Image apply (register = drafts only)
        let imageResult: ImageUploadResult
        do {
            imageResult = try await imageUploadService.applyVendorImageChanges(
                vendorId: newVendorId,
                existingImages: [],
                imageItems: imageItems,
                deletedExistingImageIds: [],
                thumbnailItemId: thumbnailItemId,
                drafts: drafts,
                uploaderUserId: uploader.id,
                config: config
            )
        } catch {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.imageUploadFailed.title"),
                message: String(localized: "vws.alert.tryAgain.msg"),
                underlying: error
            )
        }
        
        // 2) Build models (Summary + Detail + Profile Images)
        let summary = VendorSummary(
            id: newVendorId,
            publicId: newPublicId,
            name: input.name,
            manager: uploader.id,
            thumbnail: imageResult.thumbnail,
            locationCountry: form.country,
            locationCity: form.city,
            locationDistrict: input.district,
            locationDetail: input.addressDetail,
            status: .hidden,
            createdAt: now,
            updatedAt: now,
            languages: form.languages,
            category: form.category,
            reviewCount: 0,
            rating: 0,
            markCount: 0
        )
        
        let detail = VendorDetail(
            id: newVendorId,
            contactEmail: input.contactEmail,
            contactPhone: input.contactPhone,
            description: input.description,
            externalLinks: input.externalLinks
        )
        
        let profile = VendorProfileImage(
            id: newVendorId,
            images: imageResult.images
        )
        
        // 3) Persist (best-effort rollback)
        var createdSummary = false
        var createdDetail = false
        
        do {
            try await vendorWriteRepo.createSummary(summary)
            createdSummary = true
            
            try await vendorWriteRepo.createDetail(detail)
            createdDetail = true
            
            try await vendorWriteRepo.createProfileImage(profile)
            
            return summary
        } catch {
            // Rollback created DB records (best-effort)
            try? await vendorWriteRepo.deleteProfileImage(id: newVendorId)

            if createdDetail { try? await vendorWriteRepo.deleteDetail(id: newVendorId) }
            if createdSummary { try? await vendorWriteRepo.deleteSummary(id: newVendorId) }
            
            
            // Rollback uploaded files (best-effort)
            await cleanupStorageBestEffort(images: imageResult.images)
            
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.saveFailed.title"),
                message: String(localized: "vws.alert.registerSaveFailed.msg"),
                underlying: error
            )
        }
    }
    
    // MARK: - Update
    func updateVendor(
        vendorId: String,
        input: VendorValidatedInput,
        form: VendorForm,
        imageItems: [ImageSlot],
        deletedExistingImageIds: Set<String>,
        thumbnailItemId: String?,
        drafts: [ImageDraft],
        uploader: User,
        config: ImageUploadConfig = .networkMinimized
    ) async throws -> VendorSummary {
        
        guard uploader.role != .user else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.sessionInvalid.msg")
            )
        }
        
        // 1) Load existing
        let existingOpt: VendorSummary?
        if uploader.role == .admin {
            existingOpt = try await vendorReadRepo.admin.readAdminSummary(id: vendorId)
        } else {
            existingOpt = try await vendorReadRepo.portal.readVendorSummary(userId: uploader.id, id: vendorId)
        }
        
        guard var existing = existingOpt else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.error.title"),
                message: String(localized: "vws.alert.vendorNotFoundForUpdate.msg")
            )
        }
        
        // 1b) Load existing detail/profile
        let existingDetailOpt: VendorDetail?
        let existingProfileOpt: VendorProfileImage?
        
        if uploader.role == .admin {
            existingDetailOpt = try await vendorReadRepo.admin.readAdminDetail(id: vendorId)
            existingProfileOpt = try await vendorReadRepo.admin.readAdminProfileImage(id: vendorId)
        } else {
            existingDetailOpt = try await vendorReadRepo.portal.readVendorDetail(userId: uploader.id, id: vendorId)
            existingProfileOpt = try await vendorReadRepo.portal.readVendorProfileImage(userId: uploader.id, id: vendorId)
        }
        
        
        let existingImages = existingProfileOpt?.images ?? []
        
        // 2) Access check
        guard existing.status.canEditVendorContent else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.updateNotAllowed.title"),
                message: String(localized: "vws.alert.updateNotAllowed.msg")
            )
        }
        
        if uploader.role != .admin, existing.manager != uploader.id {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.noPermissionToEdit.msg")
            )
        }
        
        let deletedExistingImages = existingImages.filter { deletedExistingImageIds.contains($0.id) }
        
        // 3) Apply image edits (keep existing unless deleted; upload new; reorder; set thumbnail)
        let imageResult: ImageUploadResult
        do {
            imageResult = try await imageUploadService.applyVendorImageChanges(
                vendorId: vendorId,
                existingImages: existingImages,
                imageItems: imageItems,
                deletedExistingImageIds: deletedExistingImageIds,
                thumbnailItemId: thumbnailItemId,
                drafts: drafts,
                uploaderUserId: uploader.id,
                config: config
            )
        } catch {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.imageUploadFailed.title"),
                message: String(localized: "vws.alert.tryAgain.msg"),
                underlying: error
            )
        }
        
        // 4) Update Summary
        let originalSummary = existing
        
        existing.name = input.name
        existing.locationCountry = form.country
        existing.locationCity = form.city
        existing.locationDistrict = input.district
        existing.locationDetail = input.addressDetail
        existing.thumbnail = imageResult.thumbnail
        existing.languages = form.languages
        existing.category = form.category
        existing.updatedAt = Date()
        existing.status = existing.status.statusAfterContentUpdate()
        
        // 4b) Update Detail
        let originalDetail = existingDetailOpt
        var detail = existingDetailOpt ?? VendorDetail(
            id: vendorId,
            contactEmail: nil,
            contactPhone: nil,
            description: LocalizedText(),
            externalLinks: []
        )
        
        detail.contactEmail = input.contactEmail
        detail.contactPhone = input.contactPhone
        detail.description = input.description
        detail.externalLinks = input.externalLinks
        
        // 4c) Update Profile Images
        var profile = existingProfileOpt ?? VendorProfileImage(id: vendorId, images: [])
        profile.images = imageResult.images
        
        // 5) Persist (best-effort rollback)
        let newIds = Set(drafts.map { $0.id })
        let newlyUploaded = imageResult.images.filter { newIds.contains($0.id) }
        
        var updatedSummary = false
        var wroteDetail = false
        
        do {
            try await vendorWriteRepo.updateSummary(existing)
            updatedSummary = true

            if originalDetail == nil {
                try await vendorWriteRepo.createDetail(detail)
            } else {
                try await vendorWriteRepo.updateDetail(detail)
            }
            wroteDetail = true

            if existingProfileOpt == nil {
                try await vendorWriteRepo.createProfileImage(profile)
            } else {
                try await vendorWriteRepo.updateProfileImage(profile)
            }

            await cleanupStorageBestEffort(images: deletedExistingImages)
            return existing
        } catch {
            // Best-effort DB rollback to original state
            if wroteDetail {
                if let originalDetail {
                    try? await vendorWriteRepo.updateDetail(originalDetail)
                } else {
                    try? await vendorWriteRepo.deleteDetail(id: vendorId)
                }
            }

            if updatedSummary {
                try? await vendorWriteRepo.updateSummary(originalSummary)
            }

            // Best-effort storage rollback: delete only newly uploaded draft images.
            await cleanupStorageBestEffort(images: newlyUploaded)

            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.saveFailed.title"),
                message: String(localized: "vws.alert.updateSaveFailed.msg"),
                underlying: error
            )
        }
    }
    
    
    // MARK: - Status update
    func updateSummaryStatus(
        vendorId: String,
        status: VendorStatus,
        actor: User
    ) async throws -> VendorSummary {
        
        guard actor.role != .user else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.updateStatusOnlyVendorOrAdmin.msg")
            )
        }
        
        // Read existing with access control.
        let existingOpt: VendorSummary?
        if actor.role == .admin {
            existingOpt = try await vendorReadRepo.admin.readAdminSummary(id: vendorId)
        } else {
            existingOpt = try await vendorReadRepo.portal.readVendorSummary(userId: actor.id, id: vendorId)
        }
        
        guard let existing = existingOpt else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.error.title"),
                message: String(localized: "vws.alert.vendorNotFound.msg")
            )
        }
        
        if actor.role != .admin, existing.manager != actor.id {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.noPermissionToUpdate.msg")
            )
        }
        
        var updated = existing
        updated.status = status
        updated.updatedAt = Date()
        
        try await vendorWriteRepo.updateSummary(updated)
        return updated
    }
    
    // MARK: - MarkCount update -> move to CloudFunction
    func updateSummaryMarkCount(
        vendorId: String,
        delta: Int
    ) async throws -> VendorSummary {
        
        // NOTE: markCount is currently a prototype field update.
        // In production, this should be handled by Cloud Functions / server-side aggregation.
        
        guard let existing = try await vendorReadRepo.open.readOpenSummary(id: vendorId) else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.error.title"),
                message: String(localized: "vws.alert.vendorNotFound.msg")
            )
        }
        
        var updated = existing
        updated.markCount = max(0, updated.markCount + delta)
        updated.updatedAt = Date()
        
        try await vendorWriteRepo.updateSummary(updated)
        return updated
    }
    
    // MARK: - Clean-up
    private func cleanupStorageBestEffort(images: [VendorImage]) async {
        await imageUploadService.cleanupStorage(for: images)
    }
    
    // MARK: - Status Decision Policy
    func resolveStatusAfterDecision(
        requestType: VendorStatusRequestType,
        decision: VendorStatusDecision,
        currentStatusAtSubmission: VendorStatus,
        existingVendorStatus: VendorStatus
    ) -> VendorStatus {
        
        switch decision {
        case .approved:
            switch requestType {
            case .requestActive: return .active
            case .requestHidden: return .hidden
            case .requestArchived: return .archived
            }
            
        case .rejected:
            // If activation is rejected, vendor becomes rejected.
            // For hide/archive rejections, revert to the status captured at submission time.
            if requestType == .requestActive {
                return .rejected
            }
            return currentStatusAtSubmission
            
        case .pending:
            // Keep whatever is currently stored.
            return existingVendorStatus
        }
    }
    
    func softDeleteVendor(
        vendorId: String,
        actor: User
    ) async throws -> VendorSummary {

        guard actor.role != .user else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.deleteOnlyVendorOrAdmin.msg")
            )
        }

        let existingOpt: VendorSummary?
        if actor.role == .admin {
            existingOpt = try await vendorReadRepo.admin.readAdminSummary(id: vendorId)
        } else {
            existingOpt = try await vendorReadRepo.portal.readVendorSummary(userId: actor.id, id: vendorId)
        }

        guard let existing = existingOpt else {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.error.title"),
                message: String(localized: "vws.alert.vendorNotFound.msg")
            )
        }

        if actor.role != .admin, existing.manager != actor.id {
            throw VendorWriteServiceError(
                title: String(localized: "vws.alert.permissionDenied.title"),
                message: String(localized: "vws.alert.noPermissionToDelete.msg")
            )
        }

        // soft delete = store.deleteSummary() (status == archived)
        try await vendorWriteRepo.softDeleteSummary(id: vendorId)

        var archived = existing
        archived.status = .archived
        archived.updatedAt = .now
        return archived
    }
    
}
