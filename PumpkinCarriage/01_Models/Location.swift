






import Foundation

//MARK: - Language
enum Language: String, Codable, Identifiable, CaseIterable {
    var id: Self { self }

    case jp, en, kr

    var displayName: String {
        switch self {
        case .kr: return "Korean"
        case .jp: return "Japanese"
        case .en: return "English"
        }
    }

    var languageCode: String {
        switch self {
        case .kr: return "ko"
        case .jp: return "ja"
        case .en: return "en"
        }
    }
    
    var shortCode: String {
        switch self {
        case .kr: return "KR"
        case .en: return "EN"
        case .jp: return "JP"
        }
    }
}


//MARK: - Country
enum Country: String, Codable, Identifiable, CaseIterable {
    var id: Self { self }

    case none
    case kr
    case jp

    var displayName: String {
        switch self {
        case .none: return "Not Selected"
        case .kr: return "Korea"
        case .jp: return "Japan"
        }
    }
}

enum PhoneCountryCode: String, CaseIterable, Identifiable, Codable, Hashable {
    
    case none = ""
    case jp = "+81"
    case kr = "+82"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "---"
        case .jp: return "+81 JP"
        case .kr: return "+82 KR"
        }
    }
    
    var countryCode: String {
        switch self {
        case .none: return ""
        case .jp: return "JP"
        case .kr: return "KR"
        }
    }
}

extension PhoneCountryCode {
    static func split(from full: String) -> (PhoneCountryCode, String)? {
        for code in PhoneCountryCode.allCases where code != .none {
            let prefix = code.rawValue
            if full.hasPrefix(prefix) {
                let local = String(full.dropFirst(prefix.count))
                return (code, local)
            }
        }
        return nil
    }
    
    static func splitISOCode(from full: String) -> String? {
        for code in PhoneCountryCode.allCases where code != .none {
            let prefix = code.rawValue
            if full.hasPrefix(prefix) {
                return code.countryCode
            }
        }
        return nil
    }
}



//MARK: - City
enum City: String, Codable, Identifiable, CaseIterable {
    var id: Self { self }

    case none
    
    // Korea
    case seoul
    case busan
    case incheon
    case daegu
    case daejeon
    case gwangju
    case ulsan
    case suwon
    case sejong
    case jeju

    // Japan
    case tokyo
    case yokohama
    case osaka
    case nagoya
    case sapporo
    case fukuoka
    case kyoto
    case kobe
    case hiroshima
    case sendai
    case chiba
    case saitama
    case kawasaki
    case niigata
    case kumamoto
    case kagoshima
    case naha

    var displayName: String {
        switch self {
        // Korea
        case .none: return "Not Selected"
        case .seoul: return "Seoul"
        case .busan: return "Busan"
        case .incheon: return "Incheon"
        case .daegu: return "Daegu"
        case .daejeon: return "Daejeon"
        case .gwangju: return "Gwangju"
        case .ulsan: return "Ulsan"
        case .suwon: return "Suwon"
        case .sejong: return "Sejong"
        case .jeju: return "Jeju"

        // Japan
        case .tokyo: return "Tokyo"
        case .yokohama: return "Yokohama"
        case .osaka: return "Osaka"
        case .nagoya: return "Nagoya"
        case .sapporo: return "Sapporo"
        case .fukuoka: return "Fukuoka"
        case .kyoto: return "Kyoto"
        case .kobe: return "Kobe"
        case .hiroshima: return "Hiroshima"
        case .sendai: return "Sendai"
        case .chiba: return "Chiba"
        case .saitama: return "Saitama"
        case .kawasaki: return "Kawasaki"
        case .niigata: return "Niigata"
        case .kumamoto: return "Kumamoto"
        case .kagoshima: return "Kagoshima"
        case .naha: return "Naha (Okinawa)"
        }
    }
    
    
    // Which country this city belongs to.
    var country: Country {
        switch self {
        case .none:
            return .none
            
        // Korea
        case .seoul, .busan, .incheon, .daegu, .daejeon, .gwangju, .ulsan, .suwon, .sejong, .jeju:
            return .kr
            
        // Japan
        case .tokyo, .yokohama, .osaka, .nagoya, .sapporo, .fukuoka, .kyoto, .kobe, .hiroshima, .sendai, .chiba, .saitama, .kawasaki, .niigata, .kumamoto, .kagoshima, .naha:
            return .jp
        }
    }

