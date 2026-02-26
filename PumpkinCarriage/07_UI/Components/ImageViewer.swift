import SwiftUI

struct ImageViewer: View {
    let storagePaths: [String]
    let repository: any ImageResolveRepository
    let startIndex: Int
    let onClose: () -> Void

    @State private var index: Int

    init(
        storagePaths: [String],
        repository: any ImageResolveRepository,
        startIndex: Int,
        onClose: @escaping () -> Void
    ) {
        self.storagePaths = storagePaths
        self.repository = repository
        self.startIndex = startIndex
        self.onClose = onClose
        _index = State(initialValue: startIndex)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $index) {
                ForEach(Array(storagePaths.enumerated()), id: \.offset) { i, path in
                    ZoomableImage(storagePath: path, repository: repository)
                        .tag(i)
                        .ignoresSafeArea()
                }
            }
            .tabViewStyle(.page)
            .ignoresSafeArea()

            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(16)
            }
        }
        .onAppear {
            OrientationLock.set([.portrait, .landscapeLeft, .landscapeRight])
        }
        .onDisappear {
            OrientationLock.set(.portrait)
        }
    }
}

private struct ZoomableImage: View {
    let storagePath: String
    let repository: any ImageResolveRepository

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1

    var body: some View {
        GeometryReader { _ in
            ImageResourceView(
                storagePath: storagePath,
                repository: repository,
                contentMode: .fit,
                cornerRadius: 0,
                placeholderHeight: nil
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let next = lastScale * value
                        scale = min(max(next, 1), 4)
                    }
                    .onEnded { _ in
                        lastScale = scale
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.easeInOut) {
                    scale = 1
                    lastScale = 1
                }
            }
        }
    }
}

#Preview {
    let repo = MockImageResolveRepository()

    return ImageViewer(
        storagePaths: ["asset:main1", "asset:studioA02", "asset:main3", "asset:studioA04"],
        repository: repo,
        startIndex: 0,
        onClose: {}
    )
}
