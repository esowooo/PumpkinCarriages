import SwiftUI

struct RootView: View {

    @Environment(SessionManager.self) var sessionManager
    //@Environment(AppSettings.self) private var appSettings

    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
            } else {
                contentView
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: sessionManager.sessionState)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showSplash = false
            }
        }
        //.environment(\.locale, appSettings.locale)
        .toast()
    }

    @ViewBuilder
    private var contentView: some View {
        switch sessionManager.sessionState {
        case .signedIn:
            HomeView()
        case .signedOut:
            LoginView()
        }
    }
}

#Preview {
    RootView()
        .environment(SessionManager())
        .environment(ToastCenter())
        //.environment(AppSettings())
        
}
