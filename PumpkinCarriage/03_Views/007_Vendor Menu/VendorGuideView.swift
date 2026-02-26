import SwiftUI

struct VendorGuideView: View {
    
    @Environment(\.locale) private var locale
    
    private var webLang: String {
        let code = locale.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja" // currently not serving EN web docs
        default: return "ja"
        }
    }
    
    func imageShaper(name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(height: 500)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.main, lineWidth: 6)
            )
            .padding(15)
    }
    
    var body: some View {
        VStack (spacing: 15) {
            Text(String(localized: "vgv.title.guideToManagingVendors"))
                .menuTitleStyle()
                .padding(.vertical, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    ForEach(VendorGuideCategory.allCases) { category in
                        DisclosureGroup(category.displayName) {
                            if category == .policies {
                                Text(String(localized: "vgv.guide.policies.01"))
                                    .captionTextStyle()
                                let items: [WebDocItem] = [
                                    .init(title: String(localized: "vgv.guide.policies.vendorTerms"), url: WebDocs.vendorTerms(lang: webLang)),
                                    .init(title: String(localized: "vgv.guide.policies.terms"), url: WebDocs.terms(lang: webLang)),
                                    .init(title: String(localized: "vgv.guide.policies.privacy"), url: WebDocs.privacy(lang: webLang)),
                                    .init(title: String(localized: "vgv.guide.policies.deletionRetention"), url: WebDocs.deletionRetention(lang: webLang)),
                                    .init(title: String(localized: "vgv.guide.policies.takedown"), url: WebDocs.takedown(lang: webLang)),
                                    .init(title: String(localized: "vgv.guide.policies.support"), url: WebDocs.support(lang: webLang))
                                ]
                                VStack(alignment: .leading, spacing: 15) {
                                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                        WebDocComponentView(item: item)
                                            .secondaryTextStyle()
                                    }
                                }
                                .padding(.vertical, 8)
                            } else {
                                Spacer()
                                ForEach(vendorGuides.filter { $0.guideCategory == category }) { guide in
                                    Text(guide.title)
                                        .secondaryTextStyle()
                                        .padding(.vertical, 10)
                                        .padding(.top, 15)
                                    imageShaper(name: guide.image)
                                }
                            }
                        }
                        .primaryTextStyle()
                        Divider()
                            .background(.main)
                    }
                }
                .tint(.main)
            }
        }
        .padding(.horizontal, 15)
    }
}

#Preview {
    VendorGuideView()
}


struct VendorGuide: Identifiable {
    var id = UUID()
    
    var guideCategory: VendorGuideCategory
    var title: String
    var image: String

}

enum VendorGuideCategory: CaseIterable, Identifiable {
    case register
    case reviewUpdate
    case activate
    case hide
    case delete
    case policies

    var id: String { String(describing: self) }

    var displayName: String {
        switch self {
        case .register:
            return String(localized: "vgv.category.register")
        case .reviewUpdate:
            return String(localized: "vgv.category.reviewUpdate")
        case .activate:
            return String(localized: "vgv.category.activate")
        case .hide:
            return String(localized: "vgv.category.hide")
        case .delete:
            return String(localized: "vgv.category.delete")
        case .policies:
            return String(localized: "vgv.category.policies")
        }
    }
}

let vendorGuides: [VendorGuide] = [
    VendorGuide(guideCategory: .register, title: String(localized: "vgv.guide.register.01"), image: "vendorRegister_01"),
    VendorGuide(guideCategory: .register, title: String(localized: "vgv.guide.register.02"), image: "vendorRegister_02"),
    VendorGuide(guideCategory: .register, title: String(localized: "vgv.guide.register.03"), image: "vendorRegister_03"),
    VendorGuide(guideCategory: .register, title: String(localized: "vgv.guide.register.04"), image: "vendorRegister_04"),
    VendorGuide(guideCategory: .register, title: String(localized: "vgv.guide.register.05"), image: "vendorRegister_05"),
    
    VendorGuide(guideCategory: .reviewUpdate, title: String(localized: "vgv.guide.update.01"), image: "vendorUpdate_01"),
    VendorGuide(guideCategory: .reviewUpdate, title: String(localized: "vgv.guide.update.02"), image: "vendorUpdate_02"),
    VendorGuide(guideCategory: .reviewUpdate, title: String(localized: "vgv.guide.update.03"), image: "vendorUpdate_03"),
    VendorGuide(guideCategory: .reviewUpdate, title: String(localized: "vgv.guide.update.04"), image: "vendorUpdate_04"),
    VendorGuide(guideCategory: .reviewUpdate, title: String(localized: "vgv.guide.update.05"), image: "vendorUpdate_05"),
    
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.01"), image: "vendorActivate_01"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.02"), image: "vendorActivate_02"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.03"), image: "vendorActivate_03"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.04"), image: "vendorActivate_04"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.05"), image: "vendorActivate_05"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.06"), image: "vendorActivate_06"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.07"), image: "vendorActivate_07"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.08"), image: "vendorActivate_08"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.09"), image: "vendorActivate_09"),
    VendorGuide(guideCategory: .activate, title: String(localized: "vgv.guide.activate.10"), image: "vendorActivate_10"),
    
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.01"), image: "vendorHide_01"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.02"), image: "vendorHide_02"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.03"), image: "vendorHide_03"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.04"), image: "vendorHide_04"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.05"), image: "vendorHide_05"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.06"), image: "vendorHide_06"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.07"), image: "vendorHide_07"),
    VendorGuide(guideCategory: .hide, title: String(localized: "vgv.guide.hide.08"), image: "vendorHide_08"),
    
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.01"), image: "vendorDelete_01"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.02"), image: "vendorDelete_02"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.03"), image: "vendorDelete_03"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.04"), image: "vendorDelete_04"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.05"), image: "vendorDelete_05"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.06"), image: "vendorDelete_06"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.07"), image: "vendorDelete_07"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.08"), image: "vendorDelete_08"),
    VendorGuide(guideCategory: .delete, title: String(localized: "vgv.guide.delete.09"), image: "vendorDelete_09")
]

