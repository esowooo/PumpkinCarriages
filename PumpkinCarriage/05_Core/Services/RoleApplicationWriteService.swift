import Foundation

@MainActor
protocol RoleApplicationWriteService {
    
    // User-side
    func load(userId: String, fallbackVerificationCode: String) -> (RoleApplication?, RoleApplicationForm)
    
    func saveRegistration(
        userId: String,
        currentRole: Role,
        form: RoleApplicationForm,
        existing: RoleApplication?
    ) -> RoleApplication
    
    func submitEvidence(
        userId: String,
        form: RoleApplicationForm,
        existing: RoleApplication
    ) -> RoleApplication
    
    func startResubmission(
        userId: String,
        existing: RoleApplication,
        generateVerificationCode: () -> String
    ) -> (RoleApplication, String)
    
    
    // Admin-side
    func approve(applicationId: String, actor: AdminActor) throws -> RoleApplication
    func reject(
        applicationId: String,
        actor: AdminActor,
        rejectionCategory: RoleApplicationRejectionCategory,
        comment: String
    ) throws -> RoleApplication

    func setEvidenceStatus(
        applicationId: String,
        evidenceID: String,
        newStatus: EvidenceReviewStatus,
        actor: AdminActor,
        note: String?
    ) throws -> RoleApplication
}


@MainActor
final class DefaultRoleApplicationWriteService: RoleApplicationWriteService {
    
    private let repo: any RoleApplicationRepository
    private let userRepo: any UserRepository

    init(repo: any RoleApplicationRepository, userRepo: any UserRepository) {
        self.repo = repo
        self.userRepo = userRepo
    }
    
    
    func load(userId: String, fallbackVerificationCode: String) -> (RoleApplication?, RoleApplicationForm) {
        if let app = repo.application(for: userId) {
            return (app, RoleApplicationForm(from: app, fallbackVerificationCode: fallbackVerificationCode))
        } else {
            var form = RoleApplicationForm()
            form.verificationCode = fallbackVerificationCode
            return (nil, form)
        }
    }
    
    func saveRegistration(
        userId: String,
        currentRole: Role,
        form: RoleApplicationForm,
        existing: RoleApplication?
    ) -> RoleApplication {
        
        var f = form
        f.syncConfirmedAtIfNeeded()
        
        let prevTermsVersion = existing?.termsVersion
        let prevConfirmedAt = existing?.confirmedAt
        
        guard f.canSaveRegistration else {
            return existing ?? RoleApplication(
                applicantUserId: userId,
                currentRole: currentRole,
                requestedRole: .vendor,
                applicant: f.toApplicantProfile(),
                evidence: [],
                messageToAdmin: f.messageToAdmin.trimmedOrNil,
                termsVersion: RoleAttestationTerms.version,
                confirmsAuthority: false,
                confirmsRights: false,
                confirmedAt: .now,
                termsLocale: RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: RoleAttestationTerms.currentTextSnapshot()
            )
        }
        
        var app: RoleApplication
        let isNew: Bool
        
        if var e = existing {
            guard e.status == .initial || e.status == .rejected else {
                return e
            }
            isNew = false
            e.applicant = f.toApplicantProfile()
            e.brandName = f.brandName.trimmedOrNil
            e.brandCategory = f.brandCategory.trimmedOrNil
            e.messageToAdmin = f.messageToAdmin.trimmedOrNil

            // Attestation / audit
            e.confirmsAuthority = f.confirmsAuthority
            e.confirmsRights = f.confirmsRights
            e.confirmedAt = f.confirmedAt ?? e.confirmedAt
            e.termsVersion = f.termsVersion ?? e.termsVersion
            e.termsLocale = f.termsLocale ?? e.termsLocale
            e.termsTextSnapshot = f.termsTextSnapshot ?? e.termsTextSnapshot

            e.updatedAt = .now
            app = e
        } else {
            isNew = true
            app = RoleApplication(
                applicantUserId: userId,
                currentRole: currentRole,
                requestedRole: .vendor,
                applicant: f.toApplicantProfile(),
                brandName: f.brandName.trimmedOrNil,
                brandCategory: f.brandCategory.trimmedOrNil,
                evidence: [],
                messageToAdmin: f.messageToAdmin.trimmedOrNil,

                // Attestation / audit
                termsVersion: f.termsVersion ?? RoleAttestationTerms.version,
                confirmsAuthority: f.confirmsAuthority,
                confirmsRights: f.confirmsRights,
                confirmedAt: f.confirmedAt ?? .now,
                termsLocale: f.termsLocale ?? RoleAttestationTerms.currentLocaleCode(),
                termsTextSnapshot: f.termsTextSnapshot ?? RoleAttestationTerms.currentTextSnapshot(),

                status: .initial,
                createdAt: .now,
                updatedAt: .now,
                decision: nil
            )
        }
        
        repo.save(app)
        
        let changed = [
          "applicantName","roleTitle","contactEmail","contactPhone",
          "confirmsAuthority","confirmsRights","confirmedAt",
          "termsVersion","termsLocale","termsTextSnapshot",
          "brandName","brandCategory","messageToAdmin"
        ]
        let event = RoleApplicationEventFactory.registrationEvent(
            app: app,
            actorUserId: userId,
            actorRole: .user,
            isNew: isNew,
            changedFields: changed
        )
        repo.appendEvent(event)
        
        let didUpdateTerms = (prevTermsVersion == nil) || (app.termsVersion != prevTermsVersion) || (app.confirmedAt != prevConfirmedAt)
        if didUpdateTerms {
            let termsPayload = RoleApplicationEventPayload(kind: .termsUpdated)
            repo.appendEvent(RoleApplicationEvent(
                applicationId: app.id,
                applicantUserId: app.applicantUserId,
                actorUserId: userId,
                actorRole: .user,
                type: .termsUpdated,
                occurredAt: .now,
                prevStatus: nil,
                newStatus: nil,
                payload: termsPayload
            ))
        }
        
        return app
    }
    
