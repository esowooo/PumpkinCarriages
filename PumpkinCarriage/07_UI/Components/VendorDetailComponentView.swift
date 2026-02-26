import SwiftUI

struct VendorDetailComponentView<ButtonOne: View, ButtonTwo: View> :View {
    
    @Environment(ToastCenter.self) var toastCenter
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(\.repositories) private var repos
    @Environment(\.locale) private var locale

    let vendorSummary: VendorSummary
    let vendorDetails: VendorDetail
    let vendorProfileImages: [VendorImage]
    private var imagePaths: [String] {
        vendorProfileImages.compactMap { $0.storagePath(prefer: VendorImageUseCase.viewer) }
    }
    let onExternalLinkTap: (String) -> Void

    // header button 1,2
    @ViewBuilder let buttonOne: ButtonOne
    @ViewBuilder let buttonTwo: ButtonTwo
    
    @State private var showDescription = false
    @State private var revealInfo = false
    @State private var lastCopyAt: Date? = nil
    @State private var showCopyConfirm = false
    @State private var pendingCopyText: String? = nil
    @State private var showImageViewer = false
    @State private var selectedImageIndex: Int = 0
    @State private var selectedDescriptionLanguage: Language = .jp
    @State private var didInitDescriptionLanguage = false
    
    private var isGuest: Bool { sessionManager.authLevel == .guest }
    private var canRevealInfo: Bool { !isGuest }

    private func maskedEmail(_ email: String) -> String {
        // e.g. se***@domain.com
        let parts = email.split(separator: "@", maxSplits: 1).map(String.init)
        guard parts.count == 2 else { return "••••" }
        let user = parts[0]
        let domain = parts[1]
        let prefix = user.prefix(2)
        return "\(prefix)***@\(domain)"
    }
    
    private func phoneCountryTag(_ phone: String) -> String? {
        // Uses E.164 prefix. Keep it simple for now.
        if phone.hasPrefix("+81") { return "JP" }
        if phone.hasPrefix("+82") { return "KR" }
        return nil
    }
    
    private func maskedPhone(_ phone: String) -> String {
        // e.g. +81 09012345678 -> ******** 5678
        let digits = phone.filter { $0.isNumber || $0 == "+" }
        let suffix = digits.suffix(4)
        let hideCount = digits.count - suffix.count
        let hiddenPart = String(repeating: "•", count: hideCount)
        return "\(hiddenPart) \(suffix)"
    }

    private func requestCopy(_ text: String) {
        if let last = lastCopyAt, Date().timeIntervalSince(last) < 2.5 {
            toastCenter.show(.init(message: String(localized: "vdcv.toast.waitMoment")))
            return
        }
        pendingCopyText = text
        showCopyConfirm = true
    }

    private func confirmCopyIfNeeded() {
        guard let text = pendingCopyText else { return }
        lastCopyAt = Date()
        copyToClipboard(text)
        toastCenter.show(.init(message: String(localized: "vdcv.toast.copied")))
        pendingCopyText = nil
    }
    
    private var descriptionFallback: [Language] {
        let rawCode: String = {
            if #available(iOS 16.0, *) {
                // Locale.LanguageCode? -> String
                return locale.language.languageCode?.identifier ?? locale.identifier
            } else {
                return locale.identifier
            }
        }()

        let code = rawCode.prefix(2).lowercased()

