






import Foundation

//MARK: - Validation Error
enum ValidationError: Error, Equatable {
    case emptyRequiredFields
    case invalidEmailLength(min: Int)
    case invalidEmailFormat
    case invalidPasswordLength(min: Int)
    case invalidUsernameLength(min: Int, max: Int)
    case invalidUsernameCharacters
    case emptyLoginFields
    case phoneCountryCodeRequired
    case invalidPhoneDigitsOnly
    case invalidPhoneLength(min: Int)
    case invalidExternalLinkFields
    case phoneNumberRequired
    

    var title: String {
        switch self {
        case .invalidEmailLength, .invalidEmailFormat:
            return String(localized: "vld.title.invalidEmail")
        case .invalidPasswordLength:
            return String(localized: "vld.title.invalidPassword")
        case .invalidUsernameLength, .invalidUsernameCharacters:
            return String(localized: "vld.title.invalidUsername")
        case .emptyRequiredFields:
            return String(localized: "vld.title.invalid")
        case .emptyLoginFields:
            return String(localized: "vld.title.invalidInput")
        case .phoneCountryCodeRequired, .invalidPhoneDigitsOnly, .invalidPhoneLength, .phoneNumberRequired:
            return String(localized: "vld.title.invalidPhone")
        case .invalidExternalLinkFields:
            return String(localized: "vld.title.invalidExternalLink")
        }
    }

    var message: String {
        switch self {
        case .emptyRequiredFields:
            return String(localized: "vld.msg.requiredFields")
        case .invalidEmailLength(let min):
            return String(format: String(localized: "vld.msg.emailMin.format"), min)
        case .invalidEmailFormat:
            return String(localized: "vld.msg.emailFormat")
        case .invalidPasswordLength(let min):
            return String(format: String(localized: "vld.msg.passwordMin.format"), min)
        case .invalidUsernameLength(let min, let max):
            return String(format: String(localized: "vld.msg.usernameRange.format"), min, max)
        case .invalidUsernameCharacters:
            return String(localized: "vld.msg.usernameChars")
        case .emptyLoginFields:
            return String(localized: "vld.msg.loginEmpty")
        case .phoneCountryCodeRequired:
            return String(localized: "vld.msg.phoneCountryCodeRequired")
        case .invalidPhoneDigitsOnly:
            return String(localized: "vld.msg.phoneDigitsOnly")
        case .invalidPhoneLength(let min):
            return String(format: String(localized: "vld.msg.phoneMinDigits.format"), min)
        case .invalidExternalLinkFields:
            return String(localized: "vld.msg.externalLinkFields")
        case .phoneNumberRequired:
            return String(localized: "vld.msg.phoneNumberRequired")
        }
    }
}



//MARK: - Validation
enum Validation {
    // Preprocessing
    static func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func nonEmptyTrimmed(_ value: String) -> String? {
        let t = trimmed(value)
        return t.isEmpty ? nil : t
    }

    static func digitsOnly(_ value: String) -> String {
        value.filter { $0.isNumber }
    }

    static func isDigitsOnly(_ value: String) -> Bool {
        let t = trimmed(value)
        return !t.isEmpty && t.allSatisfy { $0.isNumber }
    }

    // Validation
    static func validateRequired(_ values: String...) -> ValidationError? {
        let hasEmpty = values.contains { trimmed($0).isEmpty }
        return hasEmpty ? .emptyRequiredFields : nil
    }
    
    static func validateEmail(_ e: String) -> ValidationError? {
        let email = trimmed(e)
        if let error = validateEmailLength(email) { return error }
        if let error = validateEmailFormat(email) { return error }
        return nil
    }
    
    static func validateEmailLength(_ e: String, min: Int = 5) -> ValidationError? {
        let email = trimmed(e)
        if email.count < min { return .invalidEmailLength(min: min) }
        return nil
    }
    static func validateEmailFormat(_ e: String) -> ValidationError? {
        let email = trimmed(e)
        // Requires: local@domain.tld (tld >= 2)
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email) ? nil : .invalidEmailFormat
    }

    static func validatePassword(_ password: String) -> ValidationError? {
        validatePasswordLength(password)
    }

    static func validatePasswordLength(_ password: String, min: Int = 6) -> ValidationError? {
        if password.count < min { return .invalidPasswordLength(min: min) }
        return nil
    }

    
    static func validateUsername(_ u: String) -> ValidationError? {
        let username = trimmed(u)
        if let error = validateUsernameLength(username) { return error }
        if let error = validateUsernameFormat(username) { return error }
        return nil
    }
    
    static func validateUsernameLength(_ username: String, min: Int = 4, max: Int = 30) -> ValidationError? {
        if username.count < min || username.count > max {
            return .invalidUsernameLength(min: min, max: max)
        }
        return nil
    }
    
    static func validateUsernameFormat(_ username: String) -> ValidationError? {

        let usernameRegex = "^[a-zA-Z0-9._-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        if !predicate.evaluate(with: username) {
            return .invalidUsernameCharacters
        }
        return nil
    }
    
    static func validateLoginRequired(_ u: String, _ password: String) -> ValidationError? {
        let username = trimmed(u)

        if username.isEmpty || password.isEmpty {
            return .emptyLoginFields
        }
        return nil
    }
    
    static func validateOptionalPhone(
        local: String,
        countryCode: PhoneCountryCode,
        minDigits: Int = 10
    ) -> ValidationError? {
        let t = trimmed(local)

        if t.isEmpty {
            return (countryCode == .none) ? nil : .phoneNumberRequired
        }

        guard countryCode != .none else { return .phoneCountryCodeRequired }

        guard t.allSatisfy({ $0.isNumber }) else { return .invalidPhoneDigitsOnly }

        guard t.count >= minDigits else { return .invalidPhoneLength(min: minDigits) }

        return nil
    }
    
    static func validateExternalLinks(_ links: [(type: ExternalLinkType, path: String)]) -> ValidationError? {
        guard !links.isEmpty else { return nil }

        let hasInvalid = links.contains { item in
            let pathTrim = trimmed(item.path)
            return item.type == .none || pathTrim.isEmpty
        }

        return hasInvalid ? .invalidExternalLinkFields : nil
    }
    
    // Helper: Validate ASCII/English-only for fields
    static func validateEnglishOnly(_ value: String, field: String) -> (title: String, message: String)? {
        // "English" here means ASCII-only (Roman letters/numbers/common punctuation).
        // This intentionally rejects Korean/Japanese/Chinese characters.
        for scalar in value.unicodeScalars {
            let v = scalar.value
            // Allow printable ASCII plus space (0x20...0x7E). Disallow control chars.
            if v < 0x20 || v > 0x7E {
                return (
                    title: String(format: String(localized: "vld.englishOnly.title.format"), field),
                    message: String(format: String(localized: "vld.englishOnly.msg.format"), field)
                )
            }
        }
        return nil
    }
    
}



