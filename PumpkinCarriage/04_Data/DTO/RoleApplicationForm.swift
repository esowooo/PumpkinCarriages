import Foundation

struct RoleApplicationForm: Equatable {

    // MARK: Registration
    var applicantName: String = ""
    var roleTitle: String = ""
    var contactEmail: String = ""
    var contactPhone: String = ""

    var confirmsAuthority: Bool = false
    var confirmsRights: Bool = false
    var confirmedAt: Date? = nil
    var allConfirmed: Bool {
        confirmsRights && confirmsAuthority
    }

    // Audit (attestation) — keep optional in the DTO so "not agreed" is represented as nil.
    var termsVersion: String? = nil
    var termsLocale: String? = nil
    var termsTextSnapshot: [String: String]? = nil
    
    var brandName: String = ""
    var brandCategory: String = ""
    var messageToAdmin: String = ""

    // MARK: Evidence
    var selectedEvidenceMethod: EvidenceMethod = .codePost

    // Method 1
    var evidenceEmailHint: String = ""
    var evidenceEmailURL: String = ""

    // Method 2
    var evidenceChannelURL: String = ""
    var evidenceChannelDetail: String = ""
    var verificationCode: String = ""

    // MARK: - Init
    init() {}

    init(from app: RoleApplication, fallbackVerificationCode: String) {
        applicantName = app.applicant.applicantName
        roleTitle = app.applicant.roleTitle
        contactEmail = app.applicant.contactEmail ?? ""
        contactPhone = app.applicant.contactPhone ?? ""

        confirmsAuthority = app.confirmsAuthority
        confirmsRights = app.confirmsRights
        confirmedAt = app.confirmedAt
        // Always carry forward audit values; if missing (older data), regenerate best-effort snapshot.
        termsVersion = app.termsVersion.isEmpty ? nil : app.termsVersion
        termsLocale = (app.termsLocale?.isEmpty == false) ? app.termsLocale : RoleAttestationTerms.currentLocaleCode()
        termsTextSnapshot = app.termsTextSnapshot ?? RoleAttestationTerms.currentTextSnapshot()

        brandName = app.brandName ?? ""
        brandCategory = app.brandCategory ?? ""
        messageToAdmin = app.messageToAdmin ?? ""

        if let method = app.evidence.first?.method {
            selectedEvidenceMethod = method
        }
        verificationCode = app.evidence.first?.verificationCode ?? fallbackVerificationCode
        evidenceEmailHint = app.evidence.first?.contactEmailHint ?? ""
        evidenceEmailURL = app.evidence.first?.contactEmailURL ?? ""
        evidenceChannelURL = app.evidence.first?.channelURL ?? ""
        evidenceChannelDetail = app.evidence.first?.channelURLDetail ?? ""
    }

    // MARK: - Normalize
    mutating func syncConfirmedAtIfNeeded() {
        if confirmsAuthority && confirmsRights {
            if confirmedAt == nil { confirmedAt = .now }
            if termsVersion == nil || termsVersion?.isEmpty == true {
                termsVersion = RoleAttestationTerms.version
            }
            if termsLocale == nil || termsLocale?.isEmpty == true {
                termsLocale = RoleAttestationTerms.currentLocaleCode()
            }
            if termsTextSnapshot == nil || termsTextSnapshot?.isEmpty == true {
                termsTextSnapshot = RoleAttestationTerms.currentTextSnapshot()
            }
        } else {
            confirmedAt = nil
            termsVersion = nil
            termsLocale = nil
            termsTextSnapshot = nil
        }
    }

    // MARK: - Validation
    var canSaveRegistration: Bool {
        applicantName.trimmed.isEmpty == false
        && roleTitle.trimmed.isEmpty == false
        && confirmsAuthority
        && confirmsRights
        && confirmedAt != nil
        && (termsVersion?.trimmed.isEmpty == false)
        && (termsLocale?.trimmed.isEmpty == false)
        && (termsTextSnapshot?.isEmpty == false)
    }

    var canSubmitEvidence: Bool {
        switch selectedEvidenceMethod {
        case .officialEmail:
            return evidenceEmailHint.trimmed.isEmpty == false
            && evidenceEmailURL.trimmed.isEmpty == false

        case .codePost:
            return verificationCode.trimmed.isEmpty == false
            && evidenceChannelURL.trimmed.isEmpty == false
            && evidenceChannelDetail.trimmed.isEmpty == false
        }
    }

    // MARK: - Mapping
    var evidenceHelperText: String {
        switch selectedEvidenceMethod {
        case .officialEmail:
            return String(localized: "raf.evidenceHelper.officialEmail")
        case .codePost:
            return String(localized: "raf.evidenceHelper.codePost")
        }
    }
    
    func toApplicantProfile() -> ApplicantProfile {
        ApplicantProfile(
            applicantName: applicantName.trimmed,
            roleTitle: roleTitle.trimmed,
            contactEmail: contactEmail.trimmedOrNil,
            contactPhone: contactPhone.trimmedOrNil
        )
    }

    func toEvidenceItem() -> EvidenceItem {
        switch selectedEvidenceMethod {
        case .officialEmail:
            return EvidenceItem(
                method: .officialEmail,
                status: .submitted,
                submittedAt: .now,
                contactEmailHint: evidenceEmailHint.trimmedOrNil,
                contactEmailURL: evidenceEmailURL.trimmedOrNil
            )

        case .codePost:
            return EvidenceItem(
                method: .codePost,
                status: .submitted,
                submittedAt: .now,
                channelURL: evidenceChannelURL.trimmedOrNil,
                channelURLDetail: evidenceChannelDetail.trimmedOrNil,
                verificationCode: verificationCode.trimmed,
                codePostedAt: .now
            )
        }
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

private extension Optional where Wrapped == String {
    var trimmed: String {
        switch self {
        case .some(let s):
            return s.trimmingCharacters(in: .whitespacesAndNewlines)
        case .none:
            return ""
        }
    }
}