        switch code {
        case "ko": return [.kr, .jp, .en]
        case "ja": return [.jp, .en, .kr]
        case "en": return [.en, .jp, .kr]
        default:   return [.jp, .en, .kr]
        }
    }
    
    private var descriptionLanguagesWithContent: [Language] {
        Language.allCases.filter { lang in
            guard let v = vendorDetails.description[lang] else { return false }
            return !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    private var resolvedDescriptionText: String {
        // If the selected language has content, use it; otherwise fall back to locale-based ordering.
        if let v = vendorDetails.description[selectedDescriptionLanguage],
           !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return v
        }
        return vendorDetails.description.value(fallback: descriptionFallback)
    }
    private func initialDescriptionLanguage(from available: [Language]) -> Language {
        guard available.isEmpty == false else {
            // No content in any language; keep a stable default.
            return .jp
        }
        
        // Map current UI locale to our Language enum.
        let rawCode: String = {
            if #available(iOS 16.0, *) {
                return locale.language.languageCode?.identifier ?? locale.identifier
            } else {
                return locale.identifier
            }
        }()

        let code = rawCode.prefix(2).lowercased()
        let preferred: Language
        switch code {
        case "ko": preferred = .kr
        case "ja": preferred = .jp
        case "en": preferred = .en
        default:   preferred = .jp
        }
        
        // If the preferred language exists in available, use it; otherwise use the first available.
        return available.contains(preferred) ? preferred : available[0]
    }
   
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            headerSection
            infoSection
            imageSection
            markCountSection
            //keywordSection
            descriptionSection
            mapSection
            contactSection
            
        }
        .sheet(isPresented: $showDescription) {
            DescriptionView(
                title: String(format: String(localized: "vdcv.sheet.introTitle.format"), vendorSummary.name),
                text: resolvedDescriptionText
            )
        }
        .alert(String(localized: "vdcv.alert.copy.title"), isPresented: $showCopyConfirm) {
            Button(String(localized: "vdcv.button.copy")) { confirmCopyIfNeeded() }
            Button(String(localized: "vdcv.button.cancel"), role: .cancel) { pendingCopyText = nil }
        }
        .padding(.horizontal, 15)
    }
}