    func submitEvidence(
        userId: String,
        form: RoleApplicationForm,
        existing: RoleApplication
    ) -> RoleApplication {
        
        var app = existing
        let prevStatus = app.status
        
        guard app.status == .initial || app.status == .rejected else { return app }
        
        let evidence = form.toEvidenceItem()
        
        app.evidence = [evidence]
        app.status = .pending
        app.decision = nil
        app.updatedAt = .now
        
        repo.save(app)
        
        let event = RoleApplicationEventFactory.evidenceSubmittedEvent(
            app: app,
            actorUserId: userId,
            actorRole: .user,
            prevStatus: prevStatus,
            evidence: evidence
        )
        repo.appendEvent(event)
        
        return app
    }
    
    /// returns: (updatedApp, newVerificationCode)
    func startResubmission(
        userId: String,
        existing: RoleApplication,
        generateVerificationCode: () -> String
    ) -> (RoleApplication, String) {
        
        var app = existing
        guard app.status == .rejected else { return (app, app.evidence.first?.verificationCode ?? "") }
        let prevStatus = app.status
        
        app.status = .initial
        app.evidence = []
        app.decision = nil
        app.updatedAt = .now
        
        repo.save(app)
        
        let newCode = generateVerificationCode()
        
        let event = RoleApplicationEventFactory.resubmissionStartedEvent(
            app: app,
            actorUserId: userId,
            actorRole: .user,
            prevStatus: prevStatus,
            newVerificationCodeGenerated: true
        )
        repo.appendEvent(event)
        
        return (app, newCode)
    }
    
    
    func approve(applicationId: String, actor: AdminActor) throws -> RoleApplication {
            guard actor.isAdmin else { throw RoleApplicationAdminError.notAdmin }
            guard !actor.userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw RoleApplicationAdminError.invalidSession }
            guard let app = repo.application(by: applicationId) else { throw RoleApplicationAdminError.applicationNotFound }
            guard app.status == .pending || app.status == .initial else { throw RoleApplicationAdminError.statusNotActionable }


            var updated = app
            updated.status = .approved
            updated.updatedAt = .now
            updated.decision = RoleApplicationDecision(
                reviewerUserId: actor.userId,
                decidedAt: .now,
                result: .approved,
                rejectionCategory: nil,
                comment: nil
            )

            do {
                try userRepo.updateRole(userId: updated.applicantUserId, role: .vendor)
            } catch {
                throw RoleApplicationAdminError.roleUpdateFailed
            }

            repo.save(updated)

            let payload = RoleApplicationEventPayload(
                kind: .decision,
                decision: DecisionEventPayload(
                    reviewerUserId: actor.userId,
                    decidedAt: updated.decision?.decidedAt ?? .now,
                    result: .approved,
                    rejectionCategory: nil,
                    comment: nil
                )
            )

