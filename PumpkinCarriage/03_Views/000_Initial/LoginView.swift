import SwiftUI

struct LoginView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    
    @State private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    private enum Field: Hashable {
        case email
        case password
    }
    private let focusOrder: [Field] = [.email, .password]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "lv.label.email"))
                .primaryTextStyle()
            TextField(String(localized: "lv.placeholder.email"), text: $viewModel.email)
                .textFieldStyle(AuthTextFieldStyle())
                .focused($focusedField, equals: .email)
            
            Text(String(localized: "lv.label.password"))
                .primaryTextStyle()
            PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password)
                .focused($focusedField, equals: .password)
            
            Button {
                //MARK: - Login (Prototype)
                if let _ = viewModel.authentication(sessionManager: sessionManager) {
                    toastCenter.show(.init(message: String(localized: "lv.toast.signInSuccess")))
                }
            } label: {
                Text(String(localized: "lv.button.login"))
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 20)
            .padding(.bottom, 15)
            HStack {
                Spacer()
                Text(String(localized: "lv.text.noAccount"))
                    .secondaryTextStyle()
                Button {
                    viewModel.presentRegisterView = true
                } label: {
                    Text(String(localized: "lv.button.signUp"))
                        .secondaryTextStyle()
                        .foregroundStyle(.highlight)
                }
                Spacer()
            }
            .padding(.bottom, 55)
            HStack {
                Spacer()
                Button {
                    sessionManager.signInAsGuest()
                } label: {
                    Text(String(localized: "lv.button.guestLogin"))
                        .captionTextStyle()
                        .padding(.horizontal, 30)
                        .padding(.vertical, 5)
                        .background(.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.main.opacity(0.3))
                        )
                        .padding(2)
                }
                Spacer()
            }
            
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .fullScreenCover(isPresented: $viewModel.presentRegisterView, content: {
            RegisterView()
        })
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "lv.button.ok")) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .keyboardFocusToolbar($focusedField, order: focusOrder)
    }
    
}

#Preview {
    
    LoginView()
        .environment(SessionManager())
        .environment(ToastCenter())
}

