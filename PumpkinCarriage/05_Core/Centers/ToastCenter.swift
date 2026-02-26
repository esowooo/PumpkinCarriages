






import Foundation

struct ToastPayload: Equatable {
    let message: String
    let duration: TimeInterval
    let bottomPadding: CGFloat

    init(message: String, duration: TimeInterval = 2, bottomPadding: CGFloat = 100) {
        self.message = message
        self.duration = duration
        self.bottomPadding = bottomPadding
    }
}

@Observable
final class ToastCenter {
    var current: ToastPayload? = nil

    func show(_ payload: ToastPayload) {
        current = payload
    }

    func dismiss() {
        current = nil
    }
}
