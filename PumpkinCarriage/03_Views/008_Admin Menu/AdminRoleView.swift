import SwiftUI

struct AdminRoleView: View {
    @State private var viewModel: AdminRoleViewModel

    init(viewModel: AdminRoleViewModel = AdminRoleViewModel()) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 12) {
            header

            Picker("", selection: $viewModel.selectedTab) {
                ForEach(AdminRoleViewModel.Tab.allCases) { tab in
                    Text(tabTitle(tab)).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if viewModel.selectedTab == .pending {
                Picker("", selection: $viewModel.pendingEvidenceFilter) {
                    ForEach(AdminRoleViewModel.PendingEvidenceFilter.allCases) { f in
                        Text(f.title).tag(f)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 2)
            }


            content
        }
        .navigationTitle(String(localized: "arv.nav.title"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.readApplications()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "arv.button.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }

    }

    private var header: some View {
        HStack {
            Text(String(localized: "arv.header.subtitle"))
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.selectedTab {
        case .pending:
            applicationsList(viewModel.pendingApplications, emptyText: String(localized: "arv.empty.pending"))
        case .history:
            applicationsList(viewModel.historyApplications, emptyText: String(localized: "arv.empty.history"))
        }
    }

    private func applicationsList(_ list: [RoleApplication], emptyText: String) -> some View {
        Group {
            if list.isEmpty {
                VStack(spacing: 10) {
                    Text(emptyText)
                        .foregroundStyle(.secondary)
                    Text(String(localized: "arv.empty.hint"))
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal)
            } else {
                List {
                    ForEach(list) { app in
                        NavigationLink {
                            AdminRoleDetailView(applicationID: app.id)
                        } label: {
                            ApplicationRow(application: app)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private func tabTitle(_ tab: AdminRoleViewModel.Tab) -> String {
        switch tab {
        case .pending: return String(localized: "arv.tab.pending")
        case .history: return String(localized: "arv.tab.history")
        }
    }
}

// MARK: - Row
private struct ApplicationRow: View {
    let application: RoleApplication

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(application.brandName?.isEmpty == false ? application.brandName! : String(localized: "arv.row.noBrand"))
                    .font(.system(size: 16, weight: .semibold))

                Spacer()

                StatusPill(status: application.status)
            }

            Text(String(format: String(localized: "arv.row.applicant.format"), application.applicant.applicantName))
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            Text(String(format: String(localized: "arv.row.method.format"), application.evidence.first?.method.rawValue.capitalized ?? String(localized: "arv.row.method.unknown")))
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

private struct StatusPill: View {
    let status: RoleApplicationStatus

    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            Text(status.displayName)
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .overlay{
            RoundedRectangle(cornerRadius: 8)
                .fill(background)
        }
    }
    
    private var statusColor: Color {
        switch status {
        case .pending: return Color.yellow
        case .approved: return Color.green
        case .rejected: return Color.red
        case .archived: return Color.main
        case .initial: return Color.gray
        }
    }

    private var background: Color {
        switch status {
        case .pending: return Color.yellow.opacity(0.15)
        case .approved: return Color.green.opacity(0.15)
        case .rejected: return Color.red.opacity(0.10)
        case .archived: return Color.main.opacity(0.10)
        case .initial: return Color.gray.opacity(0.10)
        }
    }
}

#Preview {
    NavigationStack {
        AdminRoleView(viewModel: AdminRoleViewModel(preview: true))
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
