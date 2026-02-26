import SwiftUI

struct AdminStatusDetailView: View {
    
    let application: VendorStatusApplication
    let onDidUpdate: (@MainActor @Sendable () -> Void)?
    
    @State private var viewModel: AdminStatusDetailViewModel
    @State private var app: VendorStatusApplication
    @State private var vendorState: VendorSummary

    init(
        application: VendorStatusApplication,
        vendorSummary: VendorSummary,
        onDidUpdate: (@MainActor @Sendable () -> Void)? = nil
    ) {
        self.application = application
        self.onDidUpdate = onDidUpdate
        _viewModel = State(wrappedValue: AdminStatusDetailViewModel(vendorSummary: vendorSummary))
        _app = State(initialValue: application)
        _vendorState = State(initialValue: vendorSummary)
    }
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    @Environment(\.dismiss) private var dismiss

    
    @State private var showApprove = false
    @State private var showReject = false
    @State private var showDetail = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(String(localized: "asdv.title.applicationDetail"))
                    .font(.system(size: 20, weight: .bold))
                
                GroupBox {
                    VStack(alignment: .leading, spacing: 10) {
                        row(title: String(localized: "asdv.field.request"), value: app.requestType.displayName)
                        statusRow(title: String(localized: "asdv.field.decision"), value: app.decision)
                        
                        HStack {
                            row(title: String(localized: "asdv.field.vendorId"), value: app.vendorId)
                            Button {
                                copyToClipboard(app.vendorId)
                                toastCenter.show(.init(message: String(localized: "asdv.toast.copiedVendorId")))
                            } label: {
                                Image(systemName: "document.on.document")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .tint(Color.main)
                        }
                        HStack {
                            row(title: String(localized: "asdv.field.vendorPublicId"), value: app.vendorPublicId)
                            Button {
                                copyToClipboard(app.vendorId)
                                toastCenter.show(.init(message: String(localized: "asdv.toast.copiedVendorPublicId")))
                            } label: {
                                Image(systemName: "document.on.document")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .tint(Color.main)
                        }
                        
                        HStack {
                            row(title: String(localized: "asdv.field.applicantUserId"), value: app.applicantUserId)
                            Button {
                                copyToClipboard(app.applicantUserId)
                                toastCenter.show(.init(message: String(localized: "asdv.toast.copiedUserId")))
                            } label: {
                                Image(systemName: "document.on.document")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .tint(Color.main)
                        }
                        row(title: String(localized: "asdv.field.termsVersion"), value: String(app.termsVersion))
                        row(title: String(localized: "asdv.field.agreedAt"), value: formatDate(app.agreedAt))
                        row(title: String(localized: "asdv.field.created"), value: formatDate(app.createdAt))
                        row(title: String(localized: "asdv.field.updated"), value: formatDate(app.updatedAt))
                    }
                }
                
                if let message = app.message, !message.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "text.bubble")
                            Text(String(localized: "asdv.section.commentFromVendor"))
                        }
                        .captionTextStyle()
                        Divider()

                        Text(message)
                            .primaryTextStyle()
                            .padding(5)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                            
                    )

                }
                GroupBox() {
                    Button {
                        showDetail = true
                    } label: {
                        Text(String(localized: "asdv.button.showReviewScreen"))
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                
                GroupBox(String(localized: "asdv.section.log")) {
                    if viewModel.events.isEmpty {
                        Text(String(localized: "asdv.log.empty"))
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(viewModel.events, id: \.id) { e in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack(alignment: .firstTextBaseline) {
                                            Text(e.type.displayName)
                                                .font(.system(size: 14, weight: .semibold))
                                            
                                            Spacer()
                                            
                                            Text(e.occurredAt, style: .relative)
                                                .font(.system(size: 12))
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Text(String(format: String(localized: "asdv.log.actor.format"), e.actorUserId))
                                            .font(.system(size: 12))
                                            .foregroundStyle(.secondary)
                                        
                                        if let message = e.message, !message.isEmpty {
                                            Text(message)
                                                .font(.system(size: 12))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(3)
                                        }
                                        
                                        if let rejectionReason = e.rejectionReason, !rejectionReason.isEmpty {
                                            Text(String(format: String(localized: "asdv.log.rejection.format"), rejectionReason))
                                                .font(.system(size: 12))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(3)
                                        }
                                    }
                                    
                                    if e.id != viewModel.events.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxHeight: 200)
                    }
                }
                
                GroupBox(String(localized: "asdv.section.actions")) {
                    if app.decision != .pending {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.seal")
                            Text(String(format: String(localized: "asdv.text.alreadyDecided.format"), app.decision.displayName.lowercased()))
                        }
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        HStack(spacing: 10) {
                            Button(role: .destructive) {
                                showReject = true
                            } label: {
                                Label(String(localized: "asdv.button.reject"), systemImage: "xmark.circle")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(12)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            
                            Button {
                                showApprove = true
                            } label: {
                                Label(String(localized: "asdv.button.approve"), systemImage: "checkmark.circle")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(12)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .task(id: application.vendorId) {
            await viewModel.loadInitialState(
                applicationId: application.id,
                vendorId: application.vendorId,
                currentUserId: sessionManager.currentUser?.id
            )
        }
        .onAppear {
            guard let _ = viewModel.checkAccessPermission(user: sessionManager.currentUser) else {
                viewModel.shouldDismissOnAlert = true
                return
            }

            guard !viewModel.vendorSummary.id.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                viewModel.createAlert(
                    title: String(localized: "asdv.alert.invalidPath.title"),
                    message: String(localized: "asdv.alert.invalidPath.msg")
                )
                viewModel.shouldDismissOnAlert = true
                return
            }
        }
        .navigationTitle(String(localized: "asdv.nav.title"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showDetail) {
            VendorDetailSample(vendorSummary: viewModel.vendorSummary, vendorDetail: viewModel.vendorDetail ?? .placeholder, profileImages: viewModel.vendorProfileImage?.images ?? [])
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "asdv.button.ok")) {
                if viewModel.shouldDismissOnAlert {
                    viewModel.shouldDismissOnAlert = false
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $showApprove) {
            ApproveDecisionSheet(
                requestType: app.requestType,
                onCancel: {
                    showApprove = false
                },
                onConfirm: {
                    showApprove = false
                                        
                    guard let adminUser = viewModel.checkAccessPermission(user: sessionManager.currentUser) else { return }
                    
                    Task {
                        do {
                            let result = try await viewModel.approve(
                                application: app,
                                vendor: viewModel.vendorSummary,
                                adminUser: adminUser
                            )
                            app = result.updatedApplication
                            await MainActor.run {
                                onDidUpdate?()
                                dismiss()
                            }
                        } catch {
                            viewModel.createAlert(
                                title: String(localized: "asdv.alert.error.title"),
                                message: String(localized: "asdv.alert.approveFailed.msg"),
                                error: error
                            )
                        }
                    }
                }
            )
            .presentationDetents([.fraction(0.25)])
        }
        .sheet(isPresented: $showReject) {
            RejectDecisionSheet(
                requestType: app.requestType,
                initialReason: viewModel.defaultRejectionReason(for: app.requestType),
                onCancel: {
                    showReject = false
                },
                onConfirm: { note in
                    showReject = false
                    guard let adminUser = viewModel.checkAccessPermission(user: sessionManager.currentUser) else { return }

                    let finalReason = viewModel.composeRejectionReason(note: note)

                    Task {
                        do {
                            let result = try await viewModel.reject(
                                application: app,
                                vendor: viewModel.vendorSummary,
                                adminUser: adminUser,
                                rejectionReason: finalReason
                            )
                            app = result.updatedApplication
                            await MainActor.run {
                                onDidUpdate?()
                                dismiss()
                            }
                        } catch {
                            viewModel.createAlert(
                                title: String(localized: "asdv.alert.error.title"),
                                message: String(localized: "asdv.alert.rejectFailed.msg"),
                                error: error
                            )
                        }
                    }
                }
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    private func row(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func statusRow(title: String, value: VendorStatusDecision) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            Circle()
                .frame(width: 8, height: 8)
                .foregroundStyle(app.decision.statusColor)
            Text(value.displayName)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct VendorDetailSample: View {
    let vendorSummary: VendorSummary
    let vendorDetail: VendorDetail
    let profileImages: [VendorImage]
    
    func buttonOne() -> some View {
        Button {} label: {
            Image(systemName: "square.and.arrow.up")
                .primaryTextStyle()
                .tint(.main)
        }
    }
    func buttonTwo() -> some View {
        Button {} label: {
            Image(systemName: "bookmark")
                .primaryTextStyle()
                .tint(.main)
        }
    }
    
    var body: some View {
        ScrollView {
            VendorDetailComponentView(vendorSummary: vendorSummary, vendorDetails: vendorDetail, vendorProfileImages: profileImages, onExternalLinkTap: {_ in }, buttonOne: buttonOne, buttonTwo: buttonTwo)
        }
    }
}


private struct RejectDecisionSheet: View {

    let requestType: VendorStatusRequestType
    @State private var selectedCategory: RejectionCategory
    @State private var selectedTemplate: RejectionTemplate
    @State private var note: String = ""

    let onCancel: () -> Void
    let onConfirm: (String) -> Void

    init(
        requestType: VendorStatusRequestType,
        initialReason: RejectionTemplate,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping (String) -> Void
    ) {
        self.requestType = requestType
        _selectedTemplate = State(initialValue: initialReason)
        _selectedCategory = State(initialValue: initialReason.category)
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    var filteredTemplates: [RejectionTemplate] {
        RejectionTemplate.allCases.filter { $0.category == selectedCategory }
    }

    private let labelWidth: CGFloat = 80
    private let fieldWidth: CGFloat = 240

    private func composedComment() -> String {
        let base = selectedTemplate.preview
        let t = note.trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? base : "\(base) \(t)"
    }

    private func commentBubble(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color.gray.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 14) {

                // Header
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .menuTitleStyle()
                        .foregroundStyle(.red)
                    Text(String(format: String(localized: "asdv.reject.title.format"), requestType.displayName))
                        .menuTitleStyle()
                    Spacer()
                }
                .padding(.top, 15)

                ScrollView {
                    // Category + Template
                    GroupBox {
                        VStack(spacing: 12) {

                            // Category row
                            HStack(spacing: 12) {
                                Text(String(localized: "asdv.reject.field.category"))
                                    .primaryTextStyle()
                                    .frame(width: labelWidth, alignment: .leading)

                                Rectangle()
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(width: 1)
                                    .padding(.vertical, 6)

                                Picker("", selection: $selectedCategory) {
                                    ForEach(RejectionCategory.allCases, id: \.self) { category in
                                        Text(category.displayName).tag(category)
                                    }
                                }
                                .labelsHidden()
                                .tint(.main)
                                .frame(width: fieldWidth, alignment: .leading)
                                .onChange(of: selectedCategory) { _, newValue in
                                    // Ensure template stays in sync with category
                                    if let first = RejectionTemplate.allCases.first(where: { $0.category == newValue }) {
                                        selectedTemplate = first
                                    }
                                    note = ""
                                }

                                Spacer(minLength: 0)
                            }

                            // Template row
                            HStack(spacing: 12) {
                                Text(String(localized: "asdv.reject.field.template"))
                                    .primaryTextStyle()
                                    .frame(width: labelWidth, alignment: .leading)

                                Rectangle()
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(width: 1)
                                    .padding(.vertical, 6)

                                Picker("", selection: $selectedTemplate) {
                                    ForEach(filteredTemplates) { template in
                                        Text(template.displayName).tag(template)
                                    }
                                }
                                .labelsHidden()
                                .tint(.main)
                                .frame(width: fieldWidth, alignment: .leading)
                                .onChange(of: selectedTemplate) { _, _ in
                                    note = ""
                                }

                                Spacer(minLength: 0)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Preview + Detail
                    GroupBox(String(localized: "asdv.reject.section.preview")) {
                        VStack(alignment: .leading, spacing: 10) {
                            commentBubble(composedComment())

                            TextField(String(localized: "asdv.reject.placeholder.detailOptional"), text: $note, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)

                            Text(String(localized: "asdv.reject.hint.appended"))
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            

                // Actions
                HStack {
                    Button {
                        onCancel()
                    } label: {
                        Text(String(localized: "asdv.button.cancel"))
                            .primaryTextStyle()
                            .foregroundStyle(.main)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer(minLength: 12)

                    Button {
                        onConfirm(composedComment())
                    } label: {
                        Text(String(localized: "asdv.button.reject"))
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 10)
        }
        .animation(.default, value: selectedCategory)
    }
}

private struct ApproveDecisionSheet: View {

    let requestType: VendorStatusRequestType
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack{
                Image(systemName: "checkmark.circle.fill")
                    .menuTitleStyle()
                    .foregroundStyle(.green)
                Text(String(format: String(localized: "asdv.approve.title.format"), requestType.displayName))
                    .menuTitleStyle()
            }
            Spacer()
            
            HStack {
                Button {
                    onCancel()
                } label: {
                    Text(String(localized: "asdv.button.cancel"))
                        .primaryTextStyle()
                        .foregroundStyle(.main)
                }
                .frame(maxWidth: .infinity)

                Spacer()

                Button {
                    onConfirm()
                } label: {
                    Text(String(localized: "asdv.button.approve"))
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(.horizontal, 25)
        .padding(.top, 25)
    }
}

extension VendorStatusDecision {
    var statusColor: Color{
        switch self {
        case .approved: return .green
        case .rejected: return .red
        case .pending: return .yellow
        }
    }
}

//Reject Sheet Preview
//#Preview{
//    RejectDecisionSheet(requestType: .requestActive, initialReason: .duplicateListing, onCancel: {}, onConfirm: {_ in })
//}

//Detail Sheet Preview
#Preview {
    NavigationStack {
        AdminStatusDetailView(
            application:
                VendorStatusApplicationMockSeed.makeStatusApplications()[0],
            vendorSummary: VendorMockSeed.makeSummaries()[0]
        )
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
