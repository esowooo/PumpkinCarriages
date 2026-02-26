import Foundation

struct WebDocsClient {

    enum WebDocsError: Error {
        case invalidURL(String)
        case invalidHTTPStatus(Int)
        case missingDoc(String)
        case invalidVersion(String)
    }

    func resolveURL(_ path: String) throws -> URL {
        if let url = URL(string: path), url.scheme != nil {
            return url
        }
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        guard let url = URL(string: trimmed, relativeTo: WebDocs.base) else {
            throw WebDocsError.invalidURL(path)
        }
        return url
    }

    func fetchJSON<T: Decodable>(_ type: T.Type, url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw WebDocsError.invalidHTTPStatus(http.statusCode)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func fetchRootManifest() async throws -> WebDocsModels.RootManifest {
        try await fetchJSON(WebDocsModels.RootManifest.self, url: WebDocs.rootManifest())
    }

    func fetchLegalManifestViaRoot(preferredLang: String) async throws -> WebDocsModels.LegalManifest {
        let root = try await fetchRootManifest()

        let lang = root.langs[preferredLang] != nil ? preferredLang : root.defaultLang
        guard let entry = root.langs[lang] else {
            throw WebDocsError.invalidURL("missing langs entry: \(lang)")
        }

        let url = try resolveURL(entry.legalManifestPath)
        return try await fetchJSON(WebDocsModels.LegalManifest.self, url: url)
    }

    func fetchLegalLatestVersion(preferredLang: String, docKey: String) async throws -> String {
        let manifest = try await fetchLegalManifestViaRoot(preferredLang: preferredLang)
        guard let doc = manifest.legal[docKey] else {
            throw WebDocsError.missingDoc(docKey)
        }
        return doc.latest.version
    }
}

