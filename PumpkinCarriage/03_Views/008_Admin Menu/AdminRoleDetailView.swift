import Foundation
import SwiftUI

// MARK: - Detail
struct AdminRoleDetailView: View {
    
    let applicationID: String
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AdminRoleDetailViewModel
    
    init(applicationID: String) {
        self.applicationID = applicationID
        _viewModel = State(initialValue: AdminRoleDetailViewModel(applicationID: applicationID))
    }
    
    
    private var adminActor: AdminActor? {
        guard let uid = sessionManager.currentUser?.id else { return nil }
        let isAdmin = sessionManager.authLevel == .authenticated && sessionManager.sessionState == .signedIn && sessionManager.currentUser?.role == .admin
        return AdminActor(userId: uid, isAdmin: isAdmin)
    }
    
    var body: some View {
        if let app = viewModel.application(for: applicationID) {
            ScrollView {
                HStack {
                    Text(String(localized: "ardv.title.roleAppDetail"))
                        .menuTitleStyle()
                    
                    Spacer()
                }
                .padding(.horizontal, 15)

                VStack(alignment: .leading, spacing: 14) {
                    
                    GroupBox(String(localized: "ardv.section.status")) {
                        HStack(spacing: 12) {

                            // Strong color indicator
                            RoundedRectangle(cornerRadius: 6)
                                .fill(app.status.statusColor)
                                .frame(width: 6)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(app.status.displayName)
                                    .font(.system(size: 15, weight: .semibold))

                                Text(app.status.description)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }

                            Spacer(minLength: 0)
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    GroupBox(String(localized: "ardv.section.applicantDetail")) {
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                            line(String(localized: "ardv.field.name"), app.applicant.applicantName)
                            line(String(localized: "ardv.field.roleTitle"), app.applicant.roleTitle)
                            if let email = app.applicant.contactEmail, !email.isEmpty {
                                line(String(localized: "ardv.field.email"), email)
                            }
                            if let phone = app.applicant.contactPhone, !phone.isEmpty {
                                line(String(localized: "ardv.field.phone"), phone)
                            }
                            lineWithImage(String(localized: "ardv.field.authorityConfirmed"), app.confirmsAuthority)
                            lineWithImage(String(localized: "ardv.field.rightsConfirmed"), app.confirmsRights)
                        }
                    }
                    
                    GroupBox(String(localized: "ardv.section.businessDetail")) {
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                            if let brand = app.brandName, !brand.isEmpty {
                                line(String(localized: "ardv.field.brandName"), brand)
                            }
                            if let cat = app.brandCategory, !cat.isEmpty {
                                line(String(localized: "ardv.field.category"), cat)
                            }
                        }
                    }
                    
                    GroupBox(String(localized: "ardv.section.application")) {
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                            line(String(localized: "ardv.field.currentRole"), app.currentRole.rawValue)
                            line(String(localized: "ardv.field.requestedRole"), app.requestedRole.rawValue)
                            
                            if let msg = app.messageToAdmin, !msg.isEmpty {
                                Text(msg)
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top, 4)
                            }
                        }
                    }
                    
                    GroupBox(String(localized: "ardv.section.evidence")) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(app.evidence) { item in
                                EvidenceCard(item: item) {
                                    guard let actor = adminActor else {
                                        toastCenter.show(.init(message: String(localized: "ardv.toast.needLogin")))
                                        return
                                    }
                                    viewModel.setEvidenceStatus(evidenceID: item.id, newStatus: .verified, actor: actor)
                                }
                            }
                        }
                    }
                    .id(viewModel.refreshTick)
                    
                    GroupBox(String(localized: "ardv.section.terms")) {
                        VStack(alignment: .leading, spacing: 6) {
                            Spacer()
                            line(String(localized: "ardv.field.termsVersion"), String(app.termsVersion))
                            line(String(localized: "ardv.field.agreedAt"), app.confirmedAt.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                    
                    if let decision = app.decision {
                        GroupBox(String(localized: "ardv.section.decision")) {
                            Spacer()
                            VStack(alignment: .leading, spacing: 6) {
                                line(String(localized: "ardv.field.result"), decision.result.rawValue)
                                line(String(localized: "ardv.field.reviewer"), decision.reviewerUserId)
                                line(String(localized: "ardv.field.decidedAt"), decision.decidedAt.formatted(date: .abbreviated, time: .shortened))
                                if let cat = decision.rejectionCategory {
                                    line(String(localized: "ardv.field.rejectionCategory"), cat.rawValue)
                                }
                                if let comment = decision.comment, !comment.isEmpty {
                                    Text(comment)
                                        .font(.system(size: 14))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 4)
                                }
                            }
                        }
                    }
                    
                    GroupBox(String(localized: "ardv.section.log")) {
                        let events = viewModel.events

                        if events.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(String(localized: "ardv.log.empty.title"))
                                    .font(.system(size: 14, weight: .semibold))
                                Text(String(localized: "ardv.log.empty.msg"))
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6)
                        } else {
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    ForEach(events, id: \.id) { event in
                                        RoleApplicationEventRow(event: event)
                                        
                                        if event.id != events.last?.id {
                                            Divider().opacity(0.35)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxHeight: 200)
                        }
                    }
                    
                    actionsSection(app: app)
                }
                .padding(16)
            }
                .sheet(isPresented: $viewModel.showRejectSheet) {
                    RejectSheet(
                        templatesForCategory: { viewModel.templates(for: $0) },
                        
                        onCancel: {
                            viewModel.showRejectSheet = false
                            viewModel.rejectDraft.reset()
                        },
                        
                        onConfirm: { payload in
                            viewModel.showRejectSheet = false
                            viewModel.rejectDraft.category = payload.category
                            viewModel.rejectDraft.templateID = payload.templateID
                            viewModel.rejectDraft.detail = payload.detail
                            guard let actor = adminActor else {
                                toastCenter.show(.init(message: String(localized: "ardv.toast.needLogin")))
                                return
                            }
                            if viewModel.reject(actor: actor) {
                                dismiss()
                            }
                        }
                    )
                    .presentationDetents([.medium, .large])
                }
                .sheet(isPresented: $viewModel.showApproveSheet) {
                    ApproveSheet(
                        onCancel: {
                            viewModel.showApproveSheet = false
                        },
                        onConfirm: {
                            guard let actor = adminActor else {
                                toastCenter.show(.init(message: String(localized: "ardv.toast.needLogin")))
                                return
                            }
                            if viewModel.approve(actor: actor) {
                                dismiss()
                            }
                        }
                    )
                    .presentationDetents([.fraction(0.25)])
                }
                .alert(
                    viewModel.alertTitle,
                    isPresented: $viewModel.showAlert
                ) {
                    Button(String(localized: "ardv.button.confirm")) {
                    }
                } message: {
                    Text(viewModel.alertMessage)
                }
        } else {
            Text(String(localized: "ardv.text.appNotFound"))
                .foregroundStyle(.secondary)
                .padding()
        }
    }
        
    
    private func actionsSection(app: RoleApplication) -> some View {
        GroupBox(String(localized: "ardv.section.actions")) {
            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                
                if app.status == .pending || app.status == .initial {
                    HStack(spacing: 10) {
                        Button(role: .destructive) {
                            viewModel.openRejectSheet()
                        } label: {
                            Label(String(localized: "ardv.button.reject"), systemImage: "xmark.circle")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(12)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        
                        Button {
                            viewModel.showApproveSheet = true
                        } label: {
                            Label(String(localized: "ardv.button.approve"), systemImage: "checkmark.circle")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(12)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                } else {
                    Text(String(localized: "ardv.text.noActions"))
                        .captionTextStyle()
                }
            }
        }
    }
    
    private func line(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .frame(width: 140, alignment: .leading)
            Text(value)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func lineWithImage(_ title: String, _ value: Bool) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .frame(width: 140, alignment: .leading)
            Image(systemName: (value ? "checkmark" : "xmark"))
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(value ? .green : .red)
        }
    }

}

