import Foundation

struct VendorDetail: Codable, Identifiable, Hashable {

    let id: String // VendorSummary.id

    var contactEmail: String?
    var contactPhone: String?

    var description: LocalizedText
    var externalLinks: [ExternalLink]
}

extension VendorDetail {
    static let placeholder = VendorDetail(
        id: "Loading...",
        contactEmail: nil,
        contactPhone: nil,
        description: LocalizedText(),
        externalLinks: [])
}

struct ExternalLink: Codable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var type: ExternalLinkType
    var path: String
    
    var url: String {
        type.baseURL + path
    }
    
    
    init(id: String = UUID().uuidString, type: ExternalLinkType, path: String) {
        self.id = id
        self.type = type
        self.path = path
    }
}

enum ExternalLinkType: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case none
    case instagram
    case line
    case kakaoTalk
    case youtube
    case naverMap
    case kakaoMap
    case x
    case tiktok
    case other
    
    var displayName: String {
        switch self {
        case .none : return "None"
        case .instagram: return "Instagram"
        case .line: return "LINE"
        case .kakaoTalk: return "KakaoTalk"
        case .youtube: return "YouTube"
        case .naverMap: return "Naver Map"
        case .kakaoMap: return "Kakao Map"
        case .x: return "X"
        case .tiktok: return "TikTok"
        case .other: return "Other"
        }
    }
    
    var baseURL: String {
        switch self {
        case .none : return ""
        case .instagram: return "https://www.instagram.com/"
        case .line: return "https://line.me/"
        case .kakaoTalk: return "https://talk.kakao.com/"
        case .youtube: return "https://www.youtube.com/"
        case .naverMap: return "https://map.naver.com/"
        case .kakaoMap: return "https://map.kakao.com/"
        case .x: return "https://www.x.com/"
        case .tiktok: return "https://www.tiktok.com/"
        case .other: return ""
        }
    }
    
}

struct LocalizedText: Codable, Hashable {
    private(set) var raw: [String: String]

    init(raw: [String: String] = [:]) {
        self.raw = raw
    }

    /// Convenience initializer for a single language value.
    init(lang: Language, _ value: String) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            self.raw = [:]
        } else {
            self.raw = [lang.languageCode: trimmed]
        }
    }

    subscript(_ lang: Language) -> String? {
        get { raw[lang.languageCode] }
        set {
            let key = lang.languageCode
            if let v = newValue?.trimmingCharacters(in: .whitespacesAndNewlines),
               !v.isEmpty {
                raw[key] = v
            } else {
                raw.removeValue(forKey: key)
            }
        }
    }

    func value(fallback order: [Language]) -> String {
        for lang in order {
            if let v = self[lang], !v.isEmpty { return v }
        }
        return ""
    }
}
