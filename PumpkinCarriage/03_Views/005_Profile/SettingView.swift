import SwiftUI

struct SettingView: View {
    
    @Environment(\.locale) private var locale
    
    @State private var showDeletionView = false
    
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        //let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "\(version)"
    }
    
    private enum LegalDoc: String, CaseIterable, Identifiable {
        case terms, privacy, deletionRetention, privacyChoices, thirdParty, openSource

        var id: String { rawValue }

        var titleKey: String.LocalizationValue {
            switch self {
            case .terms: return "setv.nav.terms"
            case .privacy: return "setv.nav.privacy"
            case .deletionRetention: return "setv.nav.deletionRetention"
            case .privacyChoices: return "setv.nav.privacyChoices"
            case .thirdParty: return "setv.nav.thirdParty"
            case .openSource: return "setv.nav.openSource"
            }
        }

        func latestURL(lang: String) -> URL {
            switch self {
            case .terms: return WebDocs.terms(lang: lang)
            case .privacy: return WebDocs.privacy(lang: lang)
            case .deletionRetention: return WebDocs.deletionRetention(lang: lang)
            case .privacyChoices: return WebDocs.privacyChoices(lang: lang)
            case .thirdParty: return WebDocs.thirdParty(lang: lang)
            case .openSource: return WebDocs.openSource(lang: lang)
            }
        }
    }
    
    private enum SupportDoc: String, CaseIterable, Identifiable {
        case takedown, noticePolicy, changelog

        var id: String { rawValue }

        var titleKey: String.LocalizationValue {
            switch self {
            case .takedown: return "setv.support.takedown"
            case .noticePolicy: return "setv.support.noticePolicy"
            case .changelog: return "setv.support.changelog"
            }
        }

        func latestURL(lang: String) -> URL {
            switch self {
            case .takedown: return WebDocs.takedown(lang: lang)
            case .noticePolicy: return WebDocs.noticePolicy(lang: lang)
            case .changelog: return WebDocs.legalChangelog(lang: lang)
            }
        }
    }

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
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                Text(String(localized: "setv.title.settings"))
                    .menuTitleStyle()
                List {
                    Section {
                        HStack {
                            Text(String(localized: "setv.row.appVersion"))
                            Spacer()
                            Text(appVersion)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Section(String(localized: "setv.legal.title")) {
                        let legalItems: [WebDocItem] = LegalDoc.allCases.map { doc in
                            .init(title: String(localized: doc.titleKey), url: doc.latestURL(lang: webLang))
                        }
                        ForEach(legalItems, id: \.id) { item in
                            WebDocComponentView(item: item)
                        }
                    }
                    
                    Section(String(localized: "setv.support.title")) {
                        let supportItems: [WebDocItem] = SupportDoc.allCases.map { doc in
                            .init(title: String(localized: doc.titleKey), url: doc.latestURL(lang: webLang))
                        }
                        ForEach(supportItems, id: \.id) { item in
                            WebDocComponentView(item: item)
                        }
                    }
                    Section{
                        Button {
                            showDeletionView = true
                        } label: {
                            HStack{
                                Spacer()
                                Text(String(localized: "setv.account.delete"))
                                    .tint(Color.gray.opacity(0.7))
                                Spacer()
                            }
                        }
                    }
//                    Section {
//                        NavigationLink {
//                            LanguageSettingView()
//                        } label: {
//                            Text(String(localized: "setv.nav.language"))
//                        }
//                    }
                }
            }
            .primaryTextStyle()
        }
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $showDeletionView) {
            AccountDeletionView()
                .presentationDetents([.medium])
        }
    }

}






//struct LanguageSettingView: View {
//    @Environment(AppSettings.self) private var appSettings
//
//    var body: some View {
//        List {
//            ForEach(AppLanguage.allCases) { lang in
//                Button {
//                    appSettings.language = lang
//                } label: {
//                    HStack {
//                        Text(lang.title)
//                        Spacer()
//                        if appSettings.language == lang {
//                            Image(systemName: "checkmark")
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                }
//            }
//        }
//        .font(.system(size: 16, weight: .regular))
//        .navigationTitle(String(localized: "setv.nav.language"))
//    }
//}





#Preview {
    NavigationStack {
        SettingView()
    }
    //.environment(AppSettings())
    .environment(SessionManager())
    .environment(ToastCenter())
}