            repo.appendEvent(RoleApplicationEvent(
                applicationId: updated.id,
                applicantUserId: updated.applicantUserId,
                actorUserId: actor.userId,
                actorRole: .admin,
                type: .decisionMade,
                occurredAt: .now,
                prevStatus: app.status,
                newStatus: updated.status,
                payload: payload
            ))

            return updated
        }

    func reject(
        applicationId: String,
        actor: AdminActor,
        rejectionCategory: RoleApplicationRejectionCategory,
        comment: String
    ) throws -> RoleApplication {

        guard actor.isAdmin else { throw RoleApplicationAdminError.notAdmin }
        guard !actor.userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RoleApplicationAdminError.invalidSession
        }
        guard let app = repo.application(by: applicationId) else {
            throw RoleApplicationAdminError.applicationNotFound
        }
        guard app.status == .pending || app.status == .initial else {
            throw RoleApplicationAdminError.statusNotActionable
        }

        let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)

        var updated = app
        updated.status = .rejected
        updated.updatedAt = .now
        updated.decision = RoleApplicationDecision(
            reviewerUserId: actor.userId,
            decidedAt: .now,
            result: .rejected,
            rejectionCategory: rejectionCategory,
            comment: trimmedComment.isEmpty ? nil : trimmedComment
        )

        repo.save(updated)

        let payload = RoleApplicationEventPayload(
            kind: .decision,
            decision: DecisionEventPayload(
                reviewerUserId: actor.userId,
                decidedAt: updated.decision?.decidedAt ?? .now,
                result: .rejected,
                rejectionCategory: rejectionCategory,
                comment: trimmedComment.isEmpty ? nil : trimmedComment
            )
        )

        repo.appendEvent(
            RoleApplicationEvent(
                applicationId: updated.id,
                applicantUserId: updated.applicantUserId,
                actorUserId: actor.userId,
                actorRole: .admin,
                type: .decisionMade,
                occurredAt: .now,
                prevStatus: app.status,
                newStatus: updated.status,
                payload: payload
            )
        )

        return updated
    }

    func setEvidenceStatus(
        applicationId: String,
        evidenceID: String,
        newStatus: EvidenceReviewStatus,
        actor: AdminActor,
        note: String?
    ) throws -> RoleApplication {

        guard actor.isAdmin else { throw RoleApplicationAdminError.notAdmin }
        guard !actor.userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RoleApplicationAdminError.invalidSession
        }
        guard var app = repo.application(by: applicationId) else {
            throw RoleApplicationAdminError.applicationNotFound
        }
        guard !app.evidence.isEmpty else {
            throw RoleApplicationAdminError.missingEvidence
        }
        guard let idx = app.evidence.firstIndex(where: { $0.id == evidenceID }) else {
            throw RoleApplicationAdminError.evidenceNotFound
        }

        var item = app.evidence[idx]

        item.status = newStatus
        item.reviewNote = note?.trimmingCharacters(in: .whitespacesAndNewlines)
        item.reviewedByUserId = actor.userId

        if newStatus == .verified {
            item.verifiedAt = .now
        } else if newStatus == .rejected {
            item.verifiedAt = nil
        }

        if item.submittedAt == nil,
           (newStatus == .submitted || newStatus == .verified || newStatus == .rejected) {
            item.submittedAt = .now
        }

        app.evidence[idx] = item
        app.updatedAt = .now
        repo.save(app)

        let payload = RoleApplicationEventPayload(
            kind: .evidence,
            evidence: EvidenceEventPayload(
                evidenceId: item.id,
                method: item.method,
                contactEmailHint: item.contactEmailHint,
                contactEmailURL: item.contactEmailURL,
                channelURL: item.channelURL,
                channelURLDetail: item.channelURLDetail,
                verificationCode: item.verificationCode,
                submittedAt: item.submittedAt
            )
        )

        repo.appendEvent(
            RoleApplicationEvent(
                applicationId: app.id,
                applicantUserId: app.applicantUserId,
                actorUserId: actor.userId,
                actorRole: .admin,
                type: .statusChanged,
                occurredAt: .now,
                prevStatus: app.status,
                newStatus: app.status,
                payload: payload
            )
        )

        return app
    }
    
    
}

// MARK: - Small string helpers
private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var trimmedOrNil: String? {
        let t = trimmed
        return t.isEmpty ? nil : t
    }
}


enum RoleApplicationAdminError: Error {
    case notAdmin
    case invalidSession
    case applicationNotFound
    case statusNotActionable
    case missingConfirmations
    case missingEvidence
    case evidenceNotVerified
    case evidenceNotFound
    case roleUpdateFailed
}
