import SwiftUI

struct WebDocItem: Identifiable, Hashable {
    let id: String
    let title: String
    let url: URL

    init(title: String, url: URL) {
        self.title = title
        self.url = url
        self.id = url.absoluteString
    }
}

struct WebDocComponentView: View {
    let item: WebDocItem

    @State private var isExpanded: Bool = false

    // Action handling
    private enum PendingActionType { case openExternalLink, copyToClipboard }
    private struct PendingAction: Identifiable {
        let type: PendingActionType
        let url: URL
        let urlString: String
        let titleKey: String.LocalizationValue
        let messageKey: String.LocalizationValue
        var id: String { "\(type)-\(urlString)" }
    }

    private struct PresentedURL: Identifiable {
        let url: URL
        var id: String { url.absoluteString }
    }

    @State private var pendingAction: PendingAction?
    @State private var presentedURL: PresentedURL?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            docDisclosureRow(
                title: item.title,
                url: item.url,
                isExpanded: $isExpanded
            )
        }
        .animation(nil, value: isExpanded)
        .sheet(item: $presentedURL) { item in
            SafariView(url: item.url)
                .id(item.id)
                .ignoresSafeArea()
        }
        .alert(item: $pendingAction) { action in
            Alert(
                title: Text(String(localized: action.titleKey)),
                message: Text(String(localized: action.messageKey)),
                primaryButton: .cancel(Text(String(localized: "common.cancel"))),
                secondaryButton: .default(Text(String(localized: "common.ok"))) {
                    switch action.type {
                    case .openExternalLink:
                        presentedURL = PresentedURL(url: action.url)
                    case .copyToClipboard:
                        UIPasteboard.general.string = action.urlString
                    }
                }
            )
        }
    }

    @ViewBuilder
    private func docDisclosureRow(
        title: String,
        url: URL,
        isExpanded: Binding<Bool>
    ) -> some View {
        let urlString = url.absoluteString

        DisclosureGroup(isExpanded: isExpanded) {
            VStack(alignment: .leading, spacing: 20) {
                Text(urlString)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack(spacing: 10) {
                    Button {
                        pendingAction = PendingAction(
                            type: .openExternalLink,
                            url: url,
                            urlString: urlString,
                            titleKey: "setv.alert.openExternalLink.title",
                            messageKey: "setv.alert.openExternalLink.body"
                        )
                    } label: {
                        Text(String(localized: "common.open"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .background(Color.main)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    Button {
                        pendingAction = PendingAction(
                            type: .copyToClipboard,
                            url: url,
                            urlString: urlString,
                            titleKey: "setv.alert.copyToClipboard.title",
                            messageKey: "setv.alert.copyToClipboard.body"
                        )
                    } label: {
                        Text(String(localized: "common.copyLink"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .background(Color.main)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        } label: {
            Text(title)
        }
        .tint(.main)
        .transaction { $0.animation = nil }
    }
}

#Preview {
    let items: [WebDocItem] = [
        .init(title: "Vendor Terms", url: WebDocs.vendorTerms(lang: "ja")),
        .init(title: "Notice Policy", url: WebDocs.noticePolicy(lang: "ja")),
        .init(title: "Takedown", url: WebDocs.takedown(lang: "ja"))
    ]
    return VStack(alignment: .leading) {
        ForEach(items) { item in
            WebDocComponentView(item: item)
                .padding(.horizontal)
        }
    }
}
