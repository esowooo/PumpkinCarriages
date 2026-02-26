import SwiftUI


struct AdminVendorView: View {

    @State private var viewModel = AdminVendorViewModel()

    @State private var category: VendorCategory = .all
    @State private var statusFilter: VendorStatusFilter = .all
    @State private var searchMode: VendorSearchMode = .name

    private enum VendorStatusFilter: Identifiable, Hashable {
        case all
        case status(VendorStatus)

        var id: String {
            switch self {
            case .all: return "all"
            case .status(let s): return "status-\(s.rawValue)"
            }
        }

        var displayName: String {
            switch self {
            case .all: return String(localized: "avv.filter.status.all")
            case .status(let s): return s.displayName
            }
        }

        var statusValue: VendorStatus? {
            switch self {
            case .all: return nil
            case .status(let s): return s
            }
        }
    }
    
    private func statusColor(from status: VendorStatus?) -> Color {
        guard let status else { return .clear }
        switch status {
        case .active:
            return .green
        case .pending:
            return .yellow
        case .rejected:
            return .red
        case .hidden:
            return .gray
        case .archived:
            return .main
        }
    }

    private var statusBar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach([
                        VendorStatusFilter.all,
                        .status(.active),
                        .status(.pending),
                        .status(.hidden),
                        .status(.rejected),
                        .status(.archived)
                    ], id: \.id) { item in
                        Button {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                statusFilter = item
                                proxy.scrollTo(item.id, anchor: .center)
                            }
                        } label: {
                            HStack(spacing: 3){
                                if case.status(let status) = item {
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundStyle(statusColor(from: status))
                                }
                                Text(item.displayName)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(statusFilter == item ? .white : .main)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(statusFilter == item ? Color.main : Color.background)
                            )
                            
                        }
                        .buttonStyle(.plain)
                        .id(item.id)
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: statusFilter) { _, newValue in
                withAnimation(.easeInOut(duration: 0.18)) {
                    proxy.scrollTo(newValue.id, anchor: .center)
                }
            }
        }
    }
    
    private var categoryBar: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(VendorCategory.allCases) { item in
                        Button {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                category = item
                                proxy.scrollTo(item.id, anchor: .center)
                            }
                        } label: {
                            Text(item.displayName)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(category == item ? .white : .main)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(category == item ? Color.main : Color.background)
                                )
                        }
                        .buttonStyle(.plain)
                        .id(item.id)
                    }
                }
                .padding(.vertical, 8)
            }
            .onChange(of: category) { _, newValue in
                withAnimation(.easeInOut(duration: 0.18)) {
                    proxy.scrollTo(newValue.id, anchor: .center)
                }
            }
        }
    }
    
    
    private func triggerSearchByMode() {
        Task { await performSearchByMode() }
    }

    private func performSearchByMode() async {
        switch searchMode {
        case .name:
            await viewModel.searchByName(category)
        case .id:
            await viewModel.searchById(category)
        case .publicId:
            await viewModel.searchByPublicId(category)
        case .auto:
            await viewModel.searchVendors(category)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            

            
            categoryBar
                .padding(.horizontal, 5)
            statusBar
                .padding(.horizontal, 5)
            
            SearchField(
                text: $viewModel.searchText,
                placeholder: String(localized: "avv.search.prompt"),
                onSubmit: { triggerSearchByMode() },
                onClear: { triggerSearchByMode() }
            )
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
            
            Picker("", selection: $searchMode) {
                Text("Name").tag(VendorSearchMode.name)
                Text("ID").tag(VendorSearchMode.id)
                Text("Public ID").tag(VendorSearchMode.publicId)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 5)
            .padding(.bottom, 10)
            
 

            
            ScrollView {
                Group {
                    if viewModel.filteredVendors(status: statusFilter.statusValue).isEmpty {
                        VStack {
                            Text(String(localized: "avv.search.noResults"))
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        adminList(
                            vendorSummaries: viewModel.filteredVendors(status: statusFilter.statusValue),
                            category: category
                        )
                    }
                }
            }
            .refreshable {
                await performSearchByMode()
            }
        }
        .padding(.horizontal, 15)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "avv.button.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

private struct SearchField: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: () -> Void
    var onClear: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField(placeholder, text: $text, onCommit: onSubmit)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)

            if !text.isEmpty {
                Button {
                    text = ""
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            Button(action: onSubmit) {
                Text(String(localized: "avv.search.button"))
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.main))
                    .foregroundStyle(.white)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.background))
    }
}

private struct adminList: View {
        var vendorSummaries: [VendorSummary]
        var category: VendorCategory = .all
        @Environment(\.repositories) private var repos
    
    private func statusColor(from status: VendorStatus?) -> Color {
        guard let status else { return .clear }
        switch status {
        case .active:
            return .green
        case .pending:
            return .yellow
        case .rejected:
            return .red
        case .hidden:
            return .gray
        case .archived:
            return .main
        }
    }
    
    func bottomTags(_ vendor: VendorSummary) -> some View {
        HStack(spacing: 3) {
            HStack(spacing: 3){
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundStyle(statusColor(from:vendor.status))
                Text(vendor.status.displayName)
                    .font(.system(size: 10, weight: .regular))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(statusColor(from:vendor.status).opacity(0.1))
            )
            
            Spacer()
            Text(String(vendor.markCount))
                .secondaryTextStyle()
            Image(systemName: "bookmark.fill")
                .secondaryTextStyle()
        }
    }

        var body: some View {
            ForEach(vendorSummaries) { vendor in
                NavigationLink {
                    AdminVendorDetailView(vendorSummary: vendor)
                } label: {
                    if category == .all || vendor.category == category {
                        VStack {
                            HStack (alignment: .top) {
                                if let thumbnail = vendor.thumbnail {
                                    ImageResourceView(
                                        storagePath: thumbnail.storagePath,
                                        repository: repos.imageResolve,
                                        contentMode: .fill,
                                        cornerRadius: 8,
                                        placeholderHeight: 80
                                    )
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .padding(.trailing, 10)
                                } else {
                                    ImagePlaceholderView(
                                        height: 80,
                                        cornerRadius: 8
                                    )
                                    .frame(width: 80, height: 80)
                                    .padding(.trailing, 10)
                                }
                                VStack (alignment: .leading) {
                                    Text(vendor.name)
                                        .primaryTextStyle()
                                    Text("\(vendor.locationCountry.displayName), \(vendor.locationCity.displayName), \(vendor.locationDistrict)")
                                        .logoTextStyle()
                                    Spacer()
                                    
                                    bottomTags(vendor)
                                }
                            }
                            Divider()
                                //.padding(.leading, 90)
                        }
                    }
                }
            }
            .foregroundStyle(.main)
            
        }
}

#Preview {
    let session = SessionManager()
    session.authLevel = .authenticated
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[1]
    
    return NavigationStack {
        AdminVendorView()
    }
    .environment(session)
    .environment(ToastCenter())
}

