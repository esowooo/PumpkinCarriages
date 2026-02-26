import Foundation

// MARK: - Role Application (current state)
struct RoleApplication: Codable, Identifiable, Hashable {
    let id: String

    let applicantUserId: String
    let currentRole: Role
    let requestedRole: Role

    var applicant: ApplicantProfile

    var brandName: String?
    var brandCategory: String?

    var evidence: [EvidenceItem]
    var messageToAdmin: String?

    /// Terms/attestation version (e.g., "2026-02-13") saved with the application for audit.
    var termsVersion: String
    var confirmsAuthority: Bool
    var confirmsRights: Bool
    var confirmedAt: Date

    /// Language code (e.g., "ja", "ko", "en") that was used when the user agreed.
    /// Optional for backward-compat decoding of older stored data.
    var termsLocale: String?

    /// Snapshot of the exact attestation texts shown at the time of agreement (audit).
    /// Key = RoleAttestationItem.rawValue (e.g., "authority", "rights").
    /// Optional for backward-compat decoding of older stored data.
    var termsTextSnapshot: [String: String]?

    var status: RoleApplicationStatus
    let createdAt: Date
    var updatedAt: Date

    var decision: RoleApplicationDecision?

    init(
        id: String = UUID().uuidString,
        applicantUserId: String,
        currentRole: Role,
        requestedRole: Role = .vendor,
        applicant: ApplicantProfile,
        brandName: String? = nil,
        brandCategory: String? = nil,
        evidence: [EvidenceItem],
        messageToAdmin: String? = nil,
        termsVersion: String = RoleAttestationTerms.version,
        confirmsAuthority: Bool,
        confirmsRights: Bool,
        confirmedAt: Date = .now,
        termsLocale: String? = RoleAttestationTerms.currentLocaleCode(),
        termsTextSnapshot: [String: String]? = RoleAttestationTerms.currentTextSnapshot(),
        status: RoleApplicationStatus = .initial,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        decision: RoleApplicationDecision? = nil
    ) {
        self.id = id
        self.applicantUserId = applicantUserId
        self.currentRole = currentRole
        self.requestedRole = requestedRole
        self.applicant = applicant
        self.brandName = brandName
        self.brandCategory = brandCategory
        self.evidence = evidence
        self.messageToAdmin = messageToAdmin
        self.termsVersion = termsVersion
        self.confirmsAuthority = confirmsAuthority
        self.confirmsRights = confirmsRights
        self.confirmedAt = confirmedAt
        self.termsLocale = termsLocale
        self.termsTextSnapshot = termsTextSnapshot
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.decision = decision
    }
}

struct ApplicantProfile: Codable, Hashable {
    var applicantName: String
    var roleTitle: String
    var contactEmail: String?
    var contactPhone: String?

    init(
        applicantName: String,
        roleTitle: String,
        contactEmail: String? = nil,
        contactPhone: String? = nil
    ) {
        self.applicantName = applicantName
        self.roleTitle = roleTitle
        self.contactEmail = contactEmail
        self.contactPhone = contactPhone
    }
}

struct EvidenceItem: Codable, Identifiable, Hashable {
    let id: String

    var method: EvidenceMethod
    var status: EvidenceReviewStatus
    var submittedAt: Date?
    var verifiedAt: Date?
    var reviewedByUserId: String?
    var reviewNote: String?

    var contactEmailHint: String?
    var contactEmailURL: String?

    var channelURL: String?
    var channelURLDetail: String?

    var verificationCode: String?
    var codePostedAt: Date?

