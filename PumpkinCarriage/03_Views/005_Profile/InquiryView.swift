


//MARK: - This is sample UI.
//MARK: - Currently Inquiry Tab is set to use iOS default mail App. Need to modify 'Profile View' in order to use other options.


//import SwiftUI
//
//struct InquiryView: View {
//    @State private var viewModel = InquiryViewModel()
//
//    var body: some View {
//        ZStack {
//            Color.background
//                .ignoresSafeArea()
//            VStack {
//                Text("Inquiry")
//                    .menuTitleStyle()
//                Form {
//                    
//                    Section(header: Text("Email")) {
//                        TextField("example@email", text: $viewModel.email)
//                            .keyboardType(.emailAddress)
//                            .textContentType(.emailAddress)
//                            .autocapitalization(.none)
//                            .disableAutocorrection(true)
//                            .foregroundStyle(.black)
//                    }
//                    
//                    Section(header: Text("Subject")) {
//                        TextField("Please write your inquiry title", text: $viewModel.subject)
//                    }
//                    
//                    Section(header: Text("Content")) {
//                        TextEditor(text: $viewModel.body)
//                            .frame(height: 200)
//                    }
//                    
//                    
//                }
//                .scrollContentBackground(.hidden)
//                Button("Send") {
//                    viewModel.send()
//                }
//                .disabled(!viewModel.isValid)
//                .buttonStyle(PrimaryButtonStyle())
//                .padding(.horizontal, 50)
//            }
//        }
//    }
//}
//
//#Preview {
//    InquiryView()
//}
