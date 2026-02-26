import Foundation

@MainActor
protocol StatusApplicationRepository {
    
    // MARK: - Reads (Latest Snapshot + Events)
    func readByVendorId(_ vendorId: String) -> VendorStatusApplication?
    func readByVendorPublicId(_ vendorPublicId: String) -> VendorStatusApplication?
    
    /// Admin list: latest snapshot per vendor (one item per vendor).
    func listAllLatest() -> [VendorStatusApplication]
    
    /// Applicant list: latest snapshots for vendors owned by this applicant user.
    /// (This is NOT history. History is events.)
    func listLatestForApplicantUser(_ userId: String) -> [VendorStatusApplication]
    
    func listEvents(statusApplicationId: String) -> [VendorStatusApplicationEvent]
    
    /// True if there is already a pending request for the same vendor + requestType.
    func hasPending(vendorId: String, requestType: VendorStatusRequestType) -> Bool
    
    // MARK: - Writes
    /// Create or replace the "latest snapshot" per vendor.
    @discardableResult
    func submitOrResubmit(
        _ draft: VendorStatusApplication,
        actorUserId: String,
        now: Date
    ) throws -> VendorStatusApplication
    
    @discardableResult
    func updateDecision(
        applicationId: String,
        decision: VendorStatusDecision,
        reviewedByUserId: String,
        reviewedAt: Date,
        rejectionReason: String?
    ) throws -> VendorStatusApplication
    
    func appendVendorStatusApplied(
        applicationId: String,
        actorUserId: String,
        occurredAt: Date
    ) throws

    /// Record that the applicant agreed to a new termsVersion for this application.
    func appendTermsUpdated(
        applicationId: String,
        actorUserId: String,
        newTermsVersion: String,
        agreedAt: Date
    ) throws
}

enum StatusApplicationRepositoryError: Error {
    case duplicatePending
    case notFound
}

final class MockStatusApplicationRepository: StatusApplicationRepository {
    
    static let shared = MockStatusApplicationRepository(
        
        statusApplications: VendorStatusApplicationMockSeed.makeStatusApplications(),
        statusApplicationEvents: VendorStatusApplicationMockSeed.makeStatusEvents()
    )
    
    private init(
        statusApplications: [VendorStatusApplication],
        statusApplicationEvents: [VendorStatusApplicationEvent]
    ) {
        // latest snapshot per vendor
        var dict: [String: VendorStatusApplication] = [:]
        for app in statusApplications {
            dict[app.vendorId] = app
        }
        self.applicationsPerVendorId = dict
        
        // events per applicationId
        var eDict: [String: [VendorStatusApplicationEvent]] = [:]
        for e in statusApplicationEvents {
            eDict[e.statusApplicationId, default: []].append(e)
        }
        self.eventsPerApplicationId = eDict
    }
    
    // Single latest snapshot per vendorId
    private var applicationsPerVendorId: [String: VendorStatusApplication]
    private var eventsPerApplicationId: [String: [VendorStatusApplicationEvent]]
    
    // MARK: - Reads
    
    func readByVendorId(_ vendorId: String) -> VendorStatusApplication? {
        applicationsPerVendorId[vendorId]
    }

    func readByVendorPublicId(_ vendorPublicId: String) -> VendorStatusApplication? {
        applicationsPerVendorId.values.first(where: { $0.vendorPublicId == vendorPublicId })
    }
    