    init(
        id: String = UUID().uuidString,
        method: EvidenceMethod,
        status: EvidenceReviewStatus = .initial,
        submittedAt: Date? = nil,
        verifiedAt: Date? = nil,
        reviewedByUserId: String? = nil,
        reviewNote: String? = nil,
        contactEmailHint: String? = nil,
        contactEmailURL: String? = nil,
        channelURL: String? = nil,
        channelURLDetail: String? = nil,
        verificationCode: String? = nil,
        codePostedAt: Date? = nil
    ) {
        self.id = id
        self.method = method
        self.status = status
        self.submittedAt = submittedAt
        self.verifiedAt = verifiedAt
        self.reviewedByUserId = reviewedByUserId
        self.reviewNote = reviewNote
        self.contactEmailHint = contactEmailHint
        self.contactEmailURL  = contactEmailURL
        self.channelURL = channelURL
        self.channelURLDetail = channelURLDetail
        self.verificationCode = verificationCode
        self.codePostedAt = codePostedAt
    }
}

// MARK: - Status / Decision
enum RoleApplicationStatus: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case initial
    case pending
    case approved
    case rejected
    case archived
    
    var displayName: String {
        switch self {
        case .approved: return String(localized: "ra.status.approved")
        case .rejected: return String(localized: "ra.status.rejected")
        case .initial: return String(localized: "ra.status.initial")
        case .pending: return String(localized: "ra.status.pending")
        case .archived: return String(localized: "ra.status.archived")
        }
    }
    
    var description: String {
        switch self {
        case .approved: return String(localized: "ra.statusDesc.approved")
        case .rejected: return String(localized: "ra.statusDesc.rejected")
        case .initial: return String(localized: "ra.statusDesc.initial")
        case .pending: return String(localized: "ra.statusDesc.pending")
        case .archived: return String(localized: "ra.statusDesc.archived")
        }
    }
}

enum RoleApplicationDecisionResult: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case approved
    case rejected
}

struct RoleApplicationDecision: Codable, Hashable {
    var reviewerUserId: String
    var decidedAt: Date
    var result: RoleApplicationDecisionResult
    var rejectionCategory: RoleApplicationRejectionCategory?
    var comment: String?

    init(
        reviewerUserId: String,
        decidedAt: Date = .now,
        result: RoleApplicationDecisionResult,
        rejectionCategory: RoleApplicationRejectionCategory? = nil,
        comment: String? = nil
    ) {
        self.reviewerUserId = reviewerUserId
        self.decidedAt = decidedAt
        self.result = result
        self.rejectionCategory = rejectionCategory
        self.comment = comment
    }
}

enum RoleApplicationRejectionCategory: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case ownership
    case identity
    case policy
    case other
}

// MARK: - Evidence
enum EvidenceMethod: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case officialEmail
    case codePost
}

enum EvidenceReviewStatus: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    case initial
    case submitted
    case verified
    case rejected

    var displayName: String {
        switch self {
        case .verified: return String(localized: "ra.evidence.verified")
        case .submitted: return String(localized: "ra.evidence.submitted")
        case .initial: return String(localized: "ra.evidence.initial")
        case .rejected: return String(localized: "ra.evidence.rejected")
        }
    }
}

// MARK: - Events (history / audit) — Hybrid: diff-first + partial snapshots
struct RoleApplicationEvent: Codable, Identifiable, Hashable {
    let id: String

    let applicationId: String
    let applicantUserId: String

    let actorUserId: String
    let actorRole: Role

    let type: RoleApplicationEventType
    let occurredAt: Date

    let prevStatus: RoleApplicationStatus?
    let newStatus: RoleApplicationStatus?

    let payload: RoleApplicationEventPayload

    init(
        id: String = UUID().uuidString,
        applicationId: String,
        applicantUserId: String,
        actorUserId: String,
        actorRole: Role,
        type: RoleApplicationEventType,
        occurredAt: Date = .now,
        prevStatus: RoleApplicationStatus? = nil,
        newStatus: RoleApplicationStatus? = nil,
        payload: RoleApplicationEventPayload
    ) {
        self.id = id
        self.applicationId = applicationId
        self.applicantUserId = applicantUserId
        self.actorUserId = actorUserId
        self.actorRole = actorRole
        self.type = type
        self.occurredAt = occurredAt
        self.prevStatus = prevStatus
        self.newStatus = newStatus
        self.payload = payload
    }
}

enum RoleApplicationEventType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }

    case applicationCreated
    case registrationSaved
    case evidenceSubmitted
    case resubmissionStarted
    case termsUpdated

    // (admin) future
    case decisionMade
    case statusChanged
}

