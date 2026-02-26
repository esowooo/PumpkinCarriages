import Foundation

@MainActor
protocol RoleApplicationRepository {

    // MARK: - Current application
    func application(for userId: String) -> RoleApplication?
    func application(by applicationId: String) -> RoleApplication?
    func allLatestApplications() -> [RoleApplication]
    func currentApplicationId(for userId: String) -> String?

    // MARK: - Write
    func save(_ app: RoleApplication)

    // MARK: - Events
    func eventsByUser(for userId: String) -> [RoleApplicationEvent]
    func events(for applicationId: String) -> [RoleApplicationEvent]
    func appendEvent(_ event: RoleApplicationEvent)
}

/// Single source of truth for RoleApplication + RoleApplicationEvent in Mock mode.
///
/// Policy (Mock): "1 application per user".
/// - Keep the latest application per user (seeded by updatedAt).
/// - Writes always overwrite the current mapping for that user.
@MainActor
final class MockRoleApplicationRepository: RoleApplicationRepository {
    static let shared = MockRoleApplicationRepository(
        roleApplications: RoleApplicationMockSeed.makeRoleApplications(),
        roleApplicationEvents: RoleApplicationMockSeed.makeRoleApplicationEvents()
    )

    // Single latest snapshot per userId
    private var applicationsPerUserId: [String: RoleApplication]
    private var applicationsPerId: [String: RoleApplication]
    private var roleApplicationEvents: [RoleApplicationEvent]

    /// Test-only seeding initializer.
    /// Policy (Mock): "1 application per user" (keep the latest by updatedAt).
    private init(
        roleApplications: [RoleApplication],
        roleApplicationEvents: [RoleApplicationEvent]
    ) {
        let latest = Self.normalizedLatestPerUser(roleApplications)
        self.applicationsPerUserId = Dictionary(uniqueKeysWithValues: latest.map { ($0.applicantUserId, $0) })
        self.applicationsPerId = Dictionary(uniqueKeysWithValues: latest.map { ($0.id, $0) })
        self.roleApplicationEvents = roleApplicationEvents
    }

    // MARK: - Current application
    func application(for userId: String) -> RoleApplication? {
        applicationsPerUserId[userId]
    }

    func application(by applicationId: String) -> RoleApplication? {
        applicationsPerId[applicationId]
    }

    func allLatestApplications() -> [RoleApplication] {
        applicationsPerUserId.values.sorted(by: { $0.updatedAt > $1.updatedAt })
    }

    func currentApplicationId(for userId: String) -> String? {
        application(for: userId)?.id
    }

    // MARK: - Write
    /// Policy: 1 application per user (overwrite the latest record for that user).
    func save(_ app: RoleApplication) {
        // Overwrite current app for this userId (policy: 1 per user)
        applicationsPerUserId[app.applicantUserId] = app
        applicationsPerId[app.id] = app

        // Ensure uniqueness by updating any stale entries with a different id for the same user
        for (uid, existing) in applicationsPerUserId where uid == app.applicantUserId && existing.id != app.id {
            applicationsPerUserId[uid] = app
        }
    }

    // MARK: - Events
    func eventsByUser(for userId: String) -> [RoleApplicationEvent] {
        guard let appId = currentApplicationId(for: userId) else { return [] }
        return events(for: appId)
    }

    func events(for applicationId: String) -> [RoleApplicationEvent] {
        roleApplicationEvents
            .filter { $0.applicationId == applicationId }
            .sorted(by: { $0.occurredAt < $1.occurredAt })
    }

    func appendEvent(_ event: RoleApplicationEvent) {
        roleApplicationEvents.append(event)
    }

    // MARK: - Helpers
    private static func normalizedLatestPerUser(_ list: [RoleApplication]) -> [RoleApplication] {
        let grouped = Dictionary(grouping: list, by: { $0.applicantUserId })
        return grouped.values.compactMap { apps in
            apps.max(by: { $0.updatedAt < $1.updatedAt })
        }
    }
}



