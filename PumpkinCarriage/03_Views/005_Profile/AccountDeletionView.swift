import SwiftUI

struct AccountDeletionView: View {
    
    @Environment(SessionManager.self) private var sessionManager
    @Environment(ToastCenter.self) private var toastCenter
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale

    @State private var viewModel = AccountDeletionViewModel()
    @State private var showReauth = false
    @State private var showDeletionPolicy = false

    private var webLang: String {
        let code = locale.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // currently not serving EN web docs
        default: return "ja"
        }
    }

    var body: some View {
        
        VStack(alignment:.center){
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .tint(.main)
                }

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.top, 25)
            
            Text(String(localized: "setv.account.delete.title"))
                .menuTitleStyle()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(String(localized: "setv.account.delete.notice.title"))
                    .padding(.vertical, 15)
                    .primaryTextStyle()
                Text(String(localized: "setv.account.delete.notice.timeline"))
                    .font(.system(size: 12, weight: .thin))
                Text(String(localized: "setv.account.delete.notice.timeline2"))
                    .font(.system(size: 12, weight: .thin))
                Text(String(localized: "setv.account.delete.notice.pii"))
                    .font(.system(size: 12, weight: .thin))
                Text(String(localized: "setv.account.delete.notice.anonymize"))
                    .font(.system(size: 12, weight: .thin))
                Spacer()
                HStack {
                   Spacer()
                    Button {
                        showDeletionPolicy = true
                    } label: {
                        Text(String(localized: "setv.account.delete.notice.seeMore"))
                            .captionTextStyle()
                            .foregroundStyle(.gray.opacity(0.5))
                    }
                   Spacer()
                }
                .sheet(isPresented: $showDeletionPolicy) {
                    SafariView(url: WebDocs.deletionRetention(lang: webLang))
                        .ignoresSafeArea()
                }
                
            }
            .padding(15)
            .overlay{
                RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 1)
            }
            
            Spacer()
            HStack{
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "setv.account.delete.cancel"))
                        .primaryTextStyle()
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                Button {
                    showReauth = true
                } label: {
                    Text(String(localized: "setv.account.delete.confirm"))
                        .primaryTextStyle()
                        .foregroundStyle(.white)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .padding(.horizontal, 15)
        .sheet(isPresented: $showReauth) {
            ReauthView { result in
                switch result {
                case .success(let userId):
                    do {
                        try viewModel.softDeleteUser(userId: userId, sessionManager: sessionManager)
                        toastCenter.show(.init(message: String(localized: "setv.account.delete.started")))
                        dismiss()
                    } catch {
                        toastCenter.show(.init(message: String(localized: "setv.account.delete.failed")))
                    }

                case .differentUser, .wrongCredential, .inactiveUser, .requiresSignIn:
                    // ReauthView shows an in-place alert (and may dismiss) for these cases.
                    break
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        AccountDeletionView()
    }
    .environment(SessionManager())
    .environment(ToastCenter())
}