    func listAllLatest() -> [VendorStatusApplication] {
        applicationsPerVendorId.values
            .sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    func listLatestForApplicantUser(_ userId: String) -> [VendorStatusApplication] {
        applicationsPerVendorId.values
            .filter { $0.applicantUserId == userId }
            .sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    func listEvents(statusApplicationId: String) -> [VendorStatusApplicationEvent] {
        (eventsPerApplicationId[statusApplicationId] ?? [])
            .sorted(by: { $0.occurredAt < $1.occurredAt })
    }
    
    func hasPending(vendorId: String, requestType: VendorStatusRequestType) -> Bool {
        guard let app = applicationsPerVendorId[vendorId] else { return false }
        return app.requestType == requestType && app.decision == .pending
    }
    
    // MARK: - Writes
    @discardableResult
    func submitOrResubmit(
        _ draft: VendorStatusApplication,
        actorUserId: String,
        now: Date
    ) throws -> VendorStatusApplication {
        
        if hasPending(vendorId: draft.vendorId, requestType: draft.requestType) {
            throw StatusApplicationRepositoryError.duplicatePending
        }
        
        if let existing = applicationsPerVendorId[draft.vendorId] {
            let updated = VendorStatusApplication(
                id: existing.id,
                vendorId: existing.vendorId,
                vendorPublicId: existing.vendorPublicId,
                applicantUserId: draft.applicantUserId,
                requestType: draft.requestType,
                currentStatus: draft.currentStatus,
                message: draft.message,
                termsVersion: draft.termsVersion,
                agreedAt: draft.agreedAt,
                decision: .pending,
                reviewedByUserId: nil,
                reviewedAt: nil,
                rejectionReason: nil,
                createdAt: existing.createdAt,
                updatedAt: now
            )
            
            applicationsPerVendorId[draft.vendorId] = updated
            
            appendEvent(
                statusApplicationId: updated.id,
                vendorId: updated.vendorId,
                actorUserId: actorUserId,
                type: .resubmitted,
                occurredAt: now,
                requestType: updated.requestType,
                currentStatus: updated.currentStatus,
                message: updated.message
            )
            
            return updated
        } else {
            var created = draft
            created.decision = .pending
            created.reviewedByUserId = nil
            created.reviewedAt = nil
            created.rejectionReason = nil
            created.updatedAt = now
            
            applicationsPerVendorId[created.vendorId] = created
            
            appendEvent(
                statusApplicationId: created.id,
                vendorId: created.vendorId,
                actorUserId: actorUserId,
                type: .submitted,
                occurredAt: now,
                requestType: created.requestType,
                currentStatus: created.currentStatus,
                message: created.message
            )
            
            return created
        }
    }
    
    @discardableResult
    func updateDecision(
        applicationId: String,
        decision: VendorStatusDecision,
        reviewedByUserId: String,
        reviewedAt: Date,
        rejectionReason: String?
    ) throws -> VendorStatusApplication {
        
        guard let vendorId = vendorId(for: applicationId),
              var app = applicationsPerVendorId[vendorId]
        else { throw StatusApplicationRepositoryError.notFound }
        
        app.decision = decision
        app.reviewedByUserId = reviewedByUserId
        app.reviewedAt = reviewedAt
        app.rejectionReason = rejectionReason
        app.updatedAt = reviewedAt
        
        applicationsPerVendorId[vendorId] = app
        
        let eventType: VendorStatusApplicationEventType =
        (decision == .approved) ? .decidedApproved : .decidedRejected
        
        appendEvent(
            statusApplicationId: app.id,
            vendorId: app.vendorId,
            actorUserId: reviewedByUserId,
            type: eventType,
            occurredAt: reviewedAt,
            decision: decision,
            rejectionReason: rejectionReason
        )
        
        return app
    }
    
    func appendVendorStatusApplied(
        applicationId: String,
        actorUserId: String,
        occurredAt: Date
    ) throws {
        guard let vendorId = vendorId(for: applicationId),
              let app = applicationsPerVendorId[vendorId]
        else { throw StatusApplicationRepositoryError.notFound }
        
        appendEvent(
            statusApplicationId: app.id,
            vendorId: app.vendorId,
            actorUserId: actorUserId,
            type: .vendorStatusApplied,
            occurredAt: occurredAt
        )
    }
    
    func appendTermsUpdated(
        applicationId: String,
        actorUserId: String,
        newTermsVersion: String,
        agreedAt: Date
    ) throws {
        guard let vendorId = vendorId(for: applicationId),
              var app = applicationsPerVendorId[vendorId]
        else { throw StatusApplicationRepositoryError.notFound }
        
        // Update snapshot with the new terms and agreement time
        app.termsVersion = newTermsVersion
        app.agreedAt = agreedAt
        app.updatedAt = agreedAt
        applicationsPerVendorId[vendorId] = app
        
        // Append event noting the terms update
        appendEvent(
            statusApplicationId: app.id,
            vendorId: app.vendorId,
            actorUserId: actorUserId,
            type: .termsUpdated,
            occurredAt: agreedAt,
            message: newTermsVersion
        )
    }
    
    // MARK: - Helpers
    @MainActor
    private func vendorId(for applicationId: String) -> String? {
        applicationsPerVendorId.first(where: { $0.value.id == applicationId })?.key
    }
    
    @MainActor
    private func appendEvent(
        statusApplicationId: String,
        vendorId: String,
        actorUserId: String,
        type: VendorStatusApplicationEventType,
        occurredAt: Date,
        requestType: VendorStatusRequestType? = nil,
        currentStatus: VendorStatus? = nil,
        message: String? = nil,
        decision: VendorStatusDecision? = nil,
        rejectionReason: String? = nil
    ) {
        let event = VendorStatusApplicationEvent(
            statusApplicationId: statusApplicationId,
            vendorId: vendorId,
            actorUserId: actorUserId,
            type: type,
            occurredAt: occurredAt,
            requestType: requestType,
            currentStatus: currentStatus,
            message: message,
            decision: decision,
            rejectionReason: rejectionReason
        )
        
        eventsPerApplicationId[statusApplicationId, default: []].append(event)
    }
}



// MARK: - Mock Seed
enum VendorStatusApplicationMockSeed {
    static func makeStatusApplications() -> [VendorStatusApplication] {
        [
            VendorStatusApplication(
                id: "vsa_studioB",
                vendorId: "studioB",
                vendorPublicId: "public_studioB",
                applicantUserId: "vendor1",
                requestType: .requestActive,
                currentStatus: .pending,
                message: "Initial activation request.",
                termsVersion: "2026-01-12",
                agreedAt: makeDate(2026, 1, 12, 10, 0),
                decision: .pending,
                reviewedByUserId: nil,
                reviewedAt: nil,
                rejectionReason: nil,
                createdAt: makeDate(2026, 1, 12, 10, 1),
                updatedAt: makeDate(2026, 1, 12, 10, 1)
            ),
            
            VendorStatusApplication(
                id: "vsa_hmC",
                vendorId: "hmC",
                vendorPublicId: "public_hmC",
                applicantUserId: "vendor3",
                requestType: .requestArchived,
                currentStatus: .archived,
                message: "Archive request (duplicate listing).",
                termsVersion: "2026-01-06",
                agreedAt: makeDate(2026, 1, 6, 9, 0),
                decision: .approved,
                reviewedByUserId: "admin1",
                reviewedAt: makeDate(2026, 1, 6, 12, 0),
                rejectionReason: nil,
                createdAt: makeDate(2026, 1, 6, 9, 1),
                updatedAt: makeDate(2026, 1, 6, 12, 0)
            ),
            
            VendorStatusApplication(
                id: "vsa_dressA",
                vendorId: "dressA",
                vendorPublicId: "public_dressA",
                applicantUserId: "vendor2",
                requestType: .requestHidden,
                currentStatus: .hidden,
                message: "Requesting hide (temporary maintenance).",
                termsVersion: "2026-01-11",
                agreedAt: makeDate(2026, 1, 11, 14, 0),
                decision: .approved,
                reviewedByUserId: "admin1",
                reviewedAt: makeDate(2026, 1, 12, 12, 0),
                rejectionReason: nil,
                createdAt: makeDate(2026, 1, 11, 14, 1),
                updatedAt: makeDate(2026, 1, 12, 12, 0)
            ),
            
            // studioC: latest snapshot is pending (represents a resubmission currently pending review)
            VendorStatusApplication(
                id: "vsa_studioC",
                vendorId: "studioC",
                vendorPublicId: "public_studioC",
                applicantUserId: "vendor1",
                requestType: .requestActive,
                currentStatus: .rejected,
                message: "Resubmitting with updated info and proof.",
                termsVersion: "2026-01-10",
                agreedAt: makeDate(2026, 1, 10, 9, 30),
                decision: .pending,
                reviewedByUserId: nil,
                reviewedAt: nil,
                rejectionReason: nil,
                createdAt: makeDate(2026, 1, 10, 9, 31),
                updatedAt: makeDate(2026, 1, 10, 13, 1)
            )
        ]
    }
    
    static func makeStatusEvents() -> [VendorStatusApplicationEvent] {
        [
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_studioB",
                vendorId: "studioB",
                actorUserId: "vendor1",
                type: .submitted,
                occurredAt: makeDate(2026, 1, 12, 10, 1),
                requestType: .requestActive,
                currentStatus: .pending,
                message: "Initial activation request."
            ),
            
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_hmC",
                vendorId: "hmC",
                actorUserId: "vendor3",
                type: .submitted,
                occurredAt: makeDate(2026, 1, 6, 9, 1),
                requestType: .requestArchived,
                currentStatus: .archived,
                message: "Archive request (duplicate listing)."
            ),
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_hmC",
                vendorId: "hmC",
                actorUserId: "admin1",
                type: .decidedApproved,
                occurredAt: makeDate(2026, 1, 6, 12, 0),
                decision: .approved
            ),
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_hmC",
                vendorId: "hmC",
                actorUserId: "admin1",
                type: .vendorStatusApplied,
                occurredAt: makeDate(2026, 1, 6, 12, 1)
            ),
            
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_studioC",
                vendorId: "studioC",
                actorUserId: "vendor1",
                type: .submitted,
                occurredAt: makeDate(2026, 1, 10, 9, 31),
                requestType: .requestActive,
                currentStatus: .active,
                message: "Initial activation submission."
            ),
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_studioC",
                vendorId: "studioC",
                actorUserId: "admin1",
                type: .decidedRejected,
                occurredAt: makeDate(2026, 1, 10, 13, 0),
                decision: .rejected,
                rejectionReason: "Insufficient proof of ownership."
            ),
            VendorStatusApplicationEvent(
                statusApplicationId: "vsa_studioC",
                vendorId: "studioC",
                actorUserId: "vendor1",
                type: .resubmitted,
                occurredAt: makeDate(2026, 1, 10, 13, 1),
                requestType: .requestActive,
                currentStatus: .rejected,
                message: "Resubmitting with updated info and proof."
            )
            
        ]
    }
}