// MARK: - Mock Seed
enum RoleApplicationMockSeed {

    static func makeRoleApplications() -> [RoleApplication] {
        [
            // app_001 (user1) — pending, evidence verified
            RoleApplication(
                id: "app_001",
                applicantUserId: "user1",
                currentRole: .user,
                requestedRole: .vendor,
                applicant: ApplicantProfile(
                    applicantName: "Applicant A",
                    roleTitle: "Owner",
                    contactEmail: "a@example.com",
                    contactPhone: nil
                ),
                brandName: "Studio A",
                brandCategory: "Studio",
                evidence: [
                    EvidenceItem(
                        method: .codePost,
                        status: .verified,
                        submittedAt: .now,
                        verifiedAt: .now,
                        reviewedByUserId: "admin",
                        reviewNote: "Code found on official page",
                        channelURL: "https://example.com/studioA",
                        verificationCode: "ABCD-1234"
                    )
                ],
                messageToAdmin: "Please review.",
                termsVersion: RoleAttestationTerms.version,
                confirmsAuthority: true,
                confirmsRights: true,
                confirmedAt: .now,
                termsLocale: RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: RoleAttestationTerms.currentTextSnapshot(),
                status: .pending,
                createdAt: .now,
                updatedAt: .now,
                decision: nil
            ),

            // app_002 (vendor1) — pending, evidence submitted
            RoleApplication(
                id: "app_002",
                applicantUserId: "vendor1",
                currentRole: .user,
                requestedRole: .vendor,
                applicant: ApplicantProfile(
                    applicantName: "Applicant B",
                    roleTitle: "Manager",
                    contactEmail: nil,
                    contactPhone: nil
                ),
                brandName: "Dress B",
                brandCategory: "Dress",
                evidence: [
                    EvidenceItem(
                        method: .officialEmail,
                        status: .submitted,
                        submittedAt: .now,
                        contactEmailHint: "dressA@brand.com",
                        contactEmailURL: "https://www.instagram.com/brand"
                    )
                ],
                messageToAdmin: nil,
                termsVersion: RoleAttestationTerms.version,
                confirmsAuthority: true,
                confirmsRights: true,
                confirmedAt: .now,
                termsLocale: RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: RoleAttestationTerms.currentTextSnapshot(),
                status: .pending,
                createdAt: .now,
                updatedAt: .now,
                decision: nil
            ),

            // app_003 (vendor2) — rejected (admin decision)
            RoleApplication(
                id: "app_003",
                applicantUserId: "vendor2",
                currentRole: .user,
                requestedRole: .vendor,
                applicant: ApplicantProfile(
                    applicantName: "Applicant C",
                    roleTitle: "Owner",
                    contactEmail: nil,
                    contactPhone: nil
                ),
                brandName: "HM C",
                brandCategory: "Hair & Makeup",
                evidence: [
                    EvidenceItem(
                        method: .codePost,
                        status: .verified,
                        submittedAt: .now,
                        verifiedAt: .now,
                        reviewedByUserId: "admin",
                        reviewNote: nil,
                        channelURL: "https://example.com/hmc",
                        verificationCode: "ZZZZ-9999"
                    )
                ],
                messageToAdmin: nil,
                termsVersion: RoleAttestationTerms.version,
                confirmsAuthority: true,
                confirmsRights: true,
                confirmedAt: .now,
                termsLocale: RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: RoleAttestationTerms.currentTextSnapshot(),
                status: .rejected,
                createdAt: .now.addingTimeInterval(-86400),
                updatedAt: .now.addingTimeInterval(-3600),
                decision: RoleApplicationDecision(
                    reviewerUserId: "admin",
                    decidedAt: .now.addingTimeInterval(-3600),
                    result: .rejected,
                    rejectionCategory: .ownership,
                    comment: "Insufficient proof of ownership."
                )
            ),

            // app_004 (vendor3) — approved (admin decision)
            RoleApplication(
                id: "app_004",
                applicantUserId: "vendor3",
                currentRole: .user,
                requestedRole: .vendor,
                applicant: ApplicantProfile(
                    applicantName: "Applicant D",
                    roleTitle: "Owner",
                    contactEmail: nil,
                    contactPhone: nil
                ),
                brandName: "Studio D",
                brandCategory: "Studio",
                evidence: [
                    EvidenceItem(
                        method: .codePost,
                        status: .verified,
                        submittedAt: .now,
                        verifiedAt: .now,
                        reviewedByUserId: "admin",
                        reviewNote: nil,
                        channelURL: "https://example.com/studioD",
                        verificationCode: "DDDD-4444"
                    )
                ],
                messageToAdmin: nil,
                termsVersion: RoleAttestationTerms.version,
                confirmsAuthority: true,
                confirmsRights: true,
                confirmedAt: .now,
                termsLocale: RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: RoleAttestationTerms.currentTextSnapshot(),
                status: .approved,
                createdAt: .now.addingTimeInterval(-86400),
                updatedAt: .now.addingTimeInterval(-3600),
                decision: RoleApplicationDecision(
                    reviewerUserId: "admin",
                    decidedAt: .now.addingTimeInterval(-3600),
                    result: .approved,
                    rejectionCategory: nil,
                    comment: nil
                )
            )
        ]
    }
    
