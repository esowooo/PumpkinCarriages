import Foundation

@Observable
final class AdminRoleDetailViewModel {

    private var roleApplicationRepository: any RoleApplicationRepository { Repositories.shared.roleApplication }
    private var roleAppWriteService: any RoleApplicationWriteService { Services.shared.roleAppWrite }

    
    // MARK: - Init / Identity
    init(applicationID: String) {
        self.applicationID = applicationID
    }

    var applicationID: String

    // MARK: - UI State
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""

    var showRejectSheet: Bool = false
    var showApproveSheet: Bool = false

    var refreshTick: Int = 0

    // MARK: - Reject Draft
    struct RejectDraft: Hashable {
        var category: RoleApplicationRejectionCategory = .ownership
        var templateID: String = ""
        var detail: String = ""

        mutating func reset() {
            category = .ownership
            templateID = ""
            detail = ""
        }
    }

    var rejectDraft: RejectDraft = .init()

    // MARK: - Rejection Templates
    struct RejectionTemplate: Identifiable, Hashable {
        let id: String
        let title: String
        let text: String
        let requiresDetail: Bool

        init(id: String, title: String, text: String, requiresDetail: Bool = true) {
            self.id = id
            self.title = title
            self.text = text
            self.requiresDetail = requiresDetail
        }
    }

    private let rejectionTemplates: [RoleApplicationRejectionCategory: [RejectionTemplate]] = [
        .ownership: [
            .init(
                id: "ownership_authority",
                title: String(localized: "ardvm.tpl.ownershipAuthority.title"),
                text: String(localized: "ardvm.tpl.ownershipAuthority.text")
            ),
            .init(
                id: "ownership_channel",
                title: String(localized: "ardvm.tpl.ownershipChannel.title"),
                text: String(localized: "ardvm.tpl.ownershipChannel.text")
            )
        ],
        .identity: [
            .init(
                id: "identity_unclear",
                title: String(localized: "ardvm.tpl.identityUnclear.title"),
                text: String(localized: "ardvm.tpl.identityUnclear.text")
            )
        ],
        .policy: [
            .init(
                id: "policy_issue",
                title: String(localized: "ardvm.tpl.policyIssue.title"),
                text: String(localized: "ardvm.tpl.policyIssue.text")
            )
        ],
        .other: [
            .init(
                id: "other_generic",
                title: String(localized: "ardvm.tpl.other.title"),
                text: String(localized: "ardvm.tpl.other.text")
            )
        ]
    ]

    func templates(for category: RoleApplicationRejectionCategory) -> [RejectionTemplate] {
        rejectionTemplates[category] ?? []
    }

    // MARK: - Lookup
    func application(for id: String) -> RoleApplication? {
        roleApplicationRepository.application(by: id)
    }

    var events: [RoleApplicationEvent] {
        roleApplicationRepository.events(for: applicationID)
    }

    // MARK: - Sheet openers
    func openRejectSheet() {
        rejectDraft.reset()
        showRejectSheet = true
    }

    func openApproveSheet() {
        showApproveSheet = true
    }

    // MARK: - Admin Actions
    func approve(actor: AdminActor) -> Bool {
        guard requireAdmin(actor) else { return false }

        do {
            _ = try roleAppWriteService.approve(applicationId: applicationID, actor: actor)
            showApproveSheet = false
            refreshTick += 1
            return true
        } catch {
            let mapped = mapAdminError(error)
            createAlert(title: mapped.title, message: mapped.message)
            return false
        }
    }

