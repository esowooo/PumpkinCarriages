import SwiftUI

struct ImagePlaceholderView: View {
    let height: CGFloat?
    let cornerRadius: CGFloat
    let systemImageName: String
    let title: String?

    init(
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 8,
        systemImageName: String = "photo",
        title: String? = nil
    ) {
        self.height = height
        self.cornerRadius = cornerRadius
        self.systemImageName = systemImageName
        self.title = title
    }

    var body: some View {
        ZStack {
            Color.gray.opacity(0.15)

            VStack(spacing: 8) {
                Image(systemName: systemImageName)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.gray)

                if let title, !title.isEmpty {
                    Text(title)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .frame(maxHeight: height == nil ? .infinity : nil)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    VStack(spacing: 12) {
        ImagePlaceholderView(height: 80)
        ImagePlaceholderView(height: 160, cornerRadius: 16, systemImageName: "exclamationmark.triangle", title: "Failed to load")
        ImagePlaceholderView()
            .frame(height: 240)
    }
    .padding()
}
