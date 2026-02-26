






import SwiftUI

struct VendorFilterSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var applied: VendorFilters
    @State private var draft: VendorFilters

    init(applied: Binding<VendorFilters>) {
        self._applied = applied
        self._draft = State(initialValue: applied.wrappedValue)
    }
    
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack{
                    Button {
                        dismiss()
                    } label: {
                        Text(String(localized: "vfs.button.cancel"))
                            .secondaryTextStyle()
                    }
                }
                
                Spacer()
                
                VStack{
                    Button {
                        draft.country = .none
                        draft.city = .none
                        draft.district = District.none
                        draft.languages = []
                    } label: {
                        Text(String(localized: "vfs.button.reset"))
                            .secondaryTextStyle()
                    }
                }
                
            }
            .tint(.main)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            locationSection
            languageSection
            bottomSection
        }
        .padding(.horizontal, 15)
    }
}

private extension VendorFilterSheetView {
    var locationSection: some View {
        VStack {
            HStack {
                Text(String(localized: "vfs.section.location"))
                    .captionTextStyle()
           }
            Divider()
                .padding(.bottom, 15)
            VStack (alignment: .leading, spacing: 15) {
                HStack(spacing: 35) {
                    FormFieldLabel(text: String(localized: "vfs.field.country"))
                    Picker(String(localized: "vfs.field.country"), selection: $draft.country) {
                        ForEach(Country.allCases) { c in
                            Text(c.displayName).tag(c)
                        }
                    }
                    .onChange(of: draft.country) { _, _ in
                        draft.city = .none
                        draft.district = District.none
                    }
                }
                HStack(spacing: 35) {
                    FormFieldLabel(text: String(localized: "vfs.field.city"))
                    Picker(String(localized: "vfs.field.city"), selection: $draft.city) {
                        ForEach(City.pickerOptions(for: draft.country)) { c in
                            Text(c.displayName).tag(c)
                        }
                    }
                    .disabled(draft.country == .none)
                    .onChange(of: draft.city) { _, _ in
                        draft.district = District.none
                    }
                }
                
                HStack(spacing: 35) {
                    FormFieldLabel(text: String(localized: "vfs.field.district"))
                    Picker(String(localized: "vfs.field.district"), selection: $draft.district) {
                        ForEach(District.pickerOptions(for: draft.city), id: \.self) { d in
                            Text(d).tag(d)
                        }
                    }
                    .disabled(draft.country == .none || draft.city == .none)
                }
            }
            .tint(.main)
            .padding(.horizontal, 30)
        }
    }
    
    
    private var selectedLanguageSet: Binding<Set<Language>> {
        Binding(
            get: { Set(draft.languages) },
            set: { newSet in
                // Keep a stable order for UI/summary (optional)
                draft.languages = Array(newSet).sorted { $0.displayName < $1.displayName }
            }
        )
    }
    var languageSection: some View {
        VStack {
            HStack {
                Text(String(localized: "vfs.section.language"))
                    .captionTextStyle()
           }
            Divider()
                .padding(.bottom, 15)
            
            VStack(spacing: 15) {
                HStack(alignment: .center) {
                    
                    ForEach(Language.allCases, id: \.self) { language in
                        LanguageCheckboxComponentView(
                            title: language.displayName,
                            value: language,
                            selectedValues: selectedLanguageSet
                        )
                        .padding(.trailing, 15)
                    }
                }
            }
        }
    }
    
    var bottomSection: some View {
        VStack {
            Divider()
                .background(Color.main)
                .padding(.bottom, 10)
            
            Button {
                applied = draft
                dismiss()

            } label: {
                Text(String(localized: "vfs.button.apply"))
                
            }
            .font(.system(size: 15, weight: .semibold))
            .padding(.horizontal, 30)
            .padding(.vertical, 5)
            .foregroundStyle(.main)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.main)
            )
            .padding(2)
        }
    }
}



#Preview("VendorFilterSheetView") {
    VendorFilterSheetPreviewHost()
}


private struct VendorFilterSheetPreviewHost: View {
    @State private var filters = VendorFilters()
    @State private var showFilterSheet: Bool = true

    var body: some View {
        VStack {
            Button {
                showFilterSheet.toggle()
            } label: {
                Text(String(localized: "vfs.preview.tapToShow"))
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            VendorFilterSheetView(applied: $filters)
                .presentationDetents([.fraction(0.55)])
                .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.55)))
        }
    }
}
