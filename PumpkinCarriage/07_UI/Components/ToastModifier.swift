






import SwiftUI

// MARK: - Global Toast Host (ToastCenter-driven)
private struct ToastModifier: ViewModifier {
    @Environment(ToastCenter.self) private var toastCenter
    
    @State private var dismissTask: Task<Void, Never>? = nil
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let payload = toastCenter.current {
                    Text(payload.message)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .transition(.opacity)
                        .padding(.bottom, payload.bottomPadding)
                        .zIndex(1)
                        .task {
                            scheduleAutoDismiss(for: payload)
                        }
                }
            }
            .animation(.easeInOut, value: toastCenter.current)
            .onChange(of: toastCenter.current, initial: true) { _, newValue in
                dismissTask?.cancel()
                dismissTask = nil
                
                if let payload = newValue {
                    scheduleAutoDismiss(for: payload)
                }
            }
    }
    
    private func scheduleAutoDismiss(for payload: ToastPayload) {
        dismissTask?.cancel()
        
        let duration = payload.duration.isFinite ? max(0, payload.duration) : 0
        let nanos = UInt64(duration * 1_000_000_000)
        
        dismissTask = Task {
            do {
                try await Task.sleep(nanoseconds: nanos)
            } catch {
                return
            }
            
            guard !Task.isCancelled else { return }
            await MainActor.run {
                withAnimation(.easeInOut) {
                    toastCenter.dismiss()
                }
            }
        }
    }
}

extension View {
    func toast() -> some View {
        modifier(ToastModifier())
    }
}


#Preview("Toast – long message") {
    ToastPreviewHost(message: "Signed in successfully. Welcome back!")
        .environment(ToastCenter())
}

private struct ToastPreviewHost: View {
    
    @Environment(ToastCenter.self) private var toastCenter

    var message: String = "Sign in Successful"

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Button((toastCenter.current == nil) ? "Show Toast" : "Hide Toast") {
                    if toastCenter.current == nil {
                        withAnimation(.easeInOut) {
                            toastCenter.show(ToastPayload(message: self.message))
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            toastCenter.dismiss()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                Text("Toast will auto-dismiss")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .toast()
    }
}
