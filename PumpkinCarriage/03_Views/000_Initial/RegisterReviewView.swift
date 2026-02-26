import SwiftUI

struct RegisterReviewView: View {
    let registerViewModel: RegisterViewModel
    let onConfirm: () async -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showTerms = false
    @State private var showPrivacy = false
    @State private var hasOpenedTerms = false
    @State private var hasOpenedPrivacy = false
    @State private var consentChecked = false
    
    private var webLang: String {
        let code = Locale.current.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // not serving EN
        default: return "ja"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Text(String(localized: "rrv.title.reviewDetails"))
                        .menuTitleStyle()
                    Spacer()
                }
                Divider()
                    .background(.main)
                    .padding(.horizontal, 105)
            }
            ScrollView{
                VStack(alignment: .leading, spacing: 25) {
                    summaryRow(title: String(localized: "rrv.field.email"), value: registerViewModel.form.email)
                    summaryRow(title: String(localized: "rrv.field.username"), value: registerViewModel.form.username)
                    summaryRow(title: String(localized: "rrv.field.password"), value: String(repeating: "•", count: registerViewModel.form.password.count))
                }
                .padding(.horizontal, 25)
            }
            .frame(height: 200)
            
            
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    FormFieldLabel(text: String(localized: "rrv.button.edit"))
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(String(localized: "sav.card.termsAgreement")).font(.system(size: 15, weight: .semibold))

                Button {
                    showTerms = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                        Text(String(localized: "setv.nav.terms")).font(.caption).foregroundStyle(.main)
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.black.opacity(0.04)))
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showTerms, onDismiss: { hasOpenedTerms = true }) {
                    SafariView(url: WebDocs.terms(lang: webLang)).ignoresSafeArea()
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

                Button {
                    showPrivacy = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                        Text(String(localized: "setv.nav.privacy")).font(.caption).foregroundStyle(.main)
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.black.opacity(0.04)))
                }
                .buttonStyle(.plain)
                .sheet(isPresented: $showPrivacy, onDismiss: { hasOpenedPrivacy = true }) {
                    SafariView(url: WebDocs.privacy(lang: webLang)).ignoresSafeArea()
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

                Button {
                    consentChecked.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: consentChecked ? "checkmark.square.fill" : "square")
                            .foregroundStyle(consentChecked ? Color.highlight : Color.main)
                        Text(String(localized: "sav.consent.agreeProceed")).font(.system(size: 14, weight: .bold))
                    }
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .disabled(!(hasOpenedTerms && hasOpenedPrivacy))
                .opacity((hasOpenedTerms && hasOpenedPrivacy) ? 1.0 : 0.65)
            }
            .padding(.horizontal, 15)

            Spacer()

            Button(String(localized: "rrv.button.register")) {
                Task { await onConfirm() }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!consentChecked)
            .opacity(consentChecked ? 1.0 : 0.65)

            
            Spacer()
        }
        .padding(.horizontal, 15)
    }

    private func summaryRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .primaryTextStyle()
            Text(value).font(.body)
        }
    }
}

#Preview {
    RegisterReviewView(registerViewModel: RegisterViewModel(), onConfirm: {})
}
