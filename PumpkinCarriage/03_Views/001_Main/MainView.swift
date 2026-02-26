import SwiftUI
import Combine

struct MainView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @State private var viewModel = MainViewModel()
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(Array(viewModel.bannerImages.prefix(10).enumerated()), id: \.offset) {
                        index, imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 300)
                .padding(.top, 2)
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 0.6)) {
                        viewModel.moveToNextBanner()
                    }
                }
                HStack{
                    Rectangle()
                        .fill(Color.background)
                        .frame(height: 1)
                    Text(String(localized: "mv.section.category"))
                        .captionTextStyle()
                        .padding(.horizontal, 10)
                    Rectangle()
                        .fill(Color.background)
                        .frame(height: 1)
                }
                .padding(.horizontal, 15)
                

                Button {
                    viewModel.category = VendorCategory.all
                    viewModel.showMainListView = true
                } label: {
                    VStack{
                        VStack{
                            Text(VendorCategory.all.displayName)
                                .font(.caption)
                                .foregroundStyle(.main.opacity(0.15))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 2)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(
                                            Color.main.opacity(0.15),
                                            lineWidth: 1
                                        )
                                }
                        }
                    }
                }
                .tint(.main)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                    ForEach(VendorCategory.allCases.filter{$0 != .all}) { category in
                        Button(action: {
                            viewModel.category = category
                            viewModel.showMainListView = true
                        }) {
                            VStack {
                                Image(systemName: category.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding()
                                    .background(Color.background)
                                    .cornerRadius(12)
                                Text(category.displayName)
                                    .secondaryTextStyle()
                            }
                            .tint(.main)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal)
                .navigationDestination(isPresented: $viewModel.showMainListView) {
                    MainListView(category: viewModel.category)
                }
                

                HStack{
                    Rectangle()
                        .fill(Color.background)
                        .frame(height: 1)
                    Text(String(localized: "mv.section.popularStores"))
                        .captionTextStyle()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 10)
                    Rectangle()
                        .fill(Color.background)
                        .frame(height: 1)
                }
                .padding(.horizontal, 15)
                .padding(.top, 100)
                .padding(.bottom, 5)
                
                VStack {
                    ListComponentView(vendorSummaries: viewModel.vendorList)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 100)
            }
        }
        .task {
            await viewModel.fetchTop10Vendors()
        }
    }
}


#Preview {
    NavigationStack {
        MainView()
    }
    .environment(SessionManager())
    .environment(ToastCenter())
}
