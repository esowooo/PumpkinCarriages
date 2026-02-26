import SwiftUI
import UIKit

struct ImageResourceView: View {
    let storagePath: String?
    let repository: any ImageResolveRepository

    // Default styling (kept for backward compatibility)
    private var contentMode: ContentMode
    private var cornerRadius: CGFloat
    private var placeholderHeight: CGFloat?

    // Custom builders (when provided, callers fully control sizing/cropping)
    private let contentBuilder: ((Image) -> AnyView)?
    private let placeholderBuilder: (() -> AnyView)?

    // Backward-compatible initializer
    init(
        storagePath: String?,
        repository: any ImageResolveRepository,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = 0,
        placeholderHeight: CGFloat? = nil
    ) {
        self.storagePath = storagePath
        self.repository = repository
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.placeholderHeight = placeholderHeight
        self.contentBuilder = nil
        self.placeholderBuilder = nil
    }

    // Flexible initializer: let caller define rendering and placeholder.
    init<Content: View, Placeholder: View>(
        storagePath: String?,
        repository: any ImageResolveRepository,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.storagePath = storagePath
        self.repository = repository
        self.contentMode = .fill
        self.cornerRadius = 0
        self.placeholderHeight = nil
        self.contentBuilder = { AnyView(content($0)) }
        self.placeholderBuilder = { AnyView(placeholder()) }
    }

    var body: some View {
        if let storagePath,
           let resolved = repository.resolve(storagePath: storagePath) {
            resolvedView(resolved)
        } else {
            placeholderView
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        if let placeholderBuilder {
            placeholderBuilder()
        } else {
            ImagePlaceholderView(height: placeholderHeight, cornerRadius: cornerRadius)
        }
    }

    @ViewBuilder
    private func resolvedView(_ resource: ImageResource) -> some View {
        switch resource {
        case .asset(let name):
            render(Image(name))

        case .localFile(let url):
            if let uiImage = UIImage(contentsOfFile: url.path) {
                render(Image(uiImage: uiImage))
            } else {
                ImagePlaceholderView(
                    height: placeholderHeight,
                    cornerRadius: cornerRadius,
                    systemImageName: "exclamationmark.triangle",
                    title: String(localized: "irv.placeholder.imageNotFound")
                )
            }

        case .remote(let url):
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    placeholderView
                case .success(let image):
                    render(image)
                case .failure:
                    ImagePlaceholderView(
                        height: placeholderHeight,
                        cornerRadius: cornerRadius,
                        systemImageName: "exclamationmark.triangle",
                        title: String(localized: "irv.placeholder.failedToLoad")
                    )
                @unknown default:
                    placeholderView
                }
            }
        }
    }

    @ViewBuilder
    private func render(_ image: Image) -> some View {
        if let contentBuilder {
            contentBuilder(image)
                
        } else if contentMode == .fit {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        } else {
            image
                .resizable()
                .scaledToFill()
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }
}

#Preview {
    let repo = MockImageResolveRepository()

    VStack(spacing: 12) {
        ImageResourceView(storagePath: "asset:main1", repository: repo, contentMode: .fill, cornerRadius: 12, placeholderHeight: 140)
            .frame(height: 140)

        ImageResourceView(storagePath: "asset:studioA02", repository: repo, contentMode: .fit, cornerRadius: 12, placeholderHeight: 180)
            .frame(height: 180)

        ImageResourceView(storagePath: "asset:does_not_exist", repository: repo, contentMode: .fill, cornerRadius: 12, placeholderHeight: 120)
            .frame(height: 120)
    }
    .padding()
}