    // Picker options based on the selected country.
    static func pickerOptions(for country: Country, includeNone: Bool = true) -> [City] {
        var result: [City] = []
        if includeNone {
            result.append(.none)
        }

        guard country != .none else {
            return result
        }

        let filtered = City.allCases.filter { city in
            city != .none && city.country == country
        }
        result.append(contentsOf: filtered)
        return result
    }
}


//MARK: - District
enum District {
    
    static let none = "Not Selected"
    static let other = "Other"
    
    static let byCity: [City: [String]] = [
        
        // -----------------------------Korea
        .seoul: [
                "Jongno-gu", "Jung-gu", "Yongsan-gu", "Seongdong-gu", "Gwangjin-gu",
                "Dongdaemun-gu", "Jungnang-gu", "Seongbuk-gu", "Gangbuk-gu", "Dobong-gu",
                "Nowon-gu", "Eunpyeong-gu", "Seodaemun-gu", "Mapo-gu", "Yangcheon-gu",
                "Gangseo-gu", "Guro-gu", "Geumcheon-gu", "Yeongdeungpo-gu", "Dongjak-gu",
                "Gwanak-gu", "Seocho-gu", "Gangnam-gu", "Songpa-gu", "Gangdong-gu"
            ],

            .busan: [
                "Jung-gu", "Seo-gu", "Dong-gu", "Yeongdo-gu", "Busanjin-gu", "Dongnae-gu",
                "Nam-gu", "Buk-gu", "Haeundae-gu", "Saha-gu", "Geumjeong-gu", "Gangseo-gu",
                "Yeonje-gu", "Suyeong-gu", "Sasang-gu", "Gijang-gun"
            ],

            .incheon: [
                "Jung-gu", "Dong-gu", "Michuhol-gu", "Yeonsu-gu", "Namdong-gu",
                "Bupyeong-gu", "Gyeyang-gu", "Seo-gu", "Ganghwa-gun", "Ongjin-gun"
            ],

            .daegu: [
                "Jung-gu", "Dong-gu", "Seo-gu", "Nam-gu", "Buk-gu", "Suseong-gu",
                "Dalseo-gu", "Dalseong-gun", "Gunwi-gun"
            ],

            .daejeon: [
                "Dong-gu", "Jung-gu", "Seo-gu", "Yuseong-gu", "Daedeok-gu"
            ],

            .gwangju: [
                "Dong-gu", "Seo-gu", "Nam-gu", "Buk-gu", "Gwangsan-gu"
            ],

            .ulsan: [
                "Jung-gu", "Nam-gu", "Dong-gu", "Buk-gu", "Ulju-gun"
            ],

            .suwon: [
                "Jangan-gu", "Gwonseon-gu", "Paldal-gu", "Yeongtong-gu"
            ],

            .sejong: [
                "Jochiwon-eup", "Yeondong-myeon", "Yeonseo-myeon", "Jeonui-myeon",
                "Jeondong-myeon", "Sojeong-myeon", "Geumnam-myeon", "Janggun-myeon"
            ],

            .jeju: [
                "Jeju-si", "Seogwipo-si"
            ],
        
        
        // -----------------------------Japan
        // Tokyo
        .tokyo: [
            "Chiyoda", "Chuo", "Minato", "Shinjuku", "Bunkyo", "Taito",
            "Sumida", "Koto", "Shinagawa", "Meguro", "Ota", "Setagaya",
            "Shibuya", "Nakano", "Suginami", "Toshima", "Kita", "Arakawa",
            "Itabashi", "Nerima", "Adachi", "Katsushika", "Edogawa"
        ],

        // Yokohama (18 wards)
        .yokohama: [
            "Tsurumi", "Kanagawa", "Nishi", "Naka", "Minami", "Hodogaya",
            "Isogo", "Kanazawa", "Kohoku", "Totsuka", "Konan", "Asahi",
            "Midori", "Seya", "Sakae", "Izumi", "Aoba", "Tsuzuki"
        ],

        // Kawasaki (7 wards)
        .kawasaki: [
            "Kawasaki", "Saiwai", "Nakahara", "Takatsu", "Miyamae", "Tama", "Asao"
        ],

        // Saitama (10 wards)
        .saitama: [
            "Nishi", "Kita", "Omiya", "Minuma", "Chuo", "Sakura", "Urawa", "Minami", "Midori", "Iwatsuki"
        ],

        // Chiba (6 wards)
        .chiba: [
            "Chuo", "Hanamigawa", "Inage", "Wakaba", "Midori", "Mihama"
        ],

        // Niigata (8 wards)
        .niigata: [
            "Kita", "Higashi", "Chuo", "Konan", "Akiha", "Minami", "Nishi", "Nishikan"
        ],

        // Nagoya (16 wards)
        .nagoya: [
            "Chikusa", "Higashi", "Kita", "Nishi", "Nakamura", "Naka", "Showa", "Mizuho",
            "Atsuta", "Nakagawa", "Minato", "Minami", "Moriyama", "Midori", "Meito", "Tempaku"
        ],

        // Osaka (24 wards)
        .osaka: [
            "Kita", "Miyakojima", "Fukushima", "Konohana", "Chuo", "Nishi", "Minato", "Taisho",
            "Tennoji", "Naniwa", "Nishiyodogawa", "Yodogawa", "Higashiyodogawa", "Higashinari",
            "Ikuno", "Asahi", "Joto", "Tsurumi", "Abeno", "Sumiyoshi", "Higashisumiyoshi",
            "Nishinari", "Hirano", "Suminoe"
        ],

        // Kyoto (11 wards)
        .kyoto: [
            "Kita", "Kamigyo", "Sakyo", "Nakagyo", "Higashiyama", "Shimogyo",
            "Minami", "Ukyo", "Fushimi", "Yamashina", "Nishikyo"
        ],

        // Kobe (9 wards)
        .kobe: [
            "Higashinada", "Nada", "Chuo", "Hyogo", "Kita", "Nagata", "Suma", "Tarumi", "Nishi"
        ],

        // Sapporo (10 wards)
        .sapporo: [
            "Chuo", "Kita", "Higashi", "Shiroishi", "Toyohira", "Minami", "Nishi", "Atsubetsu", "Teine", "Kiyota"
        ],

        // Sendai (5 wards)
        .sendai: [
            "Aoba", "Miyagino", "Wakabayashi", "Taihaku", "Izumi"
        ],

        // Hiroshima (8 wards)
        .hiroshima: [
            "Naka", "Higashi", "Minami", "Nishi", "Asaminami", "Asakita", "Aki", "Saeki"
        ],

        // Fukuoka (7 wards)
        .fukuoka: [
            "Higashi", "Hakata", "Chuo", "Minami", "Jonan", "Sawara", "Nishi"
        ],
        
        // Kumamoto (5 wards)
        .kumamoto: [
            "Chuo", "Higashi", "Nishi", "Minami", "Kita"
        ],
    ]

    static func pickerOptions(for city: City, includeNone: Bool = true) -> [String] {
        var options: [String] = []

        let districts = byCity[city] ?? []
        options.append(contentsOf: districts)
        
        if includeNone, !options.contains(District.none) {
            options.insert(District.none, at: 0)
        }

        if !options.contains(District.other) && city != .none {
            options.append(District.other)
        }
        
        return options
    }

    static func isSupported(district: String, for city: City) -> Bool {
        guard let list = byCity[city] else { return false }
        return list.contains(district)
    }
}


enum DistrictSelection: Hashable {
    case none
    case predefined(String)
    case other(String)
}



