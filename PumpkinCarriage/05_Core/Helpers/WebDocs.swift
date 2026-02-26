import Foundation

enum WebDocs {
    static let base = URL(string: "https://pumpkincarriages.com")!

    // MARK: - Root manifests
    static func rootManifest() -> URL {
        base.appendingPathComponent("manifest.json")
    }

    static func legalManifest(lang: String) -> URL {
        path([lang, "legal", "manifest.json"])
    }

    // MARK: - Helpers
    private static func path(_ components: [String]) -> URL {
        components.reduce(base) { $0.appendingPathComponent($1) }
    }

    // MARK: - Legal docs (latest)
    static func terms(lang: String) -> URL { path([lang, "legal", "terms"]) }
    static func privacy(lang: String) -> URL { path([lang, "legal", "privacy"]) }
    static func privacyChoices(lang: String) -> URL { path([lang, "legal", "privacy-choices"]) }
    static func deletionRetention(lang: String) -> URL { path([lang, "legal", "deletion-retention"]) }
    static func vendorTerms(lang: String) -> URL { path([lang, "legal", "vendor-terms"]) }
    static func takedown(lang: String) -> URL {path([lang, "legal", "takedown"])}
    static func thirdParty(lang: String) -> URL { path([lang, "legal", "third-party"]) }
    static func openSource(lang: String) -> URL { path([lang, "legal", "open-source"]) }
    static func noticePolicy(lang: String) -> URL { path([lang, "legal", "notice-policy"]) }
    static func legalChangelog(lang: String) -> URL { path([lang, "legal", "changelog"]) }

    // MARK: - Support / Notice
    static func support(lang: String) -> URL { path([lang, "support"]) }
    static func notice(lang: String) -> URL { path([lang, "notice"]) }
    static func faq(lang: String) -> URL { path([lang, "help", "faq"]) }
    
}

enum WebDocsModels {

    struct RootManifest: Decodable {
        let schemaVersion: Int
        let service: String
        let defaultLang: String
        let langs: [String: RootLang]

        struct RootLang: Decodable {
            let legalManifestPath: String
        }
    }

    struct LegalManifest: Decodable {
        let schemaVersion: Int
        let lang: String
        let service: String
        let legal: [String: ManifestDoc]

        struct ManifestDoc: Decodable {
            let latest: Latest

            struct Latest: Decodable {
                let version: String
                let url: String
                let archiveListUrl: String?
                let archiveUrl: String?
            }
        }
    }
}
