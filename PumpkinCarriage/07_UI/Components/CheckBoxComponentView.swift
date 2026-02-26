






import SwiftUI

struct LanguageCheckboxComponentView: View {
    let title: String
    let value: Language
    @Binding var selectedValues: Set<Language>

    private var isChecked: Bool {
        selectedValues.contains(value)
    }

    var body: some View {
        Button {
            toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isChecked ? Color.highlight : Color.main)
                    .primaryTextStyle()

                Text(title)
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }

    private func toggle() {
        if isChecked {
            selectedValues.remove(value)
        } else {
            selectedValues.insert(value)
        }
    }
}

struct CheckboxComponentView: View {
    let title: String
    @Binding var selectedValue: Bool

    var body: some View {
        Button {
            selectedValue.toggle()
        } label: {
            HStack(spacing: 8) {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: selectedValue ? "checkmark.square.fill" : "square")
                    .foregroundStyle(selectedValue ? Color.highlight : Color.main)
                    .primaryTextStyle()
            }
        }
        .buttonStyle(.plain)
    }
}


struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}


#Preview {
    StatefulPreviewWrapper(Set<Language>()) { selected in
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Language.allCases, id: \.self) { lang in
                LanguageCheckboxComponentView(
                    title: lang.displayName,
                    value: lang,
                    selectedValues: selected
                )
            }
        }
        .padding()
    }
}
