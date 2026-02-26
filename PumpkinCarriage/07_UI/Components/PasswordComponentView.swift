






import SwiftUI

struct PasswordComponentView: View {
    
    @Binding var showPassword: Bool
    @Binding var password: String
    var showDivider: Bool = true
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Group {
                    if showPassword {
                        TextField(String(localized: "pcv.placeholder.password"), text: $password)
                    } else {
                        SecureField(String(localized: "pcv.placeholder.password"), text: $password)
                    }
                }
                .textFieldStyle(PasswordTextFieldStyle())

                Button {
                    showPassword.toggle()
                } label: {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .foregroundStyle(.main)
                        .buttonStyle(.plain)
                }
            }
            .frame(height: 20)

            if showDivider {
                Divider()
                    .background(.main)
                    .padding(.bottom, 15)
            }
        }
    }
}



#Preview {
    PasswordComponentView(showPassword: .constant(false), password: .constant("123123"), showDivider: true)
}
