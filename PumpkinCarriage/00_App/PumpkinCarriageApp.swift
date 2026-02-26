

import SwiftUI
import TipKit

@main
struct PumpkinCarriageApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @State private var sessionManager = SessionManager()
    @State private var toastCenter = ToastCenter()
    //@State private var appSettings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(sessionManager)
                .environment(toastCenter)
                .environment(\.repositories, .shared)
                .environment(\.services, .shared)
                //.environment(appSettings)
        }
    }
}
