import SwiftUI
import MessageUI

struct ProfileView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    @Environment(\.locale) private var locale

    private var sessionStatus: Bool {
        guard sessionManager.sessionState == .signedIn,
              let _ = sessionManager.currentUser
        else { return false }
        if sessionManager.authLevel == .guest { return false }
        return true
    }
    private var isGuest: Bool { sessionManager.authLevel == .guest }
    @State private var viewModel = ProfileViewModel()

    private var webLang: String {
        let code = locale.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // currently not serving EN web docs
        default: return "ja"
        }
    }
    
    //MARK: - General Menu
    func generalMenu() -> some View {
        LazyVStack(spacing: 10) {
            HStack {
                Text(String(localized: "pv.section.general"))
                    .secondaryTextStyle()
                Spacer()
            }
            //History - Navigation Link
            //Button {
            //    viewModel.showHistory = true
            //} label: {
            //    Text("History")
            //        .primaryTextStyle()
            //}
            //.buttonStyle(PrimaryButtonStyle())
            
            //Setting - Sheet
            Button {
                viewModel.showSetting = true
            } label: {
                Text(String(localized: "pv.button.setting"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
            
//            Button {
//                viewModel.showGuide = true
//            } label: {
//                Text("Guide")
//                    .primaryTextStyle()
//            }
//            .buttonStyle(HighlightButtonStyle())
            
        }
//        .navigationDestination(isPresented: $viewModel.showGuide, destination: {
//            GuideView()
//        })
        .navigationDestination(isPresented: $viewModel.showSetting) {
            SettingView()
        }
    }
    
    //MARK: - Help Center
    func helpCenter() -> some View {
        LazyVStack(spacing: 10) {
            HStack {
                Text(String(localized: "pv.section.help"))
                    .secondaryTextStyle()
                Spacer()
            }
            //Notifications - Sheet
            Button {
                viewModel.showNotifications = true
            } label: {
                Text(String(localized: "pv.button.notifications"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            //FAQ - Navigation Link
            Button {
                viewModel.showFAQ = true
            } label: {
                Text(String(localized: "pv.button.faq"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            //Inquiry - Default Mail App
            Button {
                if MFMailComposeViewController.canSendMail() {
                    viewModel.showInquiry = true
                } else {
                    viewModel.createMessage(title: String(localized: "pv.mail.unavailable.title"), message: String(localized: "pv.mail.unavailable.msg"))
                }
            } label: {
                Text(String(localized: "pv.button.inquiry"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .sheet(isPresented: $viewModel.showNotifications) {
            SafariView(url: WebDocs.notice(lang: webLang))
                .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $viewModel.showFAQ, destination: {
            FAQView()
        })
        .navigationDestination(isPresented: $viewModel.showInquiry) {
            let subject = sessionManager.authLevel == .guest ? String(localized: "pv.inquiry.subject.guest") : String(localized: "pv.inquiry.subject.normal")
            MailView(
                subject: subject,
                messageBody: String(localized: "pv.inquiry.body"),
                recipients: ["contact@yourapp.com"]
            )
        }
    }
    
    //MARK: -
    func signStatusSection() -> some View {
        LazyVStack(spacing: 10) {
            Spacer()
            Divider()
            if sessionStatus {
                Button {
                    viewModel.createAlert(title: String(localized: "pv.alert.signOut.title"), message: String(localized: "pv.alert.signOut.msg"))
                    viewModel.showAlert = true
                } label: {
                    Text(String(localized: "pv.button.signOut"))
                }
                .buttonStyle(PrimaryButtonStyle())
            } else {
                Button {
                    withAnimation { sessionManager.startAuthFlow() }
                } label: {
                    Text(String(localized: "pv.button.signInSignUp"))
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "pv.button.signOut"), role: .destructive) {
                withAnimation { sessionManager.signOut() }
            }
            Button(String(localized: "pv.button.cancel"), role: .cancel) {
            }
        } message : {
            Text(viewModel.alertMessage)
        }
    }
    
    
    //MARK: - Vendor Menu
    func vendorMenu() -> some View {
        LazyVStack(spacing: 10) {
            HStack {
                Text(String(localized: "pv.section.vendorMenu"))
                    .secondaryTextStyle()
                Spacer()
            }
            
            Button {
                viewModel.showVendorPortal = true
            } label: {
                Text(String(localized: "pv.button.vendorPortal"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .fullScreenCover(isPresented: $viewModel.showVendorPortal) {
            if viewModel.accessVendorPortal() {
                VendorPortalView(user: viewModel.user)
                    .environment(toastCenter)
                    .toast()
            } else {
                Color.clear
                    .onAppear {
                        viewModel.createMessage(
                            title: String(localized: "pv.message.accessDenied.title"),
                            message: String(localized: "pv.message.accessDenied.vendorOrAdmin.msg")
                        )
                        viewModel.showVendorPortal = false
                    }
            }
        }
    }
    
    func vendorApply() -> some View {
        LazyVStack(spacing: 10) {
            HStack {
                Text(String(localized: "pv.section.vendorMenu"))
                    .secondaryTextStyle()
                Spacer()
            }
            
            Button {
                viewModel.activeDestination = nil
                viewModel.pendingDestination = .applyVendor(userId: viewModel.user.id)
                viewModel.showLoginConfirmation = true
            } label: {
                Text(String(localized: "pv.button.applyVendor")).primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
    }
    
    //MARK: - Admin Menu
    func adminMenu() -> some View {
        LazyVStack(spacing: 10) {
            HStack {
                Text(String(localized: "pv.section.adminMenu"))
                    .secondaryTextStyle()
                Spacer()
            }
            
            Button {
                viewModel.showAdminPortal = true
            } label: {
                Text(String(localized: "pv.button.adminPortal"))
                    .primaryTextStyle()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .fullScreenCover(isPresented: $viewModel.showAdminPortal) {
            if viewModel.accessAdminPortal() {
                AdminPortalView(user: viewModel.user)
                    .environment(toastCenter)
                    .toast()
            } else {
                Color.clear
                    .onAppear {
                        viewModel.createMessage(
                            title: String(localized: "pv.message.accessDenied.title"),
                            message: String(localized: "pv.message.accessDenied.admin.msg")
                        )
                        viewModel.showAdminPortal = false
                    }
            }
        }
    }
    
    //MARK: - Body
    var body: some View {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Profile Card
                    ProfileHeaderView(
                        username: sessionStatus ? viewModel.user.username : (isGuest ? String(localized: "pv.user.guest") : String(localized: "pv.user.default")),
                        country: sessionStatus ? viewModel.user.localeCountry.displayName : "---",
                        createdAt: sessionStatus ? viewModel.user.createdAt : Date()
                    )
//                    {
//                        if sessionStatus {
//                            viewModel.activeDestination = nil
//                            viewModel.pendingDestination = .editProfile(userId: viewModel.user.id)
//                            viewModel.showLoginConfirmation = true
//                        } else {
//                            viewModel.createMessage(title: String(localized: "pv.message.notSignedIn.title"), message: String(localized: "pv.message.notSignedIn.msg"))
//                        }
//                    }
                    // General Menu
                    generalMenu()
                    
                    // Vendor Menu
                    if sessionStatus,
                       sessionManager.currentUser?.role == .vendor {
                        vendorMenu()
                    } else if sessionStatus, sessionManager.currentUser?.role == .user {
                        vendorApply()
                    }
                    
                    // Admin Menu
                    if sessionStatus,
                       sessionManager.currentUser?.role == .admin {
                        adminMenu()
                    }
                    
                    // Help Center
                    helpCenter()
                    
                    // Sign Out Button
                    signStatusSection()
                    
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 100)
            }
            
        .onAppear(){
            viewModel.fetchCurrentUser(session: sessionManager)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showMessage) {
            Button(String(localized: "pv.button.ok")) {
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .sheet(isPresented: $viewModel.showLoginConfirmation) {
            ReauthView { result in
                defer { viewModel.showLoginConfirmation = false }

                switch result {
                case .success(let userId):
                    guard let pending = viewModel.pendingDestination else { return }

                    let dest: ProfileViewModel.ProtectedDestination
                    switch pending {
//                    case .editProfile:
//                        dest = .editProfile(userId: userId)
                    case .applyVendor:
                        dest = .applyVendor(userId: userId)
                    }

                    viewModel.pendingDestination = nil
                    viewModel.activeDestination = nil
                    DispatchQueue.main.async {
                        viewModel.activeDestination = dest
                    }
                    toastCenter.show(.init(message: String(localized: "reav.toast.confirmSuccess")))
                case .differentUser, .inactiveUser, .wrongCredential, .requiresSignIn:
                    // ReauthView handles user-facing alerts for auth failures.
                    viewModel.pendingDestination = nil
                    viewModel.activeDestination = nil
                    break
                }
            }
        }
        .navigationDestination(item: $viewModel.activeDestination) { dest in
            switch dest {
//            case .editProfile(let userId):
//                EditProfileView(userId: userId)
                
            case .applyVendor(let userId):
                ApplyCurtainView(userId: userId)
            }
        }
    }
}


struct ProfileHeaderView: View {
    let username: String
    let country: String
    let createdAt: Date
    //let onTap: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.background)
                .frame(height: 120)
            
            VStack {
                HStack (alignment: .center) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .padding(5)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(alignment: .leading) {
                        Text(username).primaryTextStyle()
                        // Text(country).secondaryTextStyle()
                        Text(formatDate(createdAt)).secondaryTextStyle()
                    }
                    
                    Spacer()
//                    Image(systemName: "chevron.right")
//                        .foregroundStyle(.highlight)
//                        .onTapGesture {
//                            onTap()
//                        }
                }
//                Divider()
//                    .padding(10)
//                RoundedRectangle(cornerRadius: 20)
//                    .frame(height: 80)
//                    .foregroundStyle(.clear)
                
            }
            .padding(15)
            //.frame(height: 100)
            .foregroundStyle(.main)
        }
    }
}


#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.authLevel = .authenticated
    session.currentUser = UserMockSeed.makeUsers()[1]
    
    return NavigationStack{
        ProfileView()
    }
    .environment(session)
    .environment(ToastCenter())
    //.environment(AppSettings())
}
