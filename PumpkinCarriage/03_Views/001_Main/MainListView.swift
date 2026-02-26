import SwiftUI

struct MainListView: View {
    
    var category: VendorCategory
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @State var showDetailView = false
    @State private var viewModel = MainListViewModel()
    @State private var didDonateListViewTip = false
    
    func getMarks(_ vendor: VendorSummary) -> some View {
        HStack(spacing: 3) {
            Spacer()
            Image(systemName: "bookmark.fill")
                .secondaryTextStyle()
            Text(String(vendor.markCount))
                .secondaryTextStyle()
        }
    }
    
    func filterButton() -> some View {
        HStack(spacing: 12) {
            Button {
                viewModel.showFilterSheet = true
            } label: {
                Label(String(localized: "mlv.filter.label"), systemImage: "line.3.horizontal.decrease.circle")
                    .primaryTextStyle()
            }

            Text(viewModel.filters.summaryText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Spacer()

            if viewModel.filters.summaryText != String(localized: "mlv.filter.allVendors") {
                Button(String(localized: "mlv.filter.reset")) {
                    viewModel.filters = VendorFilters()
                }
                .captionTextStyle()
            }
        }
        .tint(.main)
        .sheet(isPresented: $viewModel.showFilterSheet) {
            VendorFilterSheetView(applied: $viewModel.filters)
                .presentationDetents([.fraction(0.55)])
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.disabled)
        }
    }
    
    func orderButton() -> some View {
        HStack {
            Menu {
                Button(String(localized: "mlv.order.nameAsc")) {
                    viewModel.order = .byNameAsc
                }
                Button(String(localized: "mlv.order.nameDesc")) {
                    viewModel.order = .byNameDsc
                }
                Button(String(localized: "mlv.order.mostMarked")) {
                    viewModel.order = .byMarkCount
                }
            } label: {
                Label(String(localized: "mlv.order.label"), systemImage: "arrow.up.arrow.down.circle")
                    .primaryTextStyle()
            }
            Text(viewModel.order.rawValue)
                .captionTextStyle()
            Spacer()
        }
        .tint(.main)
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                Text(category.displayName)
                    .menuTitleStyle()
                Spacer()
            }
            .padding(.bottom, 15)
            
            VStack(spacing: 15){
                filterButton()
                orderButton()
                    .moveDisabled(true)
            }
            .padding(.bottom, 25)
            
            
            ListComponentView(vendorSummaries: viewModel.orderedVendors, category: category)
        }
        .onAppear {
            Task { await viewModel.readVendorSummaries(category) }
        }
        .refreshable {
            Task { await viewModel.readVendorSummaries(category) }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer, prompt: String(localized: "mlv.search.prompt"))
        .padding(.horizontal, 15)
    }
    
}

#Preview {
    NavigationStack{
        MainListView(category: .all)
    }
    .environment(SessionManager())
    .environment(ToastCenter())
}
