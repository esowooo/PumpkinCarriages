import Foundation

struct VendorForm: Equatable {

    // MARK: - UI Fields
    var publicId: String = ""
    var name: String = ""
    var manager: String = ""
    var country: Country = .none
    var city: City = .none
    var district: String = District.none
    var districtOther: String = ""
    var addressDetail: String = ""
    var email: String = ""
    var phoneCountryCode: PhoneCountryCode = .none
    var phone: String = ""
    var languages: [Language] = []
    var category: VendorCategory = .studio
    /// Description drafts per language. UI can swap a single editor by language.
    var descriptionByLang: [Language: String] = [:]
    var status: VendorStatus = .hidden

    // MARK: - Drafts
    var imageDrafts: [ImageDraft] = []
    var externalLinkDrafts: [ExternalLinkDraft] = []
    var externalLinkType: ExternalLinkType = .none

    // MARK: - ExternalLinkDraft
    struct ExternalLinkDraft: Identifiable, Hashable {
        let id: String
        var type: ExternalLinkType
        var path: String

        init(id: String = UUID().uuidString, type: ExternalLinkType, path: String = "") {
            self.id = id
            self.type = type
            self.path = path
        }
    }

    // MARK: - Prefill
    /// Prefill from split models.
    /// - summary: List/main data (always available for update flow).
    /// - detail: Optional detail payload (loaded separately for edit/detail screens).
    init(summary: VendorSummary? = nil, detail: VendorDetail? = nil) {
        guard let summary else { return }

        // Summary
        self.publicId = summary.publicId
        self.name = summary.name
        self.manager = summary.manager
        self.country = summary.locationCountry
        self.city = summary.locationCity
        self.addressDetail = summary.locationDetail
        self.languages = summary.languages
        self.category = summary.category
        self.status = summary.status

        // Detail (optional)
        self.email = detail?.contactEmail ?? ""
        self.descriptionByLang[.jp] = detail?.description[.jp] ?? ""
        self.descriptionByLang[.en] = detail?.description[.en] ?? ""
        self.descriptionByLang[.kr] = detail?.description[.kr] ?? ""

        // Phone split (optional)
        if let savedPhone = detail?.contactPhone,
           let (code, local) = PhoneCountryCode.split(from: savedPhone) {
            self.phoneCountryCode = code
            self.phone = local
        } else {
            self.phoneCountryCode = .none
            self.phone = detail?.contactPhone ?? ""
        }

        // District handling (summary)
        let savedDistrict = summary.locationDistrict.trimmingCharacters(in: .whitespacesAndNewlines)
        self.district = District.none
        self.districtOther = ""

        if self.city != .none {
            if savedDistrict.isEmpty || savedDistrict == District.none {
                // keep default
            } else if District.isSupported(district: savedDistrict, for: self.city) {
                self.district = savedDistrict
                self.districtOther = ""
            } else if savedDistrict == District.other {
                self.district = District.other
                self.districtOther = ""
            } else {
                self.district = District.other
                self.districtOther = savedDistrict
            }
        }

        // External links -> drafts (detail optional)
        self.externalLinkDrafts = (detail?.externalLinks ?? []).map {
            ExternalLinkDraft(id: $0.id, type: $0.type, path: $0.path)
        }
    }

    /// Backward-compatible convenience init for existing call sites.
    /// Note: With the split model, contact/description/links live in `VendorDetail`.
    init(vendor: VendorSummary? = nil) {
        self.init(summary: vendor, detail: nil)
    }
}

extension VendorForm {
    /// Build LocalizedText from drafts. JP required is enforced by ViewModel validation.
    func makeDescriptionLocalizedText() -> LocalizedText {
        var lt = LocalizedText()
        for (lang, text) in descriptionByLang {
            let trimmed = Validation.trimmed(text)
            if trimmed.isEmpty { continue }
            lt[lang] = trimmed
        }
        return lt
    }
}
