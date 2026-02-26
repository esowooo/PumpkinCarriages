import SwiftUI

struct ReauthView: View {
        
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ReauthViewModel = ReauthViewModel()
    @State private var showLocalAlert = false
    @State private var localAlertTitle: String = ""
    @State private var localAlertMessage: String = ""
    init(onConfirm: @escaping (ReauthResult) -> Void) {
        self.onConfirm = onConfirm
    }
    
    @FocusState private var isFocused: Bool
    let onConfirm: (ReauthResult) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            Text(String(localized: "reav.label.email"))
                .primaryTextStyle()
            TextField(String(localized: "reav.placeholder.email"), text: $viewModel.email)
                .textFieldStyle(AuthTextFieldStyle())
                .focused($isFocused)
            
            Text(String(localized: "reav.label.password"))
                .primaryTextStyle()
            PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password)
                .focused($isFocused)
            
            Button {
                guard let currentUser = sessionManager.currentUser else {
                    onConfirm(.requiresSignIn)
                    dismiss()
                    return
                }

                let result = viewModel.reauth(expectedUserId: currentUser.id)

                switch result {
                case .success(let userId):
                    onConfirm(.success(userId: userId))
                    dismiss()

                case .differentUser:
                    onConfirm(.differentUser)
                    localAlertTitle = String(localized: "pv.message.loginFailed.title")
                                        localAlertMessage = String(localized: "reav.toast.useCurrentAccount")
                                        showLocalAlert = true
                    // Keep open for retry.

                case .wrongCredential:
                    onConfirm(.wrongCredential)
                    localAlertTitle = String(localized: "pv.message.loginFailed.title")
                                        localAlertMessage = String(localized: "reav.toast.loginFailed")
                                        showLocalAlert = true
                    // Keep open for retry.
                    
                case .inactiveUser:
                    onConfirm(.inactiveUser)
                    localAlertTitle = String(localized: "pv.message.loginFailed.title")
                                        localAlertMessage = String(localized: "reav.toast.inactiveUser")
                                        showLocalAlert = true
                    dismiss()

                case .requiresSignIn:
                    onConfirm(.requiresSignIn)
                    localAlertTitle = String(localized: "pv.message.loginFailed.title")
                                        localAlertMessage = String(localized: "reav.toast.signInAgain")
                                        showLocalAlert = true
                    dismiss()
                }
            } label: {
                Text(String(localized: "reav.button.login"))
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 20)
            .padding(.bottom, 15)
            
            HStack{
                Spacer()
                Text(String(localized: "reav.text.loginAgainToProceed"))
                    .secondaryTextStyle()
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "reav.button.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .alert(localAlertTitle, isPresented: $showLocalAlert) {
          Button(String(localized: "reav.button.ok"), role: .cancel) { }
        } message: {
          Text(localAlertMessage)
        }
        .overlay(alignment: .bottomTrailing) {
            if isFocused {
                Button {
                    isFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .padding()
                }
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .foregroundStyle(.main)
                .padding(.trailing, 15)
                .padding(.bottom, 10)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isFocused)
    }
    
}


#Preview {
    ReauthView(onConfirm: { _ in })
        .environment(SessionManager())
        .environment(ToastCenter())
}

