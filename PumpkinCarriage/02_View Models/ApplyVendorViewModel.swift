import Foundation

@Observable
final class ApplyVendorViewModel {

    private var roleAppWriteService: any RoleApplicationWriteService { Services.shared.roleAppWrite }

    private let userId: String

    var selectedTab: ApplyVendorTab = .registration

    // Source of truth (snapshot)
    var application: RoleApplication? = nil
    var applicationExists: Bool { application != nil }
    var primaryRegistrationButtonTitle: String {
        application == nil ? String(localized: "avm.primary.saveContinue") : String(localized: "avm.primary.updateContinue")
    }
    var statusTitle: String {
        application?.status.displayName ?? RoleApplicationStatus.initial.displayName
    }
    var statusSubtitle: String? {
        guard let status = application?.status else {
            return String(localized: "avm.statusSubtitle.beforeStart")
        }
        switch status {
        case .initial:
            return String(localized: "avm.statusSubtitle.initial")
        case .pending:
            return String(localized: "avm.statusSubtitle.pending")
        case .approved:
            return String(localized: "avm.statusSubtitle.approved")
        case .rejected:
            return String(localized: "avm.statusSubtitle.rejected")
        case .archived:
            return String(localized: "avm.statusSubtitle.archived")
        }
    }
    var rejectionSummary: String? {
        guard let app = application else { return nil }
        guard app.status == .rejected else { return nil }
        guard let decision = app.decision, decision.result == .rejected else { return nil }

        let categoryText: String? = decision.rejectionCategory.map { $0.rawValue.capitalized }
        let commentText: String? = decision.comment?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let categoryText, let commentText, commentText.isEmpty == false {
            return "[\(categoryText)] \(commentText)"
        }
        if let commentText, commentText.isEmpty == false {
            return commentText
        }
        if let categoryText {
            return categoryText
        }
        return String(localized: "avm.rejection.fallback")
    }
    var isPendingOrApproved: Bool {
        guard let status = application?.status else { return false }
        return status == .pending || status == .approved
    }

    

    // UI input container
    var form: RoleApplicationForm

    // UI alert
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""

    // Config
    private let termsVersion: Int = 1

    init(userId: String) {
        self.userId = userId

        let code = Self.makeVerificationCode()
        self.form = RoleApplicationForm()
        self.form.verificationCode = code
    }

    func load() {
        let fallback = form.verificationCode.isEmpty ? Self.makeVerificationCode() : form.verificationCode
        let (app, f) = roleAppWriteService.load(userId: userId, fallbackVerificationCode: fallback)
        self.application = app
        self.form = f
        self.selectedTab = .registration
    }

    func saveRegistrationAndContinue() {
        form.syncConfirmedAtIfNeeded()

        guard form.canSaveRegistration else {
            show(String(localized: "avm.error.requiredFields"))
            return
        }

        if let app = application, (app.status != .initial && app.status != .rejected) {
            show(String(localized: "avm.error.cannotEdit"))
            return
        }

        let updated = roleAppWriteService.saveRegistration(
            userId: userId,
            currentRole: .user,
            form: form,
            existing: application
        )
        self.application = updated
        self.selectedTab = .evidence
    }

    func submitEvidence() {
        guard let app = application else {
            show(String(localized: "avm.error.saveFirst"))
            selectedTab = .registration
            return
        }

        guard form.canSubmitEvidence else {
            show(String(localized: "avm.error.reviewEvidence"))
            return
        }

        let updated = roleAppWriteService.submitEvidence(
            userId: userId,
            form: form,
            existing: app
        )
        self.application = updated
        show(String(localized: "avm.success.evidenceSubmitted"))
    }

    var canSubmit: Bool {
        guard let app = application else { return true }
        let status = app.status
        return status != .pending || status != .approved || status != .archived
    }

    private func show(_ message: String, title: String = String(localized: "avm.alert.defaultTitle")) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    private nonisolated static func makeVerificationCode() -> String {
        let letters = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        return String((0..<8).compactMap { _ in letters.randomElement() })
    }
}
