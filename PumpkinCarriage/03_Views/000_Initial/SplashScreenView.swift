






import SwiftUI
import Combine

struct SplashScreenView: View {
    
    let images : [String] = ["main1", "main2", "main3", "main4", "main5", "main6"]
    let vendorName : [String] = ["", "", "", "", "", ""]
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @State private var currentIndex: Int = Int.random(in: 0..<6)
    @State private var imageScale: CGFloat = 1.0
    @State private var anchor: UnitPoint = .center
    @State private var isTextVisible: Bool = false
    
    private let anchorCandidates: [UnitPoint] = [
        .center,
        .top,
        .bottom,
        .topLeading,
        .topTrailing,
        .bottomLeading,
        .bottomTrailing
    ]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(images[currentIndex])
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(imageScale, anchor: anchor)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .onAppear {
                        anchor = anchorCandidates.randomElement() ?? .center
                        
                        withAnimation(
                            .easeInOut(duration: 6)
                                .repeatForever(autoreverses: true)
                        ) {
                            imageScale = 1.05
                        }
                    }
                
                VStack {
//                    HStack {
//                        Spacer()
//                        Text(formatDate(Date()))
//                            .secondaryTitleStyle()
//                            .foregroundStyle(.white)
//                            .padding(.trailing, 24)
//                            .padding(.top, 30)
//                    }
                    Spacer()
                    Text("Pumpkin\n Carriages")
                        .primaryTitleStyle()
                        .foregroundStyle(.white)
                        .opacity(isTextVisible ? 1 : 0)
                        .animation(.easeInOut(duration: 1.5), value: isTextVisible)
                        .onAppear {
                            anchor = anchorCandidates.randomElement() ?? .center

                            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                                imageScale = 1.05
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                isTextVisible = true
                            }
                        }
                        
                    Spacer()
                    Text(vendorName[currentIndex])
                        .foregroundStyle(.white)
                        .logoTextStyle()
                        .padding(.bottom, 10)
                }
            }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    SplashScreenView()
        .environment(SessionManager())
    
}