    func reject(actor: AdminActor) -> Bool {
        guard requireAdmin(actor) else { return false }

        let templates = templates(for: rejectDraft.category)
        guard !rejectDraft.templateID.isEmpty,
              let selected = templates.first(where: { $0.id == rejectDraft.templateID }) else {
            createAlert(
                title: String(localized: "ardvm.alert.missingTemplate.title"),
                message: String(localized: "ardvm.alert.missingTemplate.msg")
            )
            return false
        }

        let detailTrim = rejectDraft.detail.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalComment = detailTrim.isEmpty ? selected.text : "\(selected.text) \(detailTrim)"

        do {
            _ = try roleAppWriteService.reject(
                applicationId: applicationID,
                actor: actor,
                rejectionCategory: rejectDraft.category,
                comment: finalComment
            )
            showRejectSheet = false
            rejectDraft.reset()
            refreshTick += 1
            return true
        } catch {
            let mapped = mapAdminError(error)
            createAlert(title: mapped.title, message: mapped.message)
            return false
        }
    }

    func setEvidenceStatus(
        evidenceID: String,
        newStatus: EvidenceReviewStatus,
        actor: AdminActor,
        note: String? = nil
    ) {
        guard requireAdmin(actor) else { return }

        do {
            _ = try roleAppWriteService.setEvidenceStatus(
                applicationId: applicationID,
                evidenceID: evidenceID,
                newStatus: newStatus,
                actor: actor,
                note: note
            )
            refreshTick += 1
        } catch {
            let mapped = mapAdminError(error)
            createAlert(title: mapped.title, message: mapped.message)
        }
    }

    // MARK: - Alert / Permission
    private func createAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    private func requireAdmin(_ actor: AdminActor) -> Bool {
        guard actor.isAdmin else {
            createAlert(
                title: String(localized: "ardvm.alert.notAllowed.title"),
                message: String(localized: "ardvm.alert.adminPermissionRequired.msg")
            )
            return false
        }
        guard !actor.userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            createAlert(
                title: String(localized: "ardvm.alert.invalidSession.title"),
                message: String(localized: "ardvm.alert.invalidSession.msg")
            )
            return false
        }
        return true
    }

}

struct AdminActor: Equatable {
    let userId: String
    let isAdmin: Bool
}


private func mapAdminError(_ error: Error) -> (title: String, message: String) {
    guard let e = error as? RoleApplicationAdminError else {
        return (
            String(localized: "ardvm.alert.unknownError.title"),
            String(localized: "ardvm.alert.unknownError.msg")
        )
    }

    switch e {
    case .notAdmin:
        return (
            String(localized: "ardvm.alert.adminPermissionRequired.title"),
            String(localized: "ardvm.alert.adminPermissionRequired.msg")
        )

    case .invalidSession:
        return (
            String(localized: "ardvm.alert.invalidSession.title"),
            String(localized: "ardvm.alert.invalidSession.msg")
        )

    case .applicationNotFound:
        return (
            String(localized: "ardvm.alert.appNotFound.title"),
            String(localized: "ardvm.alert.appNotFound.msg")
        )

    case .statusNotActionable:
        return (
            String(localized: "ardvm.alert.notAllowed.statusNotActionable.title"),
            String(localized: "ardvm.alert.notAllowed.notActionable.msg")
        )

    case .missingConfirmations:
        return (
            String(localized: "ardvm.alert.missingConfirmations.title"),
            String(localized: "ardvm.alert.missingConfirmations.msg")
        )

    case .missingEvidence:
        return (
            String(localized: "ardvm.alert.missingEvidence.title"),
            String(localized: "ardvm.alert.missingEvidence.msg")
        )

    case .evidenceNotVerified:
        return (
            String(localized: "ardvm.alert.evidenceNotVerified.title"),
            String(localized: "ardvm.alert.evidenceNotVerified.msg")
        )

    case .evidenceNotFound:
        return (
            String(localized: "ardvm.alert.evidenceNotFound.title"),
            String(localized: "ardvm.alert.evidenceNotFound.msg")
        )

    case .roleUpdateFailed:
        return (
            String(localized: "ardvm.alert.approvedButRoleUpdateFailed.title"),
            String(localized: "ardvm.alert.approvedButRoleUpdateFailed.msg")
        )
    }
}
