import SwiftUI

struct FAQView: View {
    @Environment(\.locale) private var locale

    // MARK: - Web FAQ (Full)
    @State private var showFullFAQSheet = false

    private var webLang: String {
        let code = locale.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // currently not serving EN web docs
        default: return "ja"
        }
    }

    private var isEnglishUI: Bool {
        (locale.language.languageCode?.identifier ?? "") == "en"
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(String(localized: "faqv.title.faqs"))
                            .menuTitleStyle()

                        Spacer()

                        Button {
                            showFullFAQSheet = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "safari")
                                    .font(.caption)
                                Text(String(localized: "faqv.button.viewFull"))
                                    .font(.caption)
                            }
                            .foregroundStyle(.main)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.black.opacity(0.04))
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if isEnglishUI {
                        Text("Full FAQ is available in Japanese and Korean only.")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding(.top, 35)
                .padding(.horizontal, 25)
                .sheet(isPresented: $showFullFAQSheet) {
                    SafariView(url: WebDocs.faq(lang: webLang))
                        .ignoresSafeArea()
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

                
                List {
                    ForEach(QuestionCategory.allCases, id: \.self) { category in
                        Section {
                            ForEach(FAQs.filter { $0.category == category }) { faq in
                                DisclosureGroup(faq.title) {
                                    Text(faq.content)
                                        .secondaryTextStyle()
                                }
                            }
                        } header: {
                            Text(category.displayName)
                                .primaryTextStyle()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                
            }
        }
    }
}

#Preview {
    FAQView()
}


//MARK: - Mock Data
struct FAQ: Identifiable {
    var id = UUID()
    var category: QuestionCategory
    var title: String
    var content: String
}

enum QuestionCategory: CaseIterable {
    case account
    case vendor
    case app
    case privacy
    case other

    var displayName: String {
        switch self {
        case .account:
            return String(localized: "faqv.category.account")
        case .vendor:
            return String(localized: "faqv.category.vendor")
        case .app:
            return String(localized: "faqv.category.app")
        case .privacy:
            return String(localized: "faqv.category.privacy")
        case .other:
            return String(localized: "faqv.category.other")
        }
    }
}

let FAQs: [FAQ] = [
    // Service
    FAQ(category: .app,
        title: String(localized: "faqv.q.service.what.title"),
        content: String(localized: "faqv.q.service.what.body")),

    // Guest / Account
    FAQ(category: .account,
        title: String(localized: "faqv.q.guest.canUse.title"),
        content: String(localized: "faqv.q.guest.canUse.body")),
    FAQ(category: .account,
        title: String(localized: "faqv.q.guest.limits.title"),
        content: String(localized: "faqv.q.guest.limits.body")),
    FAQ(category: .account,
        title: String(localized: "faqv.q.favorites.how.title"),
        content: String(localized: "faqv.q.favorites.how.body")),

    // Vendor
    FAQ(category: .vendor,
        title: String(localized: "faqv.q.vendor.whoRegisters.title"),
        content: String(localized: "faqv.q.vendor.whoRegisters.body")),
    FAQ(category: .vendor,
        title: String(localized: "faqv.q.vendor.contact.title"),
        content: String(localized: "faqv.q.vendor.contact.body")),
    FAQ(category: .vendor,
        title: String(localized: "faqv.q.vendor.howToRegister.title"),
        content: String(localized: "faqv.q.vendor.howToRegister.body")),

    // Privacy / Legal
    FAQ(category: .privacy,
        title: String(localized: "faqv.q.account.deleteSoft.title"),
        content: String(localized: "faqv.q.account.deleteSoft.body")),
    FAQ(category: .privacy,
        title: String(localized: "faqv.q.legal.takedown.title"),
        content: String(localized: "faqv.q.legal.takedown.body")),

    // Support
    FAQ(category: .other,
        title: String(localized: "faqv.q.support.contact.title"),
        content: String(localized: "faqv.q.support.contact.body"))
]
