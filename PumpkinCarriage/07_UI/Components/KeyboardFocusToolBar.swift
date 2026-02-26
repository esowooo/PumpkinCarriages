





import SwiftUI

struct KeyboardFocusToolbar<Field: Hashable>: ViewModifier {
    let focused: FocusState<Field?>.Binding
    let order: [Field]

    private var canGoPrev: Bool {
        guard let current = focused.wrappedValue,
              let idx = order.firstIndex(of: current) else { return false }
        return idx > 0
    }

    private var canGoNext: Bool {
        guard let current = focused.wrappedValue,
              let idx = order.firstIndex(of: current) else { return false }
        return idx < order.count - 1
    }

    private func move(_ direction: Int) {
        guard let current = focused.wrappedValue,
              let idx = order.firstIndex(of: current) else {
            focused.wrappedValue = order.first
            return
        }

        let next = idx + direction
        guard order.indices.contains(next) else { return }
        focused.wrappedValue = order[next]
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button { move(-1) } label: { Image(systemName: "chevron.up") }
                        .disabled(!canGoPrev)

                    Button { move(1) } label: { Image(systemName: "chevron.down") }
                        .disabled(!canGoNext)

                    Spacer()

                    Button { focused.wrappedValue = nil } label: { Image(systemName: "checkmark") }
                }
            }
    }
}

extension View {
    func keyboardFocusToolbar<Field: Hashable>(
        _ focused: FocusState<Field?>.Binding,
        order: [Field]
    ) -> some View {
        modifier(KeyboardFocusToolbar(focused: focused, order: order))
    }
}