private struct EvidenceCard: View {
    
    @Environment(ToastCenter.self) var toastCenter
    
    let item: EvidenceItem
    let onConfirm: () -> Void
    
    @State private var showConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(item.method == .officialEmail ? String(localized: "ardv.evidence.method.officialEmail") : String(localized: "ardv.evidence.method.codePost"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(lineWidth: 1)
                            .foregroundStyle(.secondary)
                    }
                
                Spacer()
                HStack {
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundStyle(item.status.statusColor)
                    Text(item.status.rawValue.capitalized)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                    
                }
            }
            
            if let submittedAt = item.submittedAt {
                Text(String(format: String(localized: "ardv.evidence.submittedAt.format"), submittedAt.formatted(date: .abbreviated, time: .shortened)))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                    .padding(.leading, 10)
            }
            
            VStack(spacing: 10) {
                switch item.method {
                case .officialEmail:
                    if let hint = item.contactEmailHint, !hint.isEmpty {
                        lineClip(String(localized: "ardv.evidence.field.email"), hint)
                    }
                    if let url = item.contactEmailURL, !url.isEmpty {
                        lineClip(String(localized: "ardv.evidence.field.url"), url)
                    }
                    
                case .codePost:
                    if let url = item.channelURL, !url.isEmpty {
                        lineClip(String(localized: "ardv.evidence.field.url"), url)
                    }
                    if let code = item.verificationCode, !code.isEmpty {
                        lineClip(String(localized: "ardv.evidence.field.code"), code)
                    }
                }
                
                if let note = item.reviewNote, !note.isEmpty {
                    Text(note)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                if item.status == .submitted {
                    Button {
                        //onConfirm()
                        showConfirmation = true
                    } label: {
                        Text(String(localized: "ardv.evidence.button.verified"))
                            .primaryTextStyle()
                            .foregroundStyle(.white)
                            .frame(width: 200, height: 32)
                            .background(.main)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .padding(.top, 10)
                    
                }
            }
        }
        .alert(String(localized: "ardv.evidence.alert.verify.title"), isPresented: $showConfirmation) {
            Button(String(localized: "ardv.button.cancel")) {}
            Button(String(localized: "ardv.button.confirm")) {
                onConfirm()
            }
        } message: {
            Text(String(localized: "ardv.evidence.alert.verify.msg"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 1)
    }
    
    private func lineClip(_ title: String, _ value: String) -> some View {
        HStack {
            HStack{
                Text(title)
                    .captionTextStyle()
                    .frame(width: 60)
                Text(value)
                    .font(.system(size: 12, design: .monospaced))
            }
            Spacer()
            Button {
                copyToClipboard(value)
                toastCenter.show(.init(message: String(localized: "ardv.toast.copied")))
            } label: {
                Image(systemName: "document.on.document")
                    .secondaryTextStyle()
            }
            .tint(.main)
        }
    }
    
}

private struct RoleApplicationEventRow: View {

    let event: RoleApplicationEvent

    var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(eventTypeText(event.type))
                        .font(.system(size: 14, weight: .semibold))
                    
                    Spacer()
                    
                    Text(event.occurredAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                if let prev = event.prevStatus?.displayName, let next = event.newStatus?.displayName {
                    Text(verbatim: "\(String(describing: prev)) → \(String(describing: next))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                } else if let next = event.newStatus {
                    Text(String(describing: next))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
                
                Text(verbatim: "\(String(describing: event.actorRole)) · \(event.actorUserId)")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                
                payloadSummary(event.payload)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 2)
    }

    private func eventTypeText(_ type: RoleApplicationEventType) -> String {
        switch type {
        case .applicationCreated:
            return String(localized: "ardv.log.type.applicationCreated")
        case .registrationSaved:
            return String(localized: "ardv.log.type.registrationSaved")
        case .evidenceSubmitted:
            return String(localized: "ardv.log.type.evidenceSubmitted")
        case .resubmissionStarted:
            return String(localized: "ardv.log.type.resubmissionStarted")
        case .decisionMade:
            return String(localized: "ardv.log.type.decisionMade")
        case .statusChanged:
            return String(localized: "ardv.log.type.statusChanged")
        case .termsUpdated: return String(localized: "ardv.log.type.termsUpdated")
        }
    }

    @ViewBuilder
    private func payloadSummary(_ payload: RoleApplicationEventPayload) -> some View {
        switch payload.kind {

        case .registration:
            if let r = payload.registration {
                VStack(alignment: .leading, spacing: 2) {
                    if let brandName = r.brandName, brandName.isEmpty == false {
                        Text(String(format: String(localized: "ardv.log.payload.brand.format"), brandName))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }

                    let changed = r.changedFields
                    if changed.isEmpty == false {
                        Text(
                            String(
                                format: String(localized: "ardv.log.payload.changedFields.format"),
                                changed.joined(separator: ", ")
                            )
                        )
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    }
                }
            } else {
                EmptyView()
            }

        case .evidence:
            if let e = payload.evidence {
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: String(localized: "ardv.log.payload.evidence.id.format"), e.evidenceId))
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)

                    Text(String(format: String(localized: "ardv.log.payload.evidence.method.format"),
                                String(describing: e.method)))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    if let url = e.channelURL, url.isEmpty == false {
                        Text(String(format: String(localized: "ardv.log.payload.evidence.url.format"), url))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    if let code = e.verificationCode, code.isEmpty == false {
                        Text(String(format: String(localized: "ardv.log.payload.evidence.code.format"), code))
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }

                    if let submittedAt = e.submittedAt {
                        Text(
                            String(
                                format: String(localized: "ardv.log.payload.evidence.submittedAt.format"),
                                submittedAt.formatted(date: .abbreviated, time: .shortened)
                            )
                        )
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    }
                }
            } else {
                EmptyView()
            }

        case .resubmission:
            if let r = payload.resubmission {
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: "\(r.previousStatus) → \(r.newStatus)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    if r.resetEvidence {
                        Text(String(localized: "ardv.log.payload.resubmission.resetEvidence"))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    if r.resetDecision {
                        Text(String(localized: "ardv.log.payload.resubmission.resetDecision"))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                    if r.regeneratedVerificationCode {
                        Text(String(localized: "ardv.log.payload.resubmission.regeneratedCode"))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                EmptyView()
            }

        case .decision:
            if let d = payload.decision {
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: String(localized: "ardv.log.payload.decision.result.format"),
                                String(describing: d.result)))
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    if let cat = d.rejectionCategory {
                        Text(String(format: String(localized: "ardv.log.payload.decision.category.format"),
                                    String(describing: cat)))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }

                    if let comment = d.comment, comment.isEmpty == false {
                        Text(String(format: String(localized: "ardv.log.payload.decision.comment.format"), comment))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                EmptyView()
            }

        case .statusChange:
            if let s = payload.statusChange {
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: "\(s.from) → \(s.to)")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    if let reason = s.reason, reason.isEmpty == false {
                        Text(String(format: String(localized: "ardv.log.payload.statusChange.reason.format"), reason))
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                EmptyView()
            }
        case .termsUpdated:
            EmptyView()
        }
    }
}


// MARK: - Reject Sheet
struct RejectSheet: View {
    
