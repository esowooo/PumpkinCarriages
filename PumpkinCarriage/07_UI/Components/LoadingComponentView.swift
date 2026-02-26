






import SwiftUI

struct LoadingComponentView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            ProgressView()
                .tint(.white)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingComponentView()
}
