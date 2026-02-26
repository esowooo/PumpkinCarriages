import SwiftUI

// MARK: - AppSettings

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case ko
    case en
    case ja

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .system: return "as.lang.systemDefault"
        case .ko: return "as.lang.ko"
        case .en: return "as.lang.en"
        case .ja: return "as.lang.ja"
        }
    }

    var localeId: String? {
        switch self {
        case .system: return nil
        case .ko: return "ko"
        case .en: return "en"
        case .ja: return "ja"
        }
    }
}

//@Observable
//final class AppSettings {
//    // NOTE: `@AppStorage` does not reliably participate in Observation updates.
//    // Keep persistence in a non-observed field and expose an observed `language`.
//    @ObservationIgnored
//    @AppStorage("app.language") private var storedLanguageRaw: String = AppLanguage.system.rawValue
//    
//    var locale: Locale { appLocale ?? .current }
//    var language: AppLanguage = .system {
//        didSet {
//            storedLanguageRaw = language.rawValue
//        }
//    }
//    
//
//    init() {
//        // Safe: `language` already has an initial value.
//        self.language = AppLanguage(rawValue: storedLanguageRaw) ?? .system
//    }
//
//    /// `nil` means use system locale.
//    var appLocale: Locale? {
//        guard let id = language.localeId else { return nil }
//        return Locale(identifier: id)
//    }
//}
