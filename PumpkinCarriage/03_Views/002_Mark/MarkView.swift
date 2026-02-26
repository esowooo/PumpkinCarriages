import SwiftUI

struct MarkView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @State private var category = VendorCategory.all
    @State private var viewModel = MarkViewModel()
    
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            categoryBar
                .padding(.top, 15)
                .padding(.bottom, 25)
                .padding(.horizontal, 5)

            ScrollView {
                if viewModel.vendorList.isEmpty {
                    VStack(spacing: 25) {
                        
                        if sessionManager.authLevel == .guest {
                            Spacer()
                            HStack{
                                Spacer()
                                Text(String(localized: "mkv.text.signInToUseMarks"))
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            Spacer()
                        } else {
                            Text(String(localized: "mkv.text.noMarkFound"))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.secondary)
                            
                            if viewModel.markFetchError {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "info.circle")
                                        .foregroundStyle(.secondary)
                                    
                                    Text(String(localized: "mkv.text.signInAgainIfIncorrect"))
                                        .font(.system(size: 13))
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.secondary.opacity(0.08))
                                )
                            }
                        }
                    }
                    .padding(.top, 60)
                    
                    
                } else {
                    ListComponentView(
                        vendorSummaries: viewModel.vendorList,
                        category: category
                    )
                }
            }
            .refreshable {
                guard sessionManager.sessionState == .signedIn,
                      sessionManager.authLevel == .authenticated,
                      let currentUser = sessionManager.currentUser
                else {
                    viewModel.createAlert(title: String(localized: "mkv.alert.signInRequired.title"), message: String(localized: "mkv.text.signInToUseMarks"))
                    return
                }
                await viewModel.readMarkedVendors(userId: currentUser.id)
                
            }
            .task {
                guard sessionManager.sessionState == .signedIn,
                      sessionManager.authLevel == .authenticated,
                      let currentUser = sessionManager.currentUser
                else { return }
                await viewModel.readMarkedVendors(userId: currentUser.id)
                
            }
        }
        .padding(.horizontal, 15)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "mkv.button.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        
    }
}

#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[4]
    return NavigationStack{
        MarkView()
    }
    .environment(session)
    .environment(ToastCenter())
}