// MARK: - Sections
private extension VendorDetailComponentView {
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment:.leading) {
                    Text(vendorSummary.name)
                        .font(.title2)
                        .bold()
                    Button {
                        if canRevealInfo {
                            requestCopy("\(vendorSummary.locationCountry.displayName), \(vendorSummary.locationCity.displayName), \(vendorSummary.locationDistrict), \(vendorSummary.locationDetail)")
                        } else {
                            toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToCopy")))
                        }
                    } label: {
                        HStack(spacing: 3) {
                            Text("\(vendorSummary.locationCountry.displayName), \(vendorSummary.locationCity.displayName), \(vendorSummary.locationDistrict), \(isGuest ? "*****" : vendorSummary.locationDetail)")
                                .textSelection(.disabled)
                                .privacySensitive()
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 8))
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                
                
                Spacer()
                ZStack {
                    buttonOne
                        .frame(width: 40, height: 40)
                        .opacity(isGuest ? 0.25 : 1)
                        .allowsHitTesting(!isGuest)

                    if isGuest {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToShare")))
                            }
                            .accessibilityLabel(String(localized: "vdcv.a11y.signInRequired"))
                    }
                }
                .frame(width: 40, height: 40)
                    
                ZStack {
                    buttonTwo
                        .frame(width: 40, height: 40)
                        .opacity(isGuest ? 0.25 : 1)
                        .allowsHitTesting(!isGuest)

                    if isGuest {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToUseBookmarks")))
                            }
                            .accessibilityLabel(String(localized: "vdcv.a11y.signInRequired"))
                    }
                }
                .frame(width: 40, height: 40)
            }
            
        }
    }
    
    var infoSection: some View {
        VStack(alignment: .leading) {
            Divider()
            HStack{
                Text(String(localized: "vdcv.label.category"))
                    .captionTextStyle()
                Text(vendorSummary.category.displayName)
                    .primaryTextStyle()
                Spacer()
                Text(String(localized: "vdcv.label.languages"))
                    .captionTextStyle()
                ForEach(Language.allCases, id: \.self) { lang in
                    let vendorSpeaks = vendorSummary.languages.contains(lang)
                    Text(lang.shortCode)
                        .primaryTextStyle().opacity(vendorSpeaks ? 1: 0.15)
                }
            }
        }
    }
    
    var imageSection: some View {
        
        return Group {
            if vendorProfileImages.isEmpty {
                ImagePlaceholderView(height: 240, cornerRadius: 0)
            } else {
                TabView(selection: $selectedImageIndex) {
                    ForEach(Array(vendorProfileImages.enumerated()), id: \.offset) { idx, image in
                        ImageResourceView(
                            storagePath: image.storagePath(prefer: VendorImageUseCase.carousel),
                            repository: repos.imageResolve ,
                            contentMode: .fill,
                            cornerRadius: 0,
                            placeholderHeight: 240
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)
                        .clipped()
                        .tag(idx)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedImageIndex = idx
                            showImageViewer = true
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 240)
            }
        }
        .fullScreenCover(isPresented: $showImageViewer) {
            ImageViewer(
                storagePaths: imagePaths,
                repository: repos.imageResolve,
                startIndex: min(selectedImageIndex, max(imagePaths.count - 1, 0)),
                onClose: { showImageViewer = false }
            )
        }
    }
    
    var markCountSection: some View {
        HStack {
            Label("\(vendorSummary.markCount)", systemImage: "bookmark.fill")
                .font(.title)
            Spacer()
        }
    }
    
    
    //    // Keyword
    //    var keywordSection: some View {
    //        ScrollView(.horizontal, showsIndicators: false) {
    //            HStack(spacing: 8) {
    //                ForEach(keywords ?? [], id: \.self) { keyword in
    //                    Text(keyword)
    //                        .font(.caption)
    //                        .padding(.horizontal, 8)
    //                        .padding(.vertical, 4)
    //                        .background(Color.gray.opacity(0.2))
    //                        .cornerRadius(10)
    //                }
    //            }
    //        }
    //    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            let langs = descriptionLanguagesWithContent
            let full = resolvedDescriptionText

            if langs.count >= 2 {
                Picker("", selection: $selectedDescriptionLanguage) {
                    ForEach(langs, id: \.self) { lang in
                        Text(lang.shortCode).tag(lang)                    }
                }
                .pickerStyle(.segmented)
            }

            Text(full.count > 200 ? String(full.prefix(200)) + "..." : full)
                .font(.body)

            Button(String(localized: "vdcv.button.seeMore")) {
                showDescription = true
            }
            .font(.caption)
            .foregroundColor(.highlight)
        }
        .task {
            // Initialize once so the user's manual tab choice isn't overwritten.
            guard didInitDescriptionLanguage == false else { return }
            let available = descriptionLanguagesWithContent
            selectedDescriptionLanguage = initialDescriptionLanguage(from: available)
            didInitDescriptionLanguage = true
        }
    }
    
    var mapSection: some View {
        Group {
            ZStack {
                MapView(
                    address: "\(vendorSummary.locationCountry.displayName), \(vendorSummary.locationCity.displayName), \(vendorSummary.locationDistrict), \(vendorSummary.locationDetail)"
                )
                .blur(radius: isGuest ? 10 : 0)
                .opacity(isGuest ? 0.85 : 1)
                .allowsHitTesting(!isGuest)
                
                if isGuest {
                    Color.clear
                        .contentShape(Rectangle())
                        .overlay(
                            Text(String(localized: "vdcv.text.signInToViewMap"))
                            .secondaryTextStyle()
                            .multilineTextAlignment(.center)
                            , alignment: .center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                }
            }
        }
        .frame(height: 320)
    }
    
    
    
    @ViewBuilder
    var contactSection: some View {
        let hasEmail = !(vendorDetails.contactEmail ?? "").isEmpty
        let hasPhone = !(vendorDetails.contactPhone ?? "").isEmpty
        let hasLinks = !vendorDetails.externalLinks.isEmpty

        if !hasEmail && !hasPhone && !hasLinks {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 15) {

                HStack {
                    Spacer()
                    Text(String(localized: "vdcv.section.contact"))
                        .primaryTextStyle()
                    Spacer()
                    
                    if canRevealInfo {
                        Button(revealInfo ? String(localized: "vdcv.button.hide") : String(localized: "vdcv.button.reveal")) {
                            withAnimation(.easeInOut) {
                                revealInfo.toggle()
                            }
                        }
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.vertical, 15)

                
                if let email = vendorDetails.contactEmail, !email.isEmpty {
                    let display = (revealInfo && canRevealInfo) ? email : maskedEmail(email)
                    contactRow(
                        title: String(localized: "vdcv.contact.email"),
                        content: display,
                        icon: "doc.on.doc"
                    ) {
                        if canRevealInfo {
                            requestCopy(email)
                        } else {
                            toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToCopy")))
                        }
                    }
                }

                if let phone = vendorDetails.contactPhone, !phone.isEmpty {
                    let display = (revealInfo && canRevealInfo) ? phone : maskedPhone(phone)
                    let phoneTitle = phoneCountryTag(phone).map { String(format: String(localized: "vdcv.contact.phoneWithCountry.format"), $0) } ?? String(localized: "vdcv.contact.phone")
                    contactRow(
                        title: phoneTitle,
                        content: display,
                        icon: "doc.on.doc"
                    ) {
                        if canRevealInfo {
                            requestCopy(phone)
                        } else {
                            toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToCopy")))
                        }
                    }
                }

                ForEach(vendorDetails.externalLinks) { link in
                    // Show domain but mask path/query/fragment for guests
                    let displayContent: String = {
                        if isGuest {
                            if let url = URL(string: link.url), let host = url.host {
                                // If there is any path component beyond root, show masked path
                                let hasPath = !(url.path.isEmpty || url.path == "/")
                                let hasQuery = (url.query != nil)
                                let hasFragment = (url.fragment != nil)
                                let needsMask = hasPath || hasQuery || hasFragment
                                return needsMask ? host + "/••••••" : host
                            } else {
                                // Fallback: if it's not a valid URL, mask everything except a plausible domain-like prefix
                                if let range = link.url.range(of: "/") {
                                    let domain = String(link.url[..<range.lowerBound])
                                    return domain + "/••••••"
                                } else {
                                    return "••••••"
                                }
                            }
                        } else {
                            return link.url
                        }
                    }()
                    let displayIcon = isGuest ? "lock.fill" : "arrow.up.right"

                    contactRow(
                        title: link.type.displayName,
                        content: displayContent,
                        icon: displayIcon
                    ) {
                        if isGuest {
                            toastCenter.show(.init(message: String(localized: "vdcv.toast.signInToOpenLinks")))
                        } else {
                            onExternalLinkTap(link.url)
                        }
                    }
                }
            }
            .padding(15)
            .padding(.bottom, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.background)
            )
        }
    }
    
    
    @ViewBuilder
    private func contactRow(
        title: String,
        content: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                FormFieldLabel(text: title)
                Text(content)
                    .secondaryTextStyle()
                    .textSelection(.disabled)
                    .privacySensitive()

                Spacer(minLength: 2)
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    
    
    // Info Section: Usage Rules, Info
    //    var infoSection: some View {
    //        VStack(alignment: .leading, spacing: 8) {
    //            Button {
    //                showDescription = true
    //                vendor.descriptionTitle = "Vendor Policies"
    //                vendor.descriptionText = "Return Policy: ..."
    //            } label: {
    //                Text("Policy")
    //            }
    //            .buttonStyle(PrimaryButtonStyle())
    //
    //            Button {
    //                showDescription = true
    //                vendor.descriptionTitle = "Other Notifications"
    //                vendor.descriptionText = "Please note that we try our best in providing services. However, due to ..."
    //            } label: {
    //                Text("Other Notifications")
    //            }
    //            .buttonStyle(PrimaryButtonStyle())
    //        }
    //    }
    
    
}

