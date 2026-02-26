






import SwiftUI

struct HomeView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager

    @State private var selectedTab: Tab = .main
    @State private var viewModel = HomeViewModel()
    
    //enum Tab { case main, mark, pumpkin, chat, profile }
    enum Tab { case main, mark, profile }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack {
                    HStack {
                        Text(title(for: selectedTab))
                            .font(.custom("Rockwell-Regular", size: 30))
                            .foregroundColor(.main)
                            .frame(height: 44)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    currentView()
                }
                customTabBar()
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button(String(localized: "hv.button.ok"), role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
        
    }
    
    
    func title(for tab: Tab) -> String {
        switch tab {
        case .main: return String(localized: "hv.title.main")
        case .mark: return String(localized: "hv.title.marks")
        //case .pumpkin: return "Pumpkin Pot"
        //case .chat: return "Chat"
        case .profile: return String(localized: "hv.title.my")
        }
    }
        
    
    @ViewBuilder
    func currentView() -> some View {
        switch selectedTab {
        case .main: MainView()
        case .mark: MarkView()
        //case .pumpkin: PumpkinView()
        //case .chat: ChatView()
        case .profile: ProfileView()
        }
    }
    
    func customTabBar() -> some View {
        VStack {
            Spacer()
            HStack {
                tabBarButton(tab: .main, image: "list.dash", title: String(localized: "hv.tab.main"))
                tabBarButton(tab: .mark, image: "bookmark.fill", title: String(localized: "hv.tab.marks"))
                //MARK: - MVP2~
                //tabBarButton(tab: .pumpkin, image: "leaf.fill", title: "Pot")
                //tabBarButton(tab: .chat, image: "bubble.fill", title: "Chat")
                tabBarButton(tab: .profile, image: "person.fill", title: String(localized: "hv.tab.my"))
                    
            }
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 5)
        }
        .padding(.horizontal, 15)
    }
    
    
    @ViewBuilder
    func tabBarButton(tab: Tab, image: String, title: String) -> some View {
        Button {
            if tab == .mark && sessionManager.sessionState == .signedOut {
                viewModel.createAlert(
                    title: String(localized: "hv.alert.signInRequired.title"),
                    message: String(localized: "hv.alert.signInRequired.msg")
                )
            } else {
                withAnimation(.easeInOut) {
                    selectedTab = tab
                    //showSingOut = (tab == .profile)
                }
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: image)
                    .primaryTextStyle()
                    .frame(maxWidth: .infinity, minHeight: 30)
                Text(title)
                    .secondaryTextStyle()
            }
            .padding(3)
            .foregroundColor(selectedTab == tab ? .highlight : .main)
            .contentShape(Rectangle())
            .background(
                Group {
                    if selectedTab == tab {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    }
                }
            )
        }
    }
}


#Preview {
    let session = SessionManager()
        session.sessionState = .signedIn
        session.authLevel = .authenticated
        session.currentUser = UserMockSeed.makeUsers()[1]
        
    return HomeView()
        .environment(session)
        .environment(ToastCenter())
}
