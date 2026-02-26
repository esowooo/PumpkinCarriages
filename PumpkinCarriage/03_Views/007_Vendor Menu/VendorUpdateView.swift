






import SwiftUI
import _PhotosUI_SwiftUI

fileprivate enum VendorUpdateField: Hashable {
    case vendorName
    case description
    case contactEmail
    case contactPhone
    case districtOther
    case addressDetail
    case externalLink(String) // draft.id
}

struct VendorUpdateView: View {
    @Environment(SessionManager.self) var sessionManager

    let vendorSummary: VendorSummary?

    init(vendorSummary: VendorSummary? = nil) {
        self.vendorSummary = vendorSummary
    }

    @State private var viewModel: VendorUpdateViewModel? = nil
    @State private var imagePicker = ImagePicker()
    @FocusState private var isFocused: VendorUpdateField?

    var body: some View {
        Group {
            if let viewModel {
                VendorUpdateContent(
                    viewModel: viewModel,
                    imagePicker: $imagePicker,
                    isFocused: $isFocused
                )
                .overlay {
                    if viewModel.isLoadingVendor {
                        ZStack {
                            Color.black.opacity(0.15).ignoresSafeArea()
                            ProgressView()
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .task(id: vendorSummary?.id) {
            let targetId = vendorSummary?.id
            if viewModel == nil || viewModel?.vendorSummary?.id != targetId {
                let vm = VendorUpdateViewModel()
                vm.checkAccessPermission(user: sessionManager.currentUser)

                // Provisional render (fast) if parent already has a summary
                if let vendorSummary {
                    vm.applyInitialSummary(vendorSummary)
                    await vm.loadLatestVendorForEditing()
                    vm.denyVendorAccess()
                }

                viewModel = vm
            }
        }
    }
}

struct VendorUpdateContent: View {

    @Bindable var viewModel: VendorUpdateViewModel
    @Binding var imagePicker: ImagePicker
    fileprivate let isFocused: FocusState<VendorUpdateField?>.Binding

    @Environment(\.dismiss) private var dismiss
    @State private var showDiscardConfirm: Bool = false
    @State private var selectedDescLang: Language = .jp

    private var mode: VendorMode {
        viewModel.vendorSummary == nil ? .register : .update
    }

    private enum VendorMode {
        case register
        case update
    }
    
    private var focusOrder: [VendorUpdateField] {
        var order: [VendorUpdateField] = [
            .vendorName
        ]

        if viewModel.form.district == District.other {
            order.append(.districtOther)
        }
        
        order.append(contentsOf: [
            .addressDetail,
            .description,
            .contactEmail,
            .contactPhone
        ])

        order.append(contentsOf: viewModel.form.externalLinkDrafts.map { .externalLink($0.id) })

        return order
    }

    private func selectedLanguagesGet() -> Set<Language> {
        Set(viewModel.form.languages)
    }

    private func selectedLanguagesSet(_ newSet: Set<Language>) {
        viewModel.form.languages = Array(newSet)
    }

    private var selectedLanguageSet: Binding<Set<Language>> {
        Binding(get: selectedLanguagesGet, set: selectedLanguagesSet)
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused.wrappedValue = nil
                }

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    if mode == .update, viewModel.vendorSummary != nil,
                       viewModel.vendorSummary?.status == .active {
                        updateNotificationSection
                    }
                    languageNotificationSection
                    basicInfoSection
                    locationSection
                    languagesSection
                    descriptionSection
                    contactSection
                    externalLinksSection
                    imagesSection
                    submitSection
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .onTapGesture { isFocused.wrappedValue = nil }
            .scrollDismissesKeyboard(.interactively)
            .keyboardFocusToolbar(isFocused, order: focusOrder)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if viewModel.hasChanges {
                        showDiscardConfirm = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Label(String(localized: "vuv.nav.back"), systemImage: "chevron.left")
                }
            }
        }
        .alert(String(localized: "vuv.discard.title"), isPresented: $showDiscardConfirm) {
            Button(String(localized: "vuv.discard.keepEditing"), role: .cancel) { }
            Button(String(localized: "vuv.discard.discard"), role: .destructive) {
                dismiss()
            }
        } message: {
            Text(String(localized: "vuv.discard.message"))
        }
        .alert(String(localized: "vuv.updateConfirm.title"), isPresented: $viewModel.showUpdateConfirm) {
            Button(String(localized: "vuv.button.cancel"), role: .cancel) { }
            Button(String(localized: "vuv.button.confirm")) {
                viewModel.submit()
            }
        } message: {
            Text(String(localized: "vuv.updateConfirm.message"))
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "vuv.button.ok")) {
                if viewModel.shouldDismissOnAlert {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }

    private var headerTitle: String {
        mode == .register
        ? String(localized: "vuv.title.register")
        : String(localized: "vuv.title.update")
    }

    private var submitButtonTitle: String {
        if viewModel.isSubmitting {
            return mode == .register
            ? String(localized: "vuv.submit.submitting")
            : String(localized: "vuv.submit.saving")
        }
        return mode == .register
        ? String(localized: "vuv.submit.submit")
        : String(localized: "vuv.submit.saveChanges")
    }

    //MARK: - Header
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            Text(headerTitle)
                .menuTitleStyle()
                .foregroundStyle(.main)

            Spacer()
        }
    }

    //MARK: - Basic Info
    @ViewBuilder
    private var basicInfoSection: some View {
        FormSection(title: String(localized: "vuv.section.basicInfo")) {
            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.name"))
                TextField(String(localized: "vuv.placeholder.vendorNameEng"), text: $viewModel.form.name)
                    .textFieldStyle(BaseFormTextFieldStyle())
                    .focused(isFocused, equals: .vendorName)
            }

            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.category"))
                Picker("", selection: $viewModel.form.category) {
                    ForEach(VendorCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                        Text(category.displayName)
                            .tag(category)
                    }
                }
                .labelsHidden()
                .tint(.main)
                .onTapGesture { isFocused.wrappedValue = nil }
            }
        }
    }

    //MARK: - Notification Card
    @ViewBuilder
    private var updateNotificationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.orange.opacity(0.9))
                Text(String(localized: "vuv.notice.title"))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.main)
            }

            Text(String(localized: "vuv.notice.body"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.highlight.opacity(0.08))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.highlight.opacity(0.5), lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private var languageNotificationSection: some View {
        VStack(spacing: 10) {
            Text(String(localized: "vuv.notice.englishRequired"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    //MARK: - Location
    @ViewBuilder
    private var locationSection: some View {
        LocationSectionView(
            form: $viewModel.form,
            isFocused: isFocused
        )
    }

    //MARK: - Languages
    @ViewBuilder
    private var languagesSection: some View {
        FormSection(title: String(localized: "vuv.section.languages")) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Language.allCases, id: \.self) { language in
                    LanguageCheckboxComponentView(
                        title: language.displayName,
                        value: language,
                        selectedValues: selectedLanguageSet
                    )
                }
            }
        }
    }

    //MARK: - Description
    @ViewBuilder
    private var descriptionSection: some View {
        let supported: [Language] =  Language.allCases

        FormSection(title: String(localized: "vuv.section.description")) {
            Text("vuv.section.description.subtitle")
                .captionTextStyle()
            Picker("", selection: $selectedDescLang) {
                ForEach(supported, id: \.self) { lang in
                    Text(lang.shortCode).tag(lang)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            TextEditor(text: Binding(
                get: { viewModel.form.descriptionByLang[selectedDescLang] ?? "" },
                set: { viewModel.form.descriptionByLang[selectedDescLang] = $0 }
            ))
            .frame(height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary.opacity(0.3))
            )
            .focused(isFocused, equals: .description)
        }
    }

    //MARK: - Contact
    @ViewBuilder
    private var contactSection: some View {
        FormSection(title: String(localized: "vuv.section.contactOptional")) {
            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.email"))
                TextField(String(localized: "vuv.placeholder.email"), text: $viewModel.form.email)
                    .textFieldStyle(EmailTextFieldStyle())
                    .focused(isFocused, equals: .contactEmail)
            }

            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.phone"))
                Picker("", selection: $viewModel.form.phoneCountryCode) {
                    ForEach(PhoneCountryCode.allCases) { code in
                        Text(code.displayName)
                            .tag(code)
                    }
                }
                .labelsHidden()
                .tint(.main)
                .frame(alignment: .leading)
                .onTapGesture { isFocused.wrappedValue = nil }

                TextField(String(localized: "vuv.placeholder.phone"), text: $viewModel.form.phone)
                    .textFieldStyle(PhoneTextFieldStyle())
                    .focused(isFocused, equals: .contactPhone)
            }
        }
    }

    //MARK: - External Link (Optional)
    @ViewBuilder
    private var externalLinksSection: some View {
        ExternalLinksSectionView(
            form: $viewModel.form,
            isFocused: isFocused,
            onAdd: {
                isFocused.wrappedValue = nil
                viewModel.addExternalLinkDraft()
            },
            onRemove: { id in
                isFocused.wrappedValue = nil
                viewModel.removeExternalLinkDraft(id: id)
            }
        )
    }

    //MARK: - Image
    @ViewBuilder
    private var imagesSection: some View {
        ImagesSectionView(
            imagePicker: $imagePicker,
            isFocused: isFocused,
            items: viewModel.imageItems,
            drafts: viewModel.form.imageDrafts,
            thumbnailItemId: viewModel.thumbnailItemId,
            maxImageCount: 7,
            onSetThumbnail: { viewModel.setThumbnail(itemId: $0) },
            onRemove: { viewModel.removeImage(itemId: $0) },
            onMove: { fromId, toId in
                viewModel.moveImage(fromId: fromId, toId: toId)
            },
            onDraftsChange: { newDrafts in
                viewModel.attachImages(newDrafts)
            }
        )
        .padding(.bottom, 80)
    }

    //MARK: - Submit Button
    @ViewBuilder
    private var submitSection: some View {
        let isLoadingVendor = (mode == .update && viewModel.vendorSummary == nil)

        Button {
            if mode == .update, viewModel.vendorSummary?.status == .active {
                viewModel.showUpdateConfirm = true
            } else {
                viewModel.submit()
            }
        } label: {
            if viewModel.isSubmitting {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Text(submitButtonTitle)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
        .overlay {
            if viewModel.isSubmitting || isLoadingVendor || viewModel.hasChanges == false {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.black.opacity(0.10))
            }
        }
        .opacity((viewModel.isSubmitting || isLoadingVendor || viewModel.hasChanges == false) ? 0.65 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: viewModel.hasChanges)
        .disabled(viewModel.isSubmitting || isLoadingVendor || viewModel.hasChanges == false)
    }

}




private struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .captionTextStyle()
            Divider()
            content
        }
    }
}