struct DescriptionView: View {
    
    var title = String(localized: "vdcv.desc.defaultTitle")
    var text = String(localized: "vdcv.desc.defaultBody")
    
    var body: some View {
        ScrollView {
            Spacer()
            Text(title)
                .menuTitleStyle()
                .padding(.vertical, 35)
            Text(text)
                .primaryTextStyle()
        }
        .padding(.horizontal, 15)
    }
}



#Preview {
    ScrollView{
        let session = SessionManager()
        session.currentUser = UserMockSeed.makeUsers()[1]
        //session.sessionState = .signedIn
        //session.authLevel = .authenticated
                    
        return VendorDetailComponentView(
            vendorSummary: VendorMockSeed.makeSummaries()[3],
            vendorDetails: VendorMockSeed.makeDetails()[3],
            vendorProfileImages: VendorMockSeed.makeProfiles()[3].images,
            onExternalLinkTap: { urlString in
                print("Open external link: \(urlString)")
            }, buttonOne: {
                Image(systemName: "square.and.arrow.up")
                    .primaryTextStyle()
                    .tint(.main)
            },
            buttonTwo: {
                Image(systemName: "bookmark")
                    .primaryTextStyle()
                    .tint(.main)
            }
        )
        .environment(session)

    }
    .toast()
    .environment(ToastCenter())
}

var keywords: [String]? = [
    "Keyword", "Keyword", "Keyword" ,"Keyword" ,"Keyword" ,"Keyword"
]

