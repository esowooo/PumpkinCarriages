import SwiftUI

struct RegisterView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = RegisterViewModel()
    @State private var showPassword = false
    @State private var showReview = false
    @FocusState private var focusedField: Field?
    private enum Field: Hashable {
        case email
        case name
        case password
    }
    private let focusOrder: [Field] = [.email, .name, .password]

    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: - Mandatory
            Text(String(localized: "rv.label.emailRequired"))
                .primaryTextStyle()
            TextField(String(localized: "rv.placeholder.email"), text: $viewModel.form.email)
                .textFieldStyle(AuthTextFieldStyle())
                .focused($focusedField, equals: .email)
            
            Text(String(localized: "rv.label.usernameRequired"))
                .primaryTextStyle()
            TextField(String(localized: "rv.placeholder.username"), text: $viewModel.form.username)
                .textFieldStyle(AuthTextFieldStyle())
                .focused($focusedField, equals: .name)
            
            Text(String(localized: "rv.label.passwordRequired"))
                .primaryTextStyle()
            PasswordComponentView(showPassword: $showPassword, password: $viewModel.form.password)
                .focused($focusedField, equals: .password)
            
            //MARK: - Not Mandatory
            //locale country picker
//            Text("Country")
//                .primaryTextStyle()
//            
//            Picker("", selection: $viewModel.selectedCountry) {
//                ForEach(Country.allCases) {i in
//                    Text(i.displayName)
//                        .font(.system(size: 14))
//                }
//            }
//            .tint(.main)
//            .labelsHidden()
//            .frame(height: 17)
//        Divider()
//            .background(.main)
//            .padding(.bottom, 15)
//            
//            
//            //locale city picker
//            Text("City")
//                .primaryTextStyle()
//            Picker("", selection: $viewModel.selectedCity) {
//                ForEach(City.allCases) {i in
//                    Text(i.displayName)
//                        .font(.system(size: 14))
//                }
//            }
//            .tint(.main)
//            .labelsHidden()
//            .frame(height: 17)
//        Divider()
//            .background(.main)
//            .padding(.bottom, 15)
            

            
            Button {
                if viewModel.validate() {
                    showReview = true
                }
            } label: {
                Text(String(localized: "rv.button.submit"))
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 20)
            .padding(.bottom, 15)
            HStack {
                Spacer()
                Text(String(localized: "rv.text.haveAccount"))
                    .secondaryTextStyle()
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "rv.button.login"))
                        .secondaryTextStyle()
                        .foregroundStyle(.highlight)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .fullScreenCover(isPresented: $showReview) {
            RegisterReviewView(registerViewModel: viewModel) {
                if let user = await viewModel.register() {
                    sessionManager.signIn(user: user)
                    showReview = false
                    toastCenter.show(.init(message: String(localized: "rv.toast.registerSuccess")))
                } else {
                    showReview = false
                }
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            
        } message: {
            Text(viewModel.alertMessage)
        }
        .keyboardFocusToolbar($focusedField, order: focusOrder)
    }
}

#Preview {
    RegisterView()
        .environment(SessionManager())
        .environment(ToastCenter())
}
