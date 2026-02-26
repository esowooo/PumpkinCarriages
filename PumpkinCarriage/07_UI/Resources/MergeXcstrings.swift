//
//
//
//import Foundation
//
//// MARK: - CLI Args
//
//struct CLI {
//    let xcstringsPath: String
//    let enMemoPath: String
//    let jaMemoPath: String
//    let koMemoPath: String
//    let dryRun: Bool
//
//    static func parse() throws -> CLI {
//        var xc: String?
//        var en: String?
//        var ja: String?
//        var ko: String?
//        var dryRun = false
//
//        var i = 1
//        let args = CommandLine.arguments
//        while i < args.count {
//            let a = args[i]
//            switch a {
//            case "--xcstrings":
//                i += 1; xc = i < args.count ? args[i] : nil
//            case "--en":
//                i += 1; en = i < args.count ? args[i] : nil
//            case "--ja":
//                i += 1; ja = i < args.count ? args[i] : nil
//            case "--ko":
//                i += 1; ko = i < args.count ? args[i] : nil
//            case "--dry-run":
//                dryRun = true
//            default:
//                break
//            }
//            i += 1
//        }
//
//        guard let xcstringsPath = xc, let enMemoPath = en, let jaMemoPath = ja, let koMemoPath = ko else {
//            throw NSError(
//                domain: "CLI",
//                code: 1,
//                userInfo: [NSLocalizedDescriptionKey:
//                    """
//                    Usage:
//                      swift Tools/merge_xcstrings.swift \
//                        --xcstrings <path/to/Localizable.xcstrings> \
//                        --en <path/to/StringMemo.swift> \
//                        --ja <path/to/StringMemoJP.swift> \
//                        --ko <path/to/StringMemoKR.swift> \
//                        [--dry-run]
//                    """
//                ]
//            )
//        }
//
//        return CLI(
//            xcstringsPath: xcstringsPath,
//            enMemoPath: enMemoPath,
//            jaMemoPath: jaMemoPath,
//            koMemoPath: koMemoPath,
//            dryRun: dryRun
//        )
//    }
//}
//
//// MARK: - Parsing "key" = "value" pairs
//
//func extractPairs(fromFile path: String) throws -> [String: String] {
//    let url = URL(fileURLWithPath: path)
//    let text = try String(contentsOf: url, encoding: .utf8)
//
//    // Matches: "some.key" = "Some Value"
//    // It will also match commented lines like: // "key" = "value"
//    let pattern = #""([^"]+)"\s*=\s*"([^"]*)""#
//    let regex = try NSRegularExpression(pattern: pattern, options: [])
//
//    let ns = text as NSString
//    let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: ns.length))
//
//    var dict: [String: String] = [:]
//    dict.reserveCapacity(matches.count)
//
//    for m in matches {
//        guard m.numberOfRanges == 3 else { continue }
//        let key = ns.substring(with: m.range(at: 1))
//        let value = ns.substring(with: m.range(at: 2))
//        dict[key] = value
//    }
//
//    return dict
//}
//
//// MARK: - JSON helpers (xcstrings is JSON)
//
//typealias JSONObject = [String: Any]
//
//func readJSON(_ path: String) throws -> JSONObject {
//    let url = URL(fileURLWithPath: path)
//    let data = try Data(contentsOf: url)
//    let obj = try JSONSerialization.jsonObject(with: data, options: [])
//    guard let json = obj as? JSONObject else {
//        throw NSError(domain: "JSON", code: 2, userInfo: [NSLocalizedDescriptionKey: "xcstrings root is not a JSON object"])
//    }
//    return json
//}
//
//func writeJSON(_ json: JSONObject, to path: String) throws {
//    let opts: JSONSerialization.WritingOptions
//    if #available(macOS 10.15, *) {
//        opts = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
//    } else {
//        opts = [.prettyPrinted]
//    }
//
//    let data = try JSONSerialization.data(withJSONObject: json, options: opts)
//    let url = URL(fileURLWithPath: path)
//    try data.write(to: url, options: [.atomic])
//}
//
//// MARK: - Merge logic
//
//func upsertLocalization(into entry: inout JSONObject, lang: String, value: String) {
//    var localizations = (entry["localizations"] as? JSONObject) ?? JSONObject()
//
//    localizations[lang] = [
//        "stringUnit": [
//            "state": "translated",
//            "value": value
//        ]
//    ]
//
//    entry["localizations"] = localizations
//}
//
//func mergeMemoPairs(
//    _ pairs: [String: String],
//    lang: String,
//    strings: inout JSONObject
//) -> Int {
//    var updated = 0
//    for (key, value) in pairs {
//        var entry = (strings[key] as? JSONObject) ?? JSONObject()
//        upsertLocalization(into: &entry, lang: lang, value: value)
//        strings[key] = entry
//        updated += 1
//    }
//    return updated
//}
//
//// MARK: - Main
//
//do {
//    let cli = try CLI.parse()
//
//    let enPairs = try extractPairs(fromFile: cli.enMemoPath)
//    let jaPairs = try extractPairs(fromFile: cli.jaMemoPath)
//    let koPairs = try extractPairs(fromFile: cli.koMemoPath)
//
//    var xc = try readJSON(cli.xcstringsPath)
//
//    // Ensure required root fields exist
//    if xc["version"] == nil { xc["version"] = "1.0" }
//    if xc["sourceLanguage"] == nil { xc["sourceLanguage"] = "en" }
//
//    var strings = (xc["strings"] as? JSONObject) ?? JSONObject()
//
//    let enCount = mergeMemoPairs(enPairs, lang: "en", strings: &strings)
//    let jaCount = mergeMemoPairs(jaPairs, lang: "ja", strings: &strings)
//    let koCount = mergeMemoPairs(koPairs, lang: "ko", strings: &strings)
//
//    xc["strings"] = strings
//
//    if cli.dryRun {
//        print("DRY RUN: would merge \(enCount) EN, \(jaCount) JA, \(koCount) KO entries into:", cli.xcstringsPath)
//    } else {
//        try writeJSON(xc, to: cli.xcstringsPath)
//        print("DONE: merged \(enCount) EN, \(jaCount) JA, \(koCount) KO entries into:", cli.xcstringsPath)
//    }
//
//} catch {
//    fputs("ERROR: \(error.localizedDescription)\n", stderr)
//    exit(1)
//}
