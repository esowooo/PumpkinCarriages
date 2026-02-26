import SwiftUI


extension VendorStatusDecision {
    var tint: Color {
        switch self {
        case .pending: return .orange
        case .approved: return .green
        case .rejected: return .red
            //case .cancelled: return .gray
        }
    }
}


struct AdminStatusView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = AdminStatusViewModel()
    @State private var refreshToken = UUID()

    // MARK: - Types
    private enum Tab: String, CaseIterable, Identifiable {
        case pending
        case history

        var id: String { rawValue }

        var title: String {
            switch self {
            case .pending: return String(localized: "asv.tab.pending")
            case .history: return String(localized: "asv.tab.history")
            }
        }
    }
    
    
    // MARK: - UI State
    @State private var tab: Tab = .pending
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 12) {
            header
            
            Picker("", selection: $tab) {
                ForEach(Tab.allCases) { t in
                    Text(t.title).tag(t)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            switch tab {
            case .pending:
                PendingListView(
                    viewModel: viewModel,
                    applications: viewModel.pendingApplications,
                    selectedRequestType: $viewModel.selectedRequestType,
                    onDidUpdate: { refreshToken = UUID() }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))

                
            case .history:
                HistoryListView(
                    viewModel: viewModel,
                    applications: viewModel.historyApplications,
                    selectedRequestType: $viewModel.selectedRequestType,
                    selectedDecision: $viewModel.selectedDecision,
                    onDidUpdate: { refreshToken = UUID() }
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            }
            
            Spacer()
        }
        .navigationTitle(String(localized: "asv.nav.title"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section(String(localized: "asv.menu.requestType")) {
                        Button(String(localized: "asv.menu.all")) { viewModel.selectedRequestType = nil }
                        Divider()
                        ForEach(viewModel.uniqueRequestTypes, id: \.self) { type in
                            Button {
                                viewModel.selectedRequestType = type
                            } label: {
                                Label(type.displayName, systemImage: type.systemImage)
                            }
                        }
                    }
                    
                    if tab == .history {
                        Section(String(localized: "asv.menu.decision")) {
                            Button(String(localized: "asv.menu.all")) { viewModel.selectedDecision = nil }
                            Divider()
                            ForEach(viewModel.uniqueHistoryDecisions, id: \.self) { d in
                                Button {
                                    viewModel.selectedDecision = d
                                } label: {
                                    Label(d.displayName, systemImage: d.systemImage)
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .task(id: refreshToken) {
            viewModel.checkAccessPermission(user: sessionManager.currentUser)
            await viewModel.readApplications()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "asv.button.ok")) {
                if viewModel.shouldDismissOnAlert {
                    viewModel.shouldDismissOnAlert = false
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(String(localized: "asv.header.title"))
                .menuTitleStyle()
            
            Spacer()
            
            if tab == .pending {
                Text(String(format: String(localized: "asv.header.countPending.format"), viewModel.pendingApplications.count))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            } else {
                Text(String(format: String(localized: "asv.header.countHistory.format"), viewModel.historyApplications.count))
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }
    
}

// MARK: - Pending
private struct PendingListView: View {
    
    let viewModel: AdminStatusViewModel
    let applications: [VendorStatusApplication]
    @Binding var selectedRequestType: VendorStatusRequestType?
    let onDidUpdate: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            FilterChipsView(
                requestTypes: uniqueRequestTypes,
                selectedRequestType: $selectedRequestType
            )
            .padding(.horizontal)
            
            if applications.isEmpty {
                emptyState(
                    title: String(localized: "asv.empty.pending.title"),
                    subtitle: String(localized: "asv.empty.pending.subtitle")
                )
                .padding(.top, 24)
            } else {
                List {
                    Section(String(localized: "asv.section.actionRequired")) {
                        ForEach(applications) { app in
                            if let summary = viewModel.vendorSummaryById[app.vendorId] {
                                NavigationLink {
                                    AdminStatusDetailView(
                                        application: app,
                                        vendorSummary: summary,
                                        onDidUpdate: onDidUpdate
                                    )
                                } label: {
                                    AdminStatusApplicationRow(application: app)
                                }
                            } else {
                                HStack {
                                    AdminStatusApplicationRow(application: app)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    ProgressView()
                                }
                                .contentShape(Rectangle())
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private var uniqueRequestTypes: [VendorStatusRequestType] {
        Array(Set(applications.map { $0.requestType }))
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    private func emptyState(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

// MARK: - History

private struct HistoryListView: View {
    
    let viewModel: AdminStatusViewModel
    let applications: [VendorStatusApplication]
    @Binding var selectedRequestType: VendorStatusRequestType?
    @Binding var selectedDecision: VendorStatusDecision?
    let onDidUpdate: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            FilterChipsView(
                requestTypes: uniqueRequestTypes,
                selectedRequestType: $selectedRequestType
            )
            .padding(.horizontal)
            
            if applications.isEmpty {
                emptyState(
                    title: String(localized: "asv.empty.history.title"),
                    subtitle: String(localized: "asv.empty.history.subtitle")
                )
                .padding(.top, 24)
            } else {
                List {
                    Section(String(localized: "asv.section.history")) {
                        ForEach(applications) { app in
                            if let summary = viewModel.vendorSummaryById[app.vendorId] {
                                NavigationLink {
                                    AdminStatusDetailView(
                                        application: app,
                                        vendorSummary: summary,
                                        onDidUpdate: onDidUpdate
                                    )
                                } label: {
                                    AdminStatusApplicationRow(application: app)
                                }
                            } else {
                                HStack {
                                    AdminStatusApplicationRow(application: app)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    ProgressView()
                                }
                                .contentShape(Rectangle())
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }
    
    private var uniqueRequestTypes: [VendorStatusRequestType] {
        Array(Set(applications.map { $0.requestType }))
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    private func emptyState(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}



// MARK: - Shared: Filter Chips
private struct FilterChipsView: View {
    let requestTypes: [VendorStatusRequestType]
    @Binding var selectedRequestType: VendorStatusRequestType?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: String(localized: "asv.filter.all"), isSelected: selectedRequestType == nil) {
                    selectedRequestType = nil
                }
                
                ForEach(requestTypes, id: \.self) { type in
                    chip(title: type.displayName, isSelected: selectedRequestType == type) {
                        selectedRequestType = type
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }
    
    private func chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.primary.opacity(0.08) : Color.secondary.opacity(0.08))
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Row
private struct AdminStatusApplicationRow: View {
    let application: VendorStatusApplication
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: application.requestType.systemImage)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 28)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(application.requestType.displayName)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Spacer()
                    
                    decisionPill(application.decision)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: String(localized: "asv.row.vendorPublicId.format"), application.vendorPublicId))
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    
                    Text(String(format: String(localized: "asv.row.applicantId.format"), application.applicantUserId))
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                    if let message = application.message, !message.isEmpty {
                        Text(message)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                
                
                HStack(spacing: 10) {
                    Text(String(format: String(localized: "asv.row.terms.format"), String(application.termsVersion)))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    
                    Text("·")
                        .foregroundStyle(.secondary)
                    
                    Text(application.updatedAt, style: .relative)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func decisionPill(_ decision: VendorStatusDecision) -> some View {
        Text(decision.displayName)
            .font(.system(size: 11, weight: .bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(decision.tint.opacity(0.16))
            )
            .foregroundStyle(decision.tint)
    }
}


#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[1]
    session.authLevel = .authenticated

    return NavigationStack {
        AdminStatusView()
    }
    .environment(session)
    .environment(ToastCenter())
}
