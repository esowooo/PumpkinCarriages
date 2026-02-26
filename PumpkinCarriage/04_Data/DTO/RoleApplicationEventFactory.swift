






import Foundation

enum RoleApplicationEventFactory {

    static func registrationEvent(
        app: RoleApplication,
        actorUserId: String,
        actorRole: Role,
        isNew: Bool,
        changedFields: [String]
    ) -> RoleApplicationEvent {

        let payload = RoleApplicationEventPayload(
            kind: .registration,
            registration: RegistrationEventPayload(
                applicant: app.applicant,
                brandName: app.brandName,
                brandCategory: app.brandCategory,
                messageToAdmin: app.messageToAdmin,
                changedFields: changedFields
            )
        )

        return RoleApplicationEvent(
            applicationId: app.id,
            applicantUserId: app.applicantUserId,
            actorUserId: actorUserId,
            actorRole: actorRole,
            type: isNew ? .applicationCreated : .registrationSaved,
            occurredAt: .now,
            prevStatus: nil,
            newStatus: app.status,
            payload: payload
        )
    }

    static func evidenceSubmittedEvent(
        app: RoleApplication,
        actorUserId: String,
        actorRole: Role,
        prevStatus: RoleApplicationStatus,
        evidence: EvidenceItem
    ) -> RoleApplicationEvent {

        let payload = RoleApplicationEventPayload(
            kind: .evidence,
            evidence: EvidenceEventPayload(
                evidenceId: evidence.id,
                method: evidence.method,
                contactEmailHint: evidence.contactEmailHint,
                contactEmailURL: evidence.contactEmailURL,
                channelURL: evidence.channelURL,
                channelURLDetail: evidence.channelURLDetail,
                verificationCode: evidence.verificationCode,
                submittedAt: evidence.submittedAt
            )
        )

        return RoleApplicationEvent(
            applicationId: app.id,
            applicantUserId: app.applicantUserId,
            actorUserId: actorUserId,
            actorRole: actorRole,
            type: .evidenceSubmitted,
            occurredAt: .now,
            prevStatus: prevStatus,
            newStatus: app.status,
            payload: payload
        )
    }

    static func resubmissionStartedEvent(
        app: RoleApplication,
        actorUserId: String,
        actorRole: Role,
        prevStatus: RoleApplicationStatus,
        newVerificationCodeGenerated: Bool
    ) -> RoleApplicationEvent {

        let payload = RoleApplicationEventPayload(
            kind: .resubmission,
            resubmission: ResubmissionEventPayload(
                previousStatus: prevStatus,
                newStatus: app.status,
                resetEvidence: true,
                resetDecision: true,
                regeneratedVerificationCode: newVerificationCodeGenerated
            )
        )

        return RoleApplicationEvent(
            applicationId: app.id,
            applicantUserId: app.applicantUserId,
            actorUserId: actorUserId,
            actorRole: actorRole,
            type: .resubmissionStarted,
            occurredAt: .now,
            prevStatus: prevStatus,
            newStatus: app.status,
            payload: payload
        )
    }
}