    struct Payload {
        let category: RoleApplicationRejectionCategory
        let templateID: String
        let detail: String
        let composedComment: String
    }
    
    typealias RejectionTemplate = AdminRoleDetailViewModel.RejectionTemplate
    let templatesForCategory: (RoleApplicationRejectionCategory) -> [RejectionTemplate]
    
    let onCancel: () -> Void
    let onConfirm: (Payload) -> Void
    
    @State private var category: RoleApplicationRejectionCategory =
    RoleApplicationRejectionCategory.allCases.first ?? .identity
    @State private var templateID: String = ""
    @State private var detail: String = ""
    var selected: RejectionTemplate? {
        templatesForCategory(category).first(where: { $0.id == templateID })
    }
    private let labelWidth: CGFloat = 80
    private let fieldWidth: CGFloat = 240
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 14) {
                HStack{
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .menuTitleStyle()
                        .foregroundStyle(.red)
                    Text(String(localized: "ardv.reject.title"))
                        .menuTitleStyle()
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.top, 15)
                
                ScrollView {
                    // 1) Category
                    GroupBox {
                        VStack(spacing: 12) {

                            // Category row
                            HStack(spacing: 12) {
                                Text(String(localized: "ardv.reject.field.category"))
                                    .primaryTextStyle()
                                    .frame(width: labelWidth, alignment: .leading)

                                Rectangle()
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(width: 1)
                                    .padding(.vertical, 6)

                                Picker("", selection: $category) {
                                    ForEach(RoleApplicationRejectionCategory.allCases) { cat in
                                        Text(cat.rawValue.capitalized).tag(cat)
                                    }
                                }
                                .labelsHidden()
                                .tint(.main)
                                .frame(width: fieldWidth, alignment: .leading)
                                .onChange(of: category) { _, _ in
                                    templateID = ""
                                    detail = ""
                                }

                                Spacer(minLength: 0)
                            }

                            // Template row
                            HStack(spacing: 12) {
                                Text(String(localized: "ardv.reject.field.template"))
                                    .primaryTextStyle()
                                    .frame(width: labelWidth, alignment: .leading)

                                Rectangle()
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(width: 1)
                                    .padding(.vertical, 6)

                                Group {
                                    if templatesForCategory(category).isEmpty {
                                        Text(String(localized: "ardv.reject.text.noTemplates"))
                                            .font(.system(size: 13))
                                            .foregroundStyle(.secondary)
                                            .frame(width: fieldWidth, alignment: .leading)
                                    } else {
                                        Picker("", selection: $templateID) {
                                            ForEach(templatesForCategory(category)) { t in
                                                Text(t.title).tag(t.id)
                                            }
                                        }
                                        .labelsHidden()
                                        .tint(.main)
                                        .frame(width: fieldWidth, alignment: .leading)
                                    }
                                }

                                Spacer(minLength: 0)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    
                    // 3) Preview + Detail
                    GroupBox(String(localized: "ardv.reject.section.preview")) {
                        VStack(alignment: .leading, spacing: 10) {
                            commentBubble(text: composedComment(selectedTemplateText: selected?.text))
                            
                            if selected?.requiresDetail == true {
                                TextField(String(localized: "ardv.reject.placeholder.detailOptional"), text: $detail, axis: .vertical)
                                    .lineLimit(4, reservesSpace: true)
                            }
                        }
                    }

                }
                HStack {
                    Button {
                        onCancel()
                    } label: {
                        Text(String(localized: "ardv.button.cancel"))
                            .primaryTextStyle()
                            .foregroundStyle(.main)
                    }
                    .tint(.main)
                    .frame(maxWidth: .infinity)

                    Spacer()
                    Button {
                        guard !templateID.isEmpty else { return }
                        let selected = templatesForCategory(category).first(where: { $0.id == templateID })
                        let composed = composedComment(selectedTemplateText: selected?.text)
                        
                        onConfirm(
                            Payload(
                                category: category,
                                templateID: templateID,
                                detail: detail,
                                composedComment: composed
                            )
                        )
                    } label: {
                        Text(String(localized: "ardv.button.reject"))
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(templateID.isEmpty)
                }
                .padding(.horizontal, 15)
            }
            .padding(.horizontal, 15)
        }
    }
    
    private func composedComment(selectedTemplateText: String?) -> String {
        let base = selectedTemplateText ?? String(localized: "ardv.reject.text.selectTemplateHint")
        let t = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? base : "\(base) \(t)"
    }
    
    private func templateRow(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 16, weight: .semibold))
                Text(title).font(.system(size: 14))
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
    
    private func commentBubble(text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color.gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func line(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


private struct ApproveSheet: View {

    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack{
                Image(systemName: "checkmark.circle.fill")
                    .menuTitleStyle()
                    .foregroundStyle(.green)
                Text(String(localized: "ardv.approve.title"))
                    .menuTitleStyle()
            }
            Spacer()
            
            HStack {
                Button {
                    onCancel()
                } label: {
                    Text(String(localized: "ardv.button.cancel"))
                        .primaryTextStyle()
                        .foregroundStyle(.main)
                }
                .frame(maxWidth: .infinity)

                Spacer()

                Button {
                    onConfirm()
                } label: {
                    Text(String(localized: "ardv.button.approve"))
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(.horizontal, 25)
        .padding(.top, 25)
    }
}


extension EvidenceReviewStatus {
    var statusColor: Color {
        switch self {
        case .initial: return .gray
        case .submitted: return .yellow
        case .verified: return .green
        case .rejected: return .red
        }
    }
}

extension RoleApplicationStatus {
    var statusColor: Color {
        switch self {
        case .initial: return .gray
        case .approved: return .green
        case .rejected: return .red
        case .pending: return .yellow
        case .archived: return .main
        }
    }
    
}


#Preview {
    NavigationStack {
        AdminRoleDetailView(applicationID: RoleApplicationMockSeed.makeRoleApplications()[1].id)
            .toast()
    }
    .environment(PreviewData.session)
    .environment(ToastCenter())
}

private enum PreviewData {
    static let session: SessionManager = {
        let session = SessionManager()
        session.currentUser = UserMockSeed.makeUsers()[1]
        session.sessionState = .signedIn
        session.authLevel = .authenticated
        return session
    }()
}

