import SwiftUI
import MessageUI

struct VendorStatusView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: VendorStatusViewModel
    @State private var showMail: Bool = false
    
    let vendorSummary: VendorSummary
    
    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
        _viewModel = State(initialValue: VendorStatusViewModel(vendorSummary: vendorSummary))
    }

    // MARK: - Derived
    private var statusStyle: (text: String, color: Color, description: String) {
        switch viewModel.status {
        case .active:
            return (viewModel.status.displayName, .green, viewModel.status.uiDescription)
        case .pending:
            return (viewModel.status.displayName, .yellow, viewModel.status.uiDescription)
        case .rejected:
            return (viewModel.status.displayName, .red, viewModel.status.uiDescription)
        case .hidden:
            return (viewModel.status.displayName, .gray, viewModel.status.uiDescription)
        case .archived:
            return (viewModel.status.displayName, .main, viewModel.status.uiDescription)
        }
    }


    // MARK: - View
    var body: some View {
        VStack {
            Text(String(localized: "vsv.title.status"))
                .menuTitleStyle()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    headerCard

                    timelineCard

                    actionCard

                    if viewModel.isRejected {
                        rejectSummaryCard
                    }

                    if viewModel.isHidden || viewModel.isPending || viewModel.isRejected {
                        requirementsCard
                    }

                }
                .padding()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.08)
                        .ignoresSafeArea()
                    ProgressView()
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .transition(.opacity)
            }
        }
        .task(id: viewModel.vendorSummary.id) {
            guard viewModel.checkAccessPermission(user: sessionManager.currentUser) else {
                return
            }
            await viewModel.loadInitialState(
                vendorId: viewModel.vendorSummary.id,
                currentUserId: sessionManager.currentUser?.id
            )
        }
        .sheet(item: $viewModel.sheetContext) { ctx in
            StatusApplicationView(
                action: ctx.action,
                vendorId: viewModel.vendorSummary.id,
                vendorPublicId: viewModel.vendorSummary.publicId,
                vendorName: ctx.vendorName,
                vendorStatus: ctx.vendorStatus
            ) { result in
                switch result {
                case .submitted(let app):
                    viewModel.submitStatusRequest(app, action: ctx.action) { result in
                        switch result {
                        case .ok(let action, let target):
                            toastCenter.show(.init(message: viewModel.successMessage(action: action, target: target)))
                            if ctx.action == .requestToArchive {
                                dismiss()
                            }
                        case .duplicatePending:
                            break

                        case .vendorNotFound, .invalidAction:
                            break
                        }
                    }
                case .cancelled:
                    break
                }
                viewModel.sheetContext = nil
            }
        }
        .navigationDestination(isPresented: $viewModel.showEdit) {
            VendorUpdateView(vendorSummary: viewModel.vendorSummary)
        }
        .sheet(isPresented: $showMail, content: {
            MailView(
                subject: String(format: String(localized: "vsv.inquiry.subject.format"),vendorSummary.publicId),
                messageBody: String(localized: "vsv.inquiry.body"),
                recipients: ["contact@yourapp.com"]
            )
        })
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "vsv.button.ok")) {
                if viewModel.shouldDismissOnAlert {
                    viewModel.shouldDismissOnAlert = false
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showMessage) {
            Button(String(localized: "vsv.button.ok")) {
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    // MARK: - Sections
    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Circle()
                    .fill(statusStyle.color)
                    .frame(width: 12, height: 12)

                Text(statusStyle.text)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.main)

                Spacer()
            }

            Text(viewModel.vendorSummary.name)
                .primaryTextStyle()
                .foregroundStyle(.main)
            
            
            HStack{
                lineRow(title: String(localized: "vsv.header.vendorPublicId"), value: viewModel.vendorSummary.publicId)
                Button {
                    copyToClipboard(viewModel.vendorSummary.publicId)
                    toastCenter.show(.init(message: String(localized: "vsv.toast.copiedPublicId")))
                } label: {
                    Image(systemName: "document.on.document")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .tint(Color.main)
            }

            Divider()
            
            if !statusStyle.description.isEmpty {
                Text(statusStyle.description)
                    .captionTextStyle()
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
        )
    }

    private var timelineCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "vsv.section.timeline"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            lineRow(title: String(localized: "vsv.timeline.created"), value: viewModel.vendorSummary.createdAt.formatted(date: .abbreviated, time: .shortened))
            lineRow(title: String(localized: "vsv.timeline.updated"), value: viewModel.vendorSummary.updatedAt.formatted(date: .abbreviated, time: .shortened))
            if let submittedAt = viewModel.lastSubmissionAt,
               let label = viewModel.lastSubmissionDisplayText() {
                lineRow(
                    title: label,
                    value: submittedAt.formatted(date: .abbreviated, time: .shortened)
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }

    private func lineRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 72, alignment: .leading)

            Text(value)
                .font(.caption)
                .foregroundStyle(.main)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var actionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "vsv.section.actions"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            if viewModel.isPending {
                disabledActionRow(title: String(localized: "vsv.action.underReview"))
            }

            if viewModel.isHidden {
                primaryActionRow(title: String(localized: "vsv.action.applyActivation")) {
                    viewModel.presentStatusRequestSheet(.applyForActivation)
                }
            }

            if viewModel.isRejected {
                primaryActionRow(title: String(localized: "vsv.action.resubmitReview")) {
                    viewModel.presentStatusRequestSheet(.resubmitForReview)
                }
            }
            
            if viewModel.canEdit {
                primaryActionRow(title: String(localized: "vsv.action.edit")) {
                    viewModel.showEdit = true
                }
            }

            if viewModel.canRequestToHide {
                secondaryActionRow(title: String(localized: "vsv.action.requestHide")) {
                    viewModel.presentStatusRequestSheet(.requestToHide)
                }
            }
            
            if viewModel.canRequestToDelete {
                secondaryActionRow(title: String(localized: "vsv.action.requestDelete")) {
                    viewModel.presentStatusRequestSheet(.requestToArchive)
                }
            }
            
            secondaryActionRow(title: String(localized: "vsv.action.contactSupport")) {
                if MFMailComposeViewController.canSendMail() {
                    showMail = true
                } else {
                    viewModel.createMessage(title: String(localized: "pv.mail.unavailable.title"), message: String(localized: "pv.mail.unavailable.msg"))
                    showMail = false
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }

    private func primaryActionRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.main))
        }
        .buttonStyle(.plain)
    }

    private func secondaryActionRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(.main)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black.opacity(0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func disabledActionRow(title: String) -> some View {
        Text(title)
            .font(.system(size: 15, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(.secondary)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.black.opacity(0.04))
            )
    }

    private var rejectSummaryCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "vsv.reject.title"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            Text(String(localized: "vsv.reject.reason"))
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(String(localized: "vsv.reject.reasonBody"))
                .font(.caption)
                .foregroundStyle(.main)

            Text(String(localized: "vsv.reject.notes"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 6)

            Text(String(localized: "vsv.reject.notesBody"))
                .font(.caption)
                .foregroundStyle(.main)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.red.opacity(0.25), lineWidth: 1)
                )
        )
    }
        

    private var requirementsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "vsv.requirements.title"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            //requirementRow(String(localized: "vsv.requirements.image"))
            //requirementRow(String(localized: "vsv.requirements.contact"))
            requirementRow(String(localized: "vsv.requirements.description"))
            requirementRow(String(localized: "vsv.requirements.address"))
            requirementRow(String(localized: "vsv.requirements.terms"))
            requirementRow(String(localized: "vsv.requirements.registeredInformation"))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }

    private func requirementRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.caption)
                .foregroundStyle(.main)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}


#Preview {
    let session = SessionManager()
    session.currentUser = UserMockSeed.makeUsers()[2]
    session.sessionState = .signedIn
    session.authLevel = .authenticated

    let toast = ToastCenter()

    return NavigationStack {
        VendorStatusView(vendorSummary: VendorMockSeed.makeSummaries()[3])
            .toast()
    }
    .environment(session)
    .environment(toast)
}
