//
//
//
//
//
//
//
//import SwiftUI
//
//struct EditProfileView: View {
//    
//    let userId: String
//    
//    @Environment(SessionManager.self) var sessionManager: SessionManager
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var viewModel = EditProfileViewModel()
//    
//    @FocusState private var focusedField: Field?
//    private enum Field: Hashable {
//        case email
//        case name
//        case password
//    }
//    private let focusOrder: [Field] = [.email, .name, .password]
//    
//    private func handleBack() {
//        if viewModel.hasChanges {
//            viewModel.showDiscardAlert = true
//        } else {
//            dismiss()
//        }
//    }
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                
//                HStack {
//                    Text(String(localized: "epv.title.editProfile"))
//                        .menuTitleStyle()
//                    Spacer()
//                }
//                .padding(.bottom, 30)
//                .padding(.top, 160)
//                
//                HStack {
//                    FormFieldLabel(text: String(localized: "epv.label.email"))
//                    TextField(String(localized: "epv.placeholder.email"), text: $viewModel.email)
//                        .textFieldStyle(EmailTextFieldStyle())
//                        .focused($focusedField, equals: .email)
//                }
//                .padding(.bottom, 5)
//                Divider()
//                    .background(.main)
//                    .padding(.bottom, 15)
//                
//                HStack(alignment: .center) {
//                    FormFieldLabel(text: String(localized: "epv.label.username"))
//                    TextField(String(localized: "epv.placeholder.username"), text: $viewModel.username)
//                        .textFieldStyle(UsernameTextFieldStyle())
//                        .focused($focusedField, equals: .name)
//                }
//                .padding(.bottom, 5)
//                Divider()
//                    .background(.main)
//                    .padding(.bottom, 15)
//                
//                HStack {
//                    FormFieldLabel(text: String(localized: "epv.label.password"))
//                    PasswordComponentView(showPassword: $viewModel.showPassword, password: $viewModel.password, showDivider: false)
//                        .focused($focusedField, equals: .password)
//                }
//                .padding(.bottom, 5)
//                Divider()
//                    .background(.main)
//                    .padding(.bottom, 50)
//                
//                Button {
//                    if viewModel.applyChanges(), let updated = viewModel.currentUser {
//                        sessionManager.currentUser = updated
//                        dismiss()
//                    }
//                } label: {
//                    Text(String(localized: "epv.button.save"))
//                }
//                .buttonStyle(PrimaryButtonStyle())
//                .overlay {
//                    if viewModel.hasChanges == false {
//                        RoundedRectangle(cornerRadius: 14, style: .continuous)
//                            .fill(Color.black.opacity(0.10))
//                    }
//                }
//                .opacity((viewModel.hasChanges == false) ? 0.65 : 1.0)
//                .animation(.easeInOut(duration: 0.15), value: viewModel.hasChanges)
//                .disabled(!viewModel.hasChanges)
//                .padding(.horizontal, 15)
//                .padding(.vertical, 10)
//                
//                //                HStack {
//                //                    FormFieldLabel(text: "Country")
//                //                    Picker("", selection: $viewModel.selectedCountry) {
//                //                        ForEach(Country.allCases) {i in
//                //                            Text(i.displayName)
//                //                        }
//                //                    }
//                //                    .tint(.main)
//                //                    .labelsHidden()
//                //                    .fixedSize()
//                //                    .onTapGesture {
//                //                        isFocused = false
//                //                    }
//                //                }
//                //                .padding(.bottom, 5)
//                //                Divider()
//                //                    .padding(.bottom, 10)
//                //                HStack {
//                //                    FormFieldLabel(text: "City")
//                //                    Picker("", selection: $viewModel.selectedCity) {
//                //                        ForEach(City.allCases) {i in
//                //                            Text(i.displayName)
//                //                        }
//                //                    }
//                //                    .tint(.main)
//                //                    .labelsHidden()
//                //                    .fixedSize()
//                //                    .onTapGesture {
//                //                        isFocused = false
//                //                    }
//                //                }
//                //                .padding(.bottom, 5)
//                //                Divider()
//                //                    .padding(.bottom, 10)
//            }
//            
//        }
//        .padding(.horizontal, 15)
//        
//        .onTapGesture { focusedField = nil }
//        .scrollDismissesKeyboard(.interactively)
//        .keyboardFocusToolbar($focusedField, order: focusOrder)
//        .onAppear {
//            viewModel.currentUser = sessionManager.currentUser
//            viewModel.setupUser()
//        }
//        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button {
//                    handleBack()
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .foregroundStyle(.main)
//                }
//            }
//        }
//        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
//            Button(String(localized: "epv.button.ok"), role: .cancel) { }
//        } message: {
//            Text(viewModel.alertMessage)
//        }
//        .alert(String(localized: "epv.discard.title"), isPresented: $viewModel.showDiscardAlert) {
//            Button(String(localized: "epv.discard.discard"), role: .destructive) {
//                dismiss()
//            }
//            Button(String(localized: "epv.discard.cancel"), role: .cancel) { }
//        } message: {
//            Text(String(localized: "epv.discard.message"))
//        }
//    }
//}
//
//
//#Preview {
//    let session = SessionManager()
//    session.currentUser = UserMockSeed.makeUsers()[0]
//    return EditProfileView(userId: UserMockSeed.makeUsers()[0].id)
//        .environment(session)
//}
