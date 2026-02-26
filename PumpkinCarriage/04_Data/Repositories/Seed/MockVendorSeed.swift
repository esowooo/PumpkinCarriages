// MARK: - Mock Seed
import Foundation

enum VendorMockSeed {

    static func makeVendorImages(_ assetNames: [String]) -> [VendorImage] {
        assetNames.enumerated().map { idx, name in
            VendorImage(
                id: name,
                sortOrder: idx,
                variants: [
                    VendorImageVariant(
                        kind: .original,
                        storagePath: "asset:\(name)",
                        width: nil,
                        height: nil,
                        byteSize: nil,
                        contentType: nil,
                        checksum: nil
                    )
                ],
                createdAt: .now,
                uploadedByUserId: nil,
                status: .active,
                caption: nil
            )
        }
    }

    static func makeSummaries() -> [VendorSummary] {
        [
            VendorSummary(
                id: "studioA",
                publicId: "public_studioA",
                name: "Studio Apple",
                manager: "vendor1",
                thumbnail: VendorThumbnailRef(imageId: "studioA01", storagePath: "asset:studioA01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Gangnam-gu",
                locationDetail: "Sunreung-ro",
                status: .active,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr],
                category: .studio,
                reviewCount: 10,
                rating: 4.8,
                markCount: 98
            ),
            VendorSummary(
                id: "studioB",
                publicId: "public_studioB",
                name: "Studio Banana",
                manager: "vendor1",
                thumbnail: VendorThumbnailRef(imageId: "studioB01", storagePath: "asset:studioB01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Gangnam-gu",
                locationDetail: "Yeoksam-dong",
                status: .pending,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr, .jp, .en],
                category: .studio,
                reviewCount: 32,
                rating: 4.5,
                markCount: 48
            ),
            VendorSummary(
                id: "studioC",
                publicId: "public_studioC",
                name: "Studio Cocoa",
                manager: "vendor1",
                thumbnail: VendorThumbnailRef(imageId: "studioC01", storagePath: "asset:studioC01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Seocho-gu",
                locationDetail: "seocho-dong",
                status: .rejected,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr],
                category: .studio,
                reviewCount: 48,
                rating: 4.3,
                markCount: 0
            ),
            VendorSummary(
                id: "dressA",
                publicId: "public_dressA",
                name: "Dress Dream",
                manager: "vendor2",
                thumbnail: VendorThumbnailRef(imageId: "dressA01", storagePath: "asset:dressA01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Seocho-gu",
                locationDetail: "seocho-dong",
                status: .hidden,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr, .en],
                category: .dress,
                reviewCount: 8,
                rating: 4.8,
                markCount: 17
            ),
            VendorSummary(
                id: "dressB",
                publicId: "public_dressB",
                name: "Dress Elegance",
                manager: "vendor2",
                thumbnail: VendorThumbnailRef(imageId: "dressB01", storagePath: "asset:dressB01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Mapo-gu",
                locationDetail: "Mangwon-dong",
                status: .active,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr],
                category: .dress,
                reviewCount: 31,
                rating: 4.2,
                markCount: 46
            ),
            VendorSummary(
                id: "hmA",
                publicId: "public_hmA",
                name: "HairMake Floral",
                manager: "vendor3",
                thumbnail: VendorThumbnailRef(imageId: "hmA01", storagePath: "asset:hmA01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Jongno-gu",
                locationDetail: "Samcheong-dong",
                status: .active,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr, .jp],
                category: .hairMake,
                reviewCount: 3,
                rating: 5.0,
                markCount: 33
            ),
            VendorSummary(
                id: "hmB",
                publicId: "public_hmB",
                name: "HairMake Glam",
                manager: "vendor3",
                thumbnail: VendorThumbnailRef(imageId: "hmB01", storagePath: "asset:hmB01"),
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Songpa-gu",
                locationDetail: "Garak-dong",
                status: .active,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr],
                category: .hairMake,
                reviewCount: 99,
                rating: 4.7,
                markCount: 9
            ),
            VendorSummary(
                id: "hmC",
                publicId: "public_hmC",
                name: "HairMake Shine",
                manager: "vendor3",
                thumbnail: nil,
                locationCountry: .kr,
                locationCity: .seoul,
                locationDistrict: "Songpa-gu",
                locationDetail: "Jamsil-dong",
                status: .archived,
                createdAt: Date(),
                updatedAt: Date(),
                languages: [.kr],
                category: .hairMake,
                reviewCount: 3,
                rating: 4.4,
                markCount: 33
            )
        ]
    }

    static func makeDetails() -> [VendorDetail] {
        [
            VendorDetail(
                id: "studioA",
                contactEmail: "admin@example.com",
                contactPhone: "+8201012345678",
                description: LocalizedText(lang: .en, "We are a professional photo studio based in Seoul. We offer a wide range of services to suit all your needs."),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com"),
                    ExternalLink(type: .instagram, path: "studioapple"),
                    ExternalLink(type: .kakaoTalk, path: "studioapple")
                ]
            ),
            VendorDetail(
                id: "studioB",
                contactEmail: "admin@example.com",
                contactPhone: nil,
                description: LocalizedText(lang: .en, "We are a professional photo studio based in Seoul. We offer a wide range of services to suit all your needs."),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com"),
                    ExternalLink(type: .instagram, path: "studiobanana"),
                    ExternalLink(type: .kakaoTalk, path: "studiobanana")
                ]
            ),
            VendorDetail(
                id: "studioC",
                contactEmail: "studioC@example.com",
                contactPhone: "+8201090000000",
                description: LocalizedText(raw: [
                    Language.jp.languageCode: "日本語の説明...",
                    Language.en.languageCode: "We are a professional photo studio based in Seoul. ...",
                    Language.kr.languageCode: "한국어 설명..."
                ]),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com"),
                    ExternalLink(type: .instagram, path: "studioc"),
                    ExternalLink(type: .kakaoTalk, path: "studioc")
                ]
            ),
            VendorDetail(
                id: "dressA",
                contactEmail: "dressA@example.com",
                contactPhone: "+8101088880000",
                description: LocalizedText(raw: [
                    Language.jp.languageCode: "日本語の説明...",
                    Language.en.languageCode: "We are a professional photo studio based in Seoul. ...",
                    Language.kr.languageCode: "한국어 설명..."
                ]),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com"),
                    ExternalLink(type: .instagram, path: "dressa"),
                    ExternalLink(type: .naverMap, path: "dressa"),
                    ExternalLink(type: .x, path: "dressa"),
                    ExternalLink(type: .tiktok, path: "dressa")
                ]
            ),
            VendorDetail(
                id: "dressB",
                contactEmail: "dressB@example.com",
                contactPhone: "+8101088880001",
                description: LocalizedText(lang: .en, "We provide elegant dress that is made with high quality materials and designed with care."),
                externalLinks: [
                    ExternalLink(type: .naverMap, path: "dressB"),
                    ExternalLink(type: .x, path: "dressB"),
                    ExternalLink(type: .tiktok, path: "dressB")
                ]
            ),
            VendorDetail(
                id: "hmA",
                contactEmail: "hairmakea@example.com",
                contactPhone: "+8201070000000",
                description: LocalizedText(lang: .en, "We provide high quality services with a passion for beauty."),
                externalLinks: [
                    ExternalLink(type: .naverMap, path: "hmA"),
                    ExternalLink(type: .x, path: "hmA"),
                    ExternalLink(type: .tiktok, path: "hmA")
                ]
            ),
            VendorDetail(
                id: "hmB",
                contactEmail: "hairmakeb@example.com",
                contactPhone: "+8201070000001",
                description: LocalizedText(lang: .en, "We provide high quality services with a passion for beauty."),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com"),
                    ExternalLink(type: .instagram, path: "hmB")
                ]
            ),
            VendorDetail(
                id: "hmC",
                contactEmail: "hairmakec@example.com",
                contactPhone: "+8201070000002",
                description: LocalizedText(lang: .en, "We provide high quality services with a passion for beauty."),
                externalLinks: [
                    ExternalLink(type: .other, path: "https://www.google.com")
                ]
            )
        ]
    }

    static func makeProfiles() -> [VendorProfileImage] {
        [
            VendorProfileImage(
                id: "studioA",
                images: makeVendorImages(["studioA01","studioA02","studioA03","studioA04","studioA05","studioA06"])
            ),
            VendorProfileImage(
                id: "studioB",
                images: makeVendorImages(["studioB01","studioB02","studioB03","studioB04","studioB05","studioB06","studioB07"])
            ),
            VendorProfileImage(
                id: "studioC",
                images: makeVendorImages(["studioC01","studioC02","studioC03","studioC04","studioC05","studioC06","studioC07","studioC08","studioC09"])
            ),
            VendorProfileImage(
                id: "dressA",
                images: makeVendorImages(["dressA01","dressA02","dressA03","dressA04","dressA05","dressA06","dressA07"])
            ),
            VendorProfileImage(
                id: "dressB",
                images: makeVendorImages(["dressB01","dressB02","dressB03","dressB04"])
            ),
            VendorProfileImage(
                id: "hmA",
                images: makeVendorImages(["hmA01","hmA02","hmA03","hmA04","hmA05","hmA06","hmA07","hmA08","hmA09"])
            ),
            VendorProfileImage(
                id: "hmB",
                images: makeVendorImages(["hmB01","hmB02","hmB03","hmB04","hmB05","hmB07","hmB08"])
            ),
            VendorProfileImage(
                id: "hmC",
                images: []
            )
        ]
    }
}