struct RoleApplicationEventPayload: Codable, Hashable {
    enum Kind: String, Codable, CaseIterable, Identifiable {
        var id: Self { self }
        case registration
        case evidence
        case resubmission
        case decision
        case statusChange
        case termsUpdated
    }

    let kind: Kind

    var registration: RegistrationEventPayload? = nil
    var evidence: EvidenceEventPayload? = nil
    var resubmission: ResubmissionEventPayload? = nil
    var decision: DecisionEventPayload? = nil
    var statusChange: StatusChangeEventPayload? = nil

    init(
        kind: Kind,
        registration: RegistrationEventPayload? = nil,
        evidence: EvidenceEventPayload? = nil,
        resubmission: ResubmissionEventPayload? = nil,
        decision: DecisionEventPayload? = nil,
        statusChange: StatusChangeEventPayload? = nil
    ) {
        self.kind = kind
        self.registration = registration
        self.evidence = evidence
        self.resubmission = resubmission
        self.decision = decision
        self.statusChange = statusChange
    }
}

// Diff-first + compact snapshot
struct RegistrationEventPayload: Codable, Hashable {
    var applicant: ApplicantProfile
    var brandName: String?
    var brandCategory: String?
    var messageToAdmin: String?
    var changedFields: [String]
}

// Partial snapshot (dispute-likely)
struct EvidenceEventPayload: Codable, Hashable {
    var evidenceId: String
    var method: EvidenceMethod

    var contactEmailHint: String?
    var contactEmailURL: String?

    var channelURL: String?
    var channelURLDetail: String?

    var verificationCode: String?
    var submittedAt: Date?
}

struct ResubmissionEventPayload: Codable, Hashable {
    var previousStatus: RoleApplicationStatus
    var newStatus: RoleApplicationStatus
    var resetEvidence: Bool
    var resetDecision: Bool
    var regeneratedVerificationCode: Bool
}

// (admin) future extension
struct DecisionEventPayload: Codable, Hashable {
    var reviewerUserId: String
    var decidedAt: Date
    var result: RoleApplicationDecisionResult
    var rejectionCategory: RoleApplicationRejectionCategory?
    var comment: String?
}

struct StatusChangeEventPayload: Codable, Hashable {
    var from: RoleApplicationStatus
    var to: RoleApplicationStatus
    var reason: String?
}


enum RoleAttestationItem: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }

    case authority
    case rights

    var titleKey: String {
        switch self {
        case .authority: return "av.checkbox.authority"
        case .rights: return "av.checkbox.rights"
        }
    }
    
    
    var displayTitle: String {
        switch self {
        case .authority: return String(localized: "av.checkbox.authority")
        case .rights:    return String(localized: "av.checkbox.rights")
        }
    }
}

struct RoleAttestationTerms {
    static let version: String = "2026-02-13"

    static func currentLocaleCode() -> String {
        Locale.current.language.languageCode?.identifier ?? "ja"
    }
    
    /// Returns a localized bundle for the given language code (ja/ko/en...), if available.
    /// Falls back to main bundle.
    private static func bundle(for localeCode: String) -> Bundle {
        if let path = Bundle.main.path(forResource: localeCode, ofType: "lproj"),
           let localizedBundle = Bundle(path: path) {
            return localizedBundle
        }
        return .main
    }

    /// Snapshot the exact texts shown in the UI (audit).
    /// Uses the localized strings resolved from the target locale bundle.
    static func textSnapshot(localeCode: String? = nil) -> [String: String] {
        let code = localeCode ?? currentLocaleCode()
        let b = bundle(for: code)
        
        return Dictionary(uniqueKeysWithValues: RoleAttestationItem.allCases.map { item in
            let value = b.localizedString(forKey: item.titleKey, value: item.titleKey, table: nil)
            return (item.rawValue, value)
        })
    }

    static func currentTextSnapshot() -> [String: String] {
        textSnapshot()
    }
}