    static func makeRoleApplicationEvents() -> [RoleApplicationEvent] {
            [
                // app_001 (user1) — pending, evidence verified
                RoleApplicationEvent(
                    applicationId: "app_001",
                    applicantUserId: "user1",
                    actorUserId: "user1",
                    actorRole: .user,
                    type: .applicationCreated,
                    occurredAt: makeDate(2026, 1, 12, 9, 50),
                    prevStatus: nil,
                    newStatus: .initial,
                    payload: RoleApplicationEventPayload(
                        kind: .registration,
                        registration: RegistrationEventPayload(
                            applicant: ApplicantProfile(
                                applicantName: "Applicant A",
                                roleTitle: "Owner",
                                contactEmail: "a@example.com",
                                contactPhone: nil
                            ),
                            brandName: "Studio A",
                            brandCategory: "Studio",
                            messageToAdmin: "Please review.",
                            changedFields: ["applicant", "brandName", "brandCategory", "messageToAdmin"]
                        )
                    )
                ),
                RoleApplicationEvent(
                    applicationId: "app_001",
                    applicantUserId: "user1",
                    actorUserId: "user1",
                    actorRole: .user,
                    type: .evidenceSubmitted,
                    occurredAt: makeDate(2026, 1, 12, 9, 55),
                    prevStatus: .initial,
                    newStatus: .pending,
                    payload: RoleApplicationEventPayload(
                        kind: .evidence,
                        evidence: EvidenceEventPayload(
                            evidenceId: "ev_app001_01",
                            method: .codePost,
                            contactEmailHint: nil,
                            contactEmailURL: nil,
                            channelURL: "https://example.com/studioA",
                            channelURLDetail: nil,
                            verificationCode: "ABCD-1234",
                            submittedAt: makeDate(2026, 1, 12, 9, 55)
                        )
                    )
                ),

                // app_002 (vendor1) — pending, evidence submitted
                RoleApplicationEvent(
                    applicationId: "app_002",
                    applicantUserId: "vendor1",
                    actorUserId: "vendor1",
                    actorRole: .user,
                    type: .applicationCreated,
                    occurredAt: makeDate(2026, 1, 12, 10, 10),
                    prevStatus: nil,
                    newStatus: .initial,
                    payload: RoleApplicationEventPayload(
                        kind: .registration,
                        registration: RegistrationEventPayload(
                            applicant: ApplicantProfile(
                                applicantName: "Applicant B",
                                roleTitle: "Manager",
                                contactEmail: nil,
                                contactPhone: nil
                            ),
                            brandName: "Dress B",
                            brandCategory: "Dress",
                            messageToAdmin: nil,
                            changedFields: ["applicant", "brandName", "brandCategory"]
                        )
                    )
                ),
                RoleApplicationEvent(
                    applicationId: "app_002",
                    applicantUserId: "vendor1",
                    actorUserId: "vendor1",
                    actorRole: .user,
                    type: .evidenceSubmitted,
                    occurredAt: makeDate(2026, 1, 12, 10, 20),
                    prevStatus: .initial,
                    newStatus: .pending,
                    payload: RoleApplicationEventPayload(
                        kind: .evidence,
                        evidence: EvidenceEventPayload(
                            evidenceId: "ev_app002_01",
                            method: .officialEmail,
                            contactEmailHint: "dressA@brand.com",
                            contactEmailURL: "https://www.instagram.com/brand",
                            channelURL: nil,
                            channelURLDetail: nil,
                            verificationCode: nil,
                            submittedAt: makeDate(2026, 1, 12, 10, 20)
                        )
                    )
                ),

                // app_003 (vendor2) — rejected (admin decision)
                RoleApplicationEvent(
                    applicationId: "app_003",
                    applicantUserId: "vendor2",
                    actorUserId: "vendor2",
                    actorRole: .user,
                    type: .applicationCreated,
                    occurredAt: makeDate(2026, 1, 10, 11, 0),
                    prevStatus: nil,
                    newStatus: .initial,
                    payload: RoleApplicationEventPayload(
                        kind: .registration,
                        registration: RegistrationEventPayload(
                            applicant: ApplicantProfile(
                                applicantName: "Applicant C",
                                roleTitle: "Owner",
                                contactEmail: nil,
                                contactPhone: nil
                            ),
                            brandName: "HM C",
                            brandCategory: "Hair & Makeup",
                            messageToAdmin: nil,
                            changedFields: ["applicant", "brandName", "brandCategory"]
                        )
                    )
                ),
                RoleApplicationEvent(
                    applicationId: "app_003",
                    applicantUserId: "vendor2",
                    actorUserId: "admin",
                    actorRole: .admin,
                    type: .decisionMade,
                    occurredAt: makeDate(2026, 1, 10, 15, 30),
                    prevStatus: .pending,
                    newStatus: .rejected,
                    payload: RoleApplicationEventPayload(
                        kind: .decision,
                        decision: DecisionEventPayload(
                            reviewerUserId: "admin",
                            decidedAt: makeDate(2026, 1, 10, 15, 30),
                            result: .rejected,
                            rejectionCategory: .ownership,
                            comment: "Insufficient proof of ownership."
                        )
                    )
                ),

                // app_004 (vendor3) — approved decision (seed decision result에 맞춤)
                RoleApplicationEvent(
                    applicationId: "app_004",
                    applicantUserId: "vendor3",
                    actorUserId: "vendor3",
                    actorRole: .user,
                    type: .applicationCreated,
                    occurredAt: makeDate(2026, 1, 9, 10, 0),
                    prevStatus: nil,
                    newStatus: .initial,
                    payload: RoleApplicationEventPayload(
                        kind: .registration,
                        registration: RegistrationEventPayload(
                            applicant: ApplicantProfile(
                                applicantName: "Applicant D",
                                roleTitle: "Owner",
                                contactEmail: nil,
                                contactPhone: nil
                            ),
                            brandName: "Studio D",
                            brandCategory: "Studio",
                            messageToAdmin: nil,
                            changedFields: ["applicant", "brandName", "brandCategory"]
                        )
                    )
                ),
                RoleApplicationEvent(
                    applicationId: "app_004",
                    applicantUserId: "vendor3",
                    actorUserId: "admin",
                    actorRole: .admin,
                    type: .decisionMade,
                    occurredAt: makeDate(2026, 1, 9, 18, 0),
                    prevStatus: .pending,
                    newStatus: .approved,
                    payload: RoleApplicationEventPayload(
                        kind: .decision,
                        decision: DecisionEventPayload(
                            reviewerUserId: "admin",
                            decidedAt: makeDate(2026, 1, 9, 18, 0),
                            result: .approved,
                            rejectionCategory: nil,
                            comment: nil
                        )
                    )
                )
            ]
        }
}