private struct ExternalLinksSectionView: View {
    @Binding var form: VendorForm
    fileprivate let isFocused: FocusState<VendorUpdateField?>.Binding

    let onAdd: () -> Void
    let onRemove: (String) -> Void

    var body: some View {
        FormSection(title: String(localized: "vuv.section.externalLinkOptional")) {
            VStack(alignment: .leading, spacing: 15) {
                headerRow
                linkFields
            }
        }
    }

    private var headerRow: some View {
        HStack {
            FormFieldLabel(text: String(localized: "vuv.field.linkType"))

            Picker("", selection: $form.externalLinkType) {
                ForEach(ExternalLinkType.allCases, id: \.self) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .frame(width: 140, alignment: .leading)
            .labelsHidden()
            .tint(.main)

            Spacer()

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .secondaryTextStyle()
                    .foregroundStyle(.white)
                    .padding(2)
                    .frame(width: 20, height: 20)
                    .background(.main)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .disabled(form.externalLinkDrafts.count >= 5)
        }
    }

    private var linkFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach($form.externalLinkDrafts) { $draft in
                HStack {
                    Text(draft.type == .other ? String(localized: "vuv.link.other") : draft.type.baseURL)
                        .font(.system(size: 12))
                        .foregroundStyle(.main)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    TextField(String(localized: "vuv.placeholder.linkDetails"), text: $draft.path)
                        .textFieldStyle(WebLinkTextFieldStyle())
                        .focused(isFocused, equals: .externalLink(draft.id))

                    Button {
                        onRemove(draft.id)
                    } label: {
                        Image(systemName: "minus")
                            .secondaryTextStyle()
                            .foregroundStyle(.white)
                            .padding(2)
                            .frame(width: 20, height: 20)
                            .background(.main)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
}

private struct LocationSectionView: View {
    @Binding var form: VendorForm
    fileprivate let isFocused: FocusState<VendorUpdateField?>.Binding
    private var countrySelection: Binding<Country> {
        Binding(
            get: { form.country },
            set: { newValue in
                form.country = newValue
                form.city = .none
                form.district = District.none
                form.districtOther = ""
                isFocused.wrappedValue = nil
            }
        )
    }

    private var citySelection: Binding<City> {
        Binding(
            get: { form.city },
            set: { newValue in
                form.city = newValue
                form.district = District.none
                form.districtOther = ""
                isFocused.wrappedValue = nil
            }
        )
    }

    var body: some View {
        FormSection(title: String(localized: "vuv.section.location")) {
            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.country"))
                Picker("", selection: countrySelection) {
                    ForEach(Country.allCases, id: \.self) { country in
                        Text(country.displayName).tag(country)
                    }
                }
                .labelsHidden()
                .tint(.main)
                .onTapGesture { isFocused.wrappedValue = nil }
            }

            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.city"))
                Picker("", selection: citySelection) {
                    ForEach(City.pickerOptions(for: form.country, includeNone: true), id: \.self) { city in
                        Text(city.displayName).tag(city)
                    }
                }
                .labelsHidden()
                .tint(.main)
                .onTapGesture { isFocused.wrappedValue = nil }
            }

            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.district"))
                Picker("", selection: $form.district) {
                    ForEach(District.pickerOptions(for: form.city, includeNone: true), id: \.self) { district in
                        if district == District.other {
                            Text(String(format: String(localized: "vuv.district.manualInput.format"), district))
                                .tag(district)
                        } else {
                            Text(district)
                                .tag(district)
                        }
                    }
                }
                .labelsHidden()
                .tint(.main)
                .onTapGesture { isFocused.wrappedValue = nil }
            }

            if form.district == District.other {
                HStack {
                    FormFieldLabel(text: String(localized: "vuv.field.districtOther"))
                    TextField(String(localized: "vuv.placeholder.districtEng"), text: $form.districtOther)
                        .textFieldStyle(AddressDetailTextFieldStyle())
                        .focused(isFocused, equals: .districtOther)
                }
            }

            HStack {
                FormFieldLabel(text: String(localized: "vuv.field.street"))
                TextField(String(localized: "vuv.placeholder.streetEng"), text: $form.addressDetail)
                    .textFieldStyle(AddressDetailTextFieldStyle())
                    .focused(isFocused, equals: .addressDetail)
            }
        }
    }
}

private struct ImagesSectionView: View {
    @Environment(\.repositories) private var repos

    @Binding var imagePicker: ImagePicker
    @State private var draggingId: String? = nil
    @State private var targetId: String? = nil
    @State private var deleteTargetId: String? = nil
    @State private var showDeleteConfirm: Bool = false
    fileprivate let isFocused: FocusState<VendorUpdateField?>.Binding

    // Editor state from ViewModel
    let items: [ImageSlot]
    let drafts: [ImageDraft]
    let thumbnailItemId: String?
    let maxImageCount: Int
    let onSetThumbnail: (String) -> Void
    let onRemove: (String) -> Void
    let onMove: (_ fromId: String, _ toId: String) -> Void
    let onDraftsChange: ([ImageDraft]) -> Void

    private var remainingCapacity: Int { max(0, maxImageCount - items.count) }

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        FormSection(title: String(localized: "vuv.section.imagesOptional")) {
            HStack {
                Spacer()
                PhotosPicker(
                    selection: $imagePicker.selectedItems,
                    maxSelectionCount: remainingCapacity,
                    matching: .images
                ) {
                    FormFieldLabel(text: String(localized: "vuv.button.add"))
                        .padding(.bottom, 10)
                }
            }

            if items.isEmpty {
                HStack {
                    Spacer()
                    Text(String(localized: "vuv.images.none"))
                        .captionTextStyle()
                    Spacer()
                }
                .padding(.bottom, 25)
            } else {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                    ForEach(items) { item in
                        imageCell(for: item)
                            .draggable(item.id) {
                                dragPreview(for: item.id)
                            }
                            .dropDestination(for: String.self) { _, _ in
                                draggingId = nil
                                targetId = nil
                                return true
                            } isTargeted: { isTargeted in
                                if isTargeted {
                                    targetId = item.id
                                    if let fromId = draggingId,
                                       fromId != item.id {
                                        withAnimation(.bouncy) {
                                            onMove(fromId, item.id)
                                        }
                                    }
                                } else {
                                    if targetId == item.id { targetId = nil }
                                }
                            }
                    }
                }
            }
            (
                Text(String(localized: "vuv.images.main"))
                + Text(Image(systemName: "bookmark.fill"))
                + Text(String(localized: "vuv.images.thumbnailHint"))
            )
            .captionTextStyle()
        }
        .alert(String(localized: "vuv.images.remove.title"), isPresented: $showDeleteConfirm) {
            Button(String(localized: "vuv.button.cancel"), role: .cancel) {
                deleteTargetId = nil
            }
            Button(String(localized: "vuv.button.remove"), role: .destructive) {
                if let id = deleteTargetId {
                    onRemove(id)
                }
                deleteTargetId = nil
            }
        } message: {
            Text(String(localized: "vuv.images.remove.msg"))
        }
        .onChange(of: imagePicker.finishedGeneration) { _, finished in
            guard let finished,
                  imagePicker.selectedItems.isEmpty == false,
                  finished == imagePicker.currentGeneration else { return }

            let draftsSnapshot = imagePicker.imageDrafts
            onDraftsChange(draftsSnapshot)

            imagePicker.selectedItems = []
        }
    }

    // MARK: - Cell
    @ViewBuilder
    private func imageCell(for item: ImageSlot) -> some View {
        let isThumbnail = (item.id == thumbnailItemId)
        let isDragging = (draggingId == item.id)

        ZStack(alignment: .topTrailing) {
            Color.clear
                .aspectRatio(1, contentMode: .fill)
                .overlay {
                    cellImage(for: item)
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topLeading) {
                    if isThumbnail {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.highlight)
                            .padding(.horizontal, 8)
                            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                            .offset(y: -3)
                    }
                }
                .opacity(isDragging ? 0.65 : 1.0)
            Menu {
                Button {
                    isFocused.wrappedValue = nil
                    onSetThumbnail(item.id)
                } label: {
                    Label(isThumbnail ? String(localized: "vuv.images.mainLabel") : String(localized: "vuv.images.setMain"),
                          systemImage: isThumbnail ? "bookmark.fill" : "bookmark")
                }
                .disabled(isThumbnail)
                Divider()
                Button(role: .destructive) {
                    isFocused.wrappedValue = nil
                    deleteTargetId = item.id
                    showDeleteConfirm = true
                } label: {
                    Label(String(localized: "vuv.button.remove"), systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.main)
                    .padding(4)
                    .background(.white.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .padding(.top, 6)
            .padding(.trailing, 3)
        }
    }

    @ViewBuilder
    private func cellImage(for item: ImageSlot) -> some View {
        switch item.source {
        case .draft(let draftId):
            if let draft = drafts.first(where: { $0.id == draftId }) {
                Image(uiImage: draft.uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholderCell(title: String(localized: "vuv.placeholder.loading"))
            }
        case .existing(imageId: _):
            ImageResourceView(
                storagePath: item.preferredStoragePath,
                repository: repos.imageResolve,
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                }, placeholder: {
                    placeholderCell(title: String(localized: "vuv.placeholder.loading"))
                }
            )
        }
    }

    private func placeholderCell(title: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private func dragPreview(for id: String) -> some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .frame(width: 100, height: 100)
            .overlay {
                Text(String(localized: "vuv.drag.move"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .onAppear {
                draggingId = id
                targetId = nil
            }
    }
}


// Register Mode
//#Preview("VendorUpdateView - Register") {
//    let session = SessionManager()
//    session.sessionState = .signedIn
//    session.authLevel = .authenticated
//    session.currentUser = users[1]
//
//    let imageUploadService = DefaultImageUploadService(uploadRepo: MockImageUploadRepository())
//
//    return VendorUpdateView(
//        vendorId: nil,
//        imageUploadService: imageUploadService
//    )
//    .environment(session)
//}

// Update Mode
#Preview("VendorUpdateView - Update") {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.authLevel = .authenticated
    session.currentUser = UserMockSeed.makeUsers()[2]

    let repos = Repositories.shared
    let services = Services.shared

    let vendor = VendorMockSeed.makeSummaries()[0]

    return VendorUpdateView(vendorSummary: vendor)
        .environment(session)
        .environment(\.repositories, repos)
        .environment(\.services, services)
}
