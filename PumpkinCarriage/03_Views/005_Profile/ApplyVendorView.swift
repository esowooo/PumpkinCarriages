import SwiftUI

struct ApplyVendorView: View {
    
    //@Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter

    let userId: String

    @FocusState private var regFocused: RegFocus?
    @FocusState private var eviFocused: EviFocus?

    private enum RegFocus: Hashable {
        case applicantName, role, email, phone, businessName, businessCategory, message
    }

    private enum EviFocus: Hashable {
        case emailHint, emailURL
        case channelURL, channelDetail
    }

    private var regOrder: [RegFocus] {
        [.applicantName, .role, .email, .phone, .businessName, .businessCategory, .message]
    }

    private var eviOrder: [EviFocus] {
        switch viewModel.form.selectedEvidenceMethod {
        case .officialEmail: return [.emailHint, .emailURL]
        case .codePost:      return [.channelURL, .channelDetail]
        }
    }
    
    private var tabSelection: Binding<ApplyVendorTab> {
        Binding(
            get: { viewModel.selectedTab },
            set: { newTab in
                if newTab == .evidence, viewModel.applicationExists == false {
                    viewModel.selectedTab = .registration
                    toastCenter.show(.init(message: String(localized: "av.toast.completeRegistrationFirst")))
                    regFocused = nil
                    eviFocused = nil
                    return
                }

                viewModel.selectedTab = newTab
                regFocused = nil
                eviFocused = nil
            }
        )
    }
    
    @State private var viewModel: ApplyVendorViewModel
    private var statusColor: Color {
        guard let status = viewModel.application?.status else { return .secondary }
        switch status {
        case .initial: return .gray
        case .pending: return .yellow
        case .approved: return .green
        case .rejected: return .red
        case .archived: return .secondary
        }
    }

    init(userId: String) {
        self.userId = userId
        _viewModel = State(initialValue: ApplyVendorViewModel(userId: userId))

    }

    var body: some View {
        VStack(spacing: 10) {
            statusHeader
                .padding(.horizontal, 20)
            Spacer(minLength: 0)
            if !viewModel.canSubmit{
                Text(String(localized: "av.text.waitUntilReviewed"))
                    .captionTextStyle()
            }

            if viewModel.canSubmit{
                Picker("", selection: tabSelection) {
                    Text(String(localized: "av.tab.registration")).tag(ApplyVendorTab.registration)
                    Text(String(localized: "av.tab.evidence")).tag(ApplyVendorTab.evidence)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .disabled(viewModel.canSubmit)
                ScrollViewReader { proxy in
                    ScrollView {
                        Color.clear
                            .frame(height: 0)
                            .id("applyVendorTop")

                        Group {
                            switch viewModel.selectedTab {
                            case .registration:
                                registrationTab
                            case .evidence:
                                evidenceTab
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    .onChange(of: viewModel.selectedTab) { _, _ in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("applyVendorTop", anchor: .top)
                            regFocused = nil
                            eviFocused = nil
                        }
                    }
                }
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "av.button.ok"), role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        .onAppear {
            viewModel.load()
        }
    }

    // MARK: - Header
    private var statusHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)

                Text(String(format: String(localized: "av.status.format"), viewModel.statusTitle))
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

            }

            if let subtitle = viewModel.statusSubtitle {
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let rejection = viewModel.rejectionSummary {
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(localized: "av.rejectionReason.title"))
                        .font(.system(size: 13, weight: .semibold))
                    Text(rejection)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(lineWidth: 1)
                .foregroundStyle(.main)
        }
    }
    
    
    private struct FormRow<Content: View>: View {
        let title: String
        let content: Content

        init(_ title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }

        var body: some View {
            HStack(alignment: .center) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 2.5)
                    .frame(width: 80)
                    .background(Color.main)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                content
            }
        }
    }
    
    // MARK: - Tabs
    private var registrationTab: some View {
        VStack(alignment: .leading, spacing: 15) {

            // Section Header
            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "av.section.applicant")).captionTextStyle()
                Divider()
            }
            .padding(.top, 10)

            FormRow(String(localized: "av.field.name")) {
                TextField(String(localized: "av.placeholder.applicantNameRequired"), text: $viewModel.form.applicantName)
                    .textFieldStyle(BaseFormTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .applicantName)
            }

            FormRow(String(localized: "av.field.role")) {
                TextField(String(localized: "av.placeholder.roleTitleRequired"), text: $viewModel.form.roleTitle)
                    .textFieldStyle(BaseFormTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .role)
            }

            FormRow(String(localized: "av.field.email")) {
                TextField(String(localized: "av.placeholder.emailOptional"), text: $viewModel.form.contactEmail)
                    .textFieldStyle(EmailTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .email)
            }

            FormRow(String(localized: "av.field.phone")) {
                TextField(String(localized: "av.placeholder.phoneOptional"), text: $viewModel.form.contactPhone)
                    .textFieldStyle(PhoneTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .phone)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "av.section.businessOptional")).captionTextStyle()
                Divider()
            }
            .padding(.top, 15)

            FormRow(String(localized: "av.field.business")) {
                TextField(String(localized: "av.placeholder.brandName"), text: $viewModel.form.brandName)
                    .textFieldStyle(BaseFormTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .businessName)
            }

            FormRow(String(localized: "av.field.category")) {
                TextField(String(localized: "av.placeholder.vendorCategoryExample"), text: $viewModel.form.brandCategory)
                    .textFieldStyle(BaseFormTextFieldStyle())
                    .secondaryTextStyle()
                    .focused($regFocused, equals: .businessCategory)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "av.section.confirmations")).captionTextStyle()
                Divider()
            }
            .padding(.top, 15)

            CheckboxComponentView(
                title: RoleAttestationItem.authority.displayTitle,
                selectedValue: $viewModel.form.confirmsAuthority
            )
            .font(.system(size: 12))
            .onTapGesture {
                regFocused = nil
            }

            CheckboxComponentView(
                title: RoleAttestationItem.rights.displayTitle,
                selectedValue: $viewModel.form.confirmsRights
            )
            .font(.system(size: 12))
            .onTapGesture {
                regFocused = nil
            }

            if let confirmedAt = viewModel.form.confirmedAt, viewModel.form.allConfirmed {
                HStack{
                    Spacer()
                    Text(String(format: String(localized: "av.confirmed.format"), confirmedAt.formatted(date: .abbreviated, time: .shortened)))
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(.main)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .transition(.opacity)
                    Spacer()
                }

            }

            VStack(alignment: .leading, spacing: 4) {
                Text(String(localized: "av.section.messageToAdminOptional")).captionTextStyle()
                Divider()
            }
            .padding(.top, 25)

            TextField(String(localized: "av.placeholder.additionalMessage"), text: $viewModel.form.messageToAdmin, axis: .vertical)
                .secondaryTextStyle()
                .lineLimit(3...6)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .frame(minHeight: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(lineWidth: 1)
                }
                .focused($regFocused, equals: .message)

            Button {
                viewModel.saveRegistrationAndContinue()
            } label: {
                Text(viewModel.primaryRegistrationButtonTitle)
                    .frame(maxWidth: .infinity)
            }
            .disabled(!viewModel.form.canSaveRegistration)
            .opacity(viewModel.form.canSaveRegistration ? 1 : 0.5)
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 50)
        }
        .onChange(of: viewModel.form.allConfirmed) { _, _ in
            withAnimation {
                viewModel.form.syncConfirmedAtIfNeeded()
            }
        }
        .keyboardFocusToolbar($regFocused, order: regOrder)
        .scrollDismissesKeyboard(.interactively)
    }

    private var evidenceTab: some View {
        VStack {
            if viewModel.applicationExists == false {
                Text(String(localized: "av.evi.text.completeRegistrationTabFirst"))
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            } else if viewModel.isPendingOrApproved {
                Text(String(localized: "av.evi.text.underReviewCannotEdit"))
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: "av.evi.section.verificationMethod"))
                        .captionTextStyle()
                    Divider()
                }
                .padding(.top, 25)

                Picker("", selection: $viewModel.form.selectedEvidenceMethod) {
                    Text(String(localized: "av.evi.method.officialEmail"))
                        .tag(EvidenceMethod.officialEmail)

                    Text(String(localized: "av.evi.method.verificationCode"))
                        .tag(EvidenceMethod.codePost)
                }
                .tint(.main)
                .labelsHidden()

                Text(viewModel.form.evidenceHelperText)
                    .secondaryTextStyle()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(lineWidth: 1)
                    }

                switch viewModel.form.selectedEvidenceMethod {
                case .officialEmail:
                    VStack (alignment: .leading) {
                        Divider()
                            .background(.main)
                            .padding(.top, 35)

                        HStack {
                            Spacer()
                            Text(String(localized: "av.evi.step1.inputFields"))
                                .primaryTextStyle()
                            Spacer()
                        }
                        Divider()
                            .background(.main)

                        Text(String(localized: "av.evi.bullet.useOfficialEmail"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)
                            .padding(.bottom, 10)

                        FormRow(String(localized: "av.field.email")) {
                            TextField(String(localized: "av.evi.placeholder.emailHintExample"), text: $viewModel.form.evidenceEmailHint)
                                .textFieldStyle(EmailTextFieldStyle())
                                .secondaryTextStyle()
                                .focused($eviFocused, equals: .emailHint)
                        }
                        .padding(.bottom, 10)
                        FormRow(String(localized: "av.evi.field.url")) {
                            TextField(String(localized: "av.evi.placeholder.emailLink"), text: $viewModel.form.evidenceEmailURL)
                                .textFieldStyle(WebLinkTextFieldStyle())
                                .secondaryTextStyle()
                                .focused($eviFocused, equals: .emailURL)
                        }
                        .padding(.bottom, 10)

                        Divider()
                            .background(.main)
                            .padding(.top, 35)
                        HStack {
                            Spacer()
                            Text(String(localized: "av.evi.step2.sendEmail"))
                                .primaryTextStyle()
                            Spacer()
                        }
                        Divider()
                            .background(.main)

                        Text(String(localized: "av.evi.bullet.sendToBelowAddress"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)
                        Button {
                            copyToClipboard("contact@example.com")
                            toastCenter.show(.init(message: String(localized: "av.toast.copied")))
                        } label: {
                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "av.evi.label.emailTo"))
                                        .captionTextStyle()
                                    Divider()
                                }
                                Label(String(localized: "av.evi.value.contactEmail"), systemImage: "document.on.document")
                            }
                            .padding(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(lineWidth: 1)
                            }
                        }
                        .tint(.main)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 15)

                        Text(String(localized: "av.evi.bullet.copyEmailTitle"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)
                        Text(String(localized: "av.evi.bullet.noEmailBodyNeeded"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)

                        Button {
                            copyToClipboard(String(format: String(localized: "av.evi.emailTitle.format"), userId, viewModel.form.verificationCode))
                            toastCenter.show(.init(message: String(localized: "av.toast.copied")))
                        } label: {
                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "av.evi.label.emailTitle"))
                                        .captionTextStyle()
                                    Divider()
                                }
                                Label(String(format: String(localized: "av.evi.emailTitle.format"), userId, viewModel.form.verificationCode), systemImage: "document.on.document")
                            }
                            .padding(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(lineWidth: 1)
                            }
                        }
                        .tint(.main)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 15)

                    }

                case .codePost:
                    VStack (alignment: .leading) {
                        Divider()
                            .background(.main)
                            .padding(.top, 35)
                        HStack {
                            Spacer()
                            Text(String(localized: "av.evi.step1.inputFields"))
                                .primaryTextStyle()
                            Spacer()
                        }
                        Divider()
                            .background(.main)
                            .padding(.bottom, 5)

                        Text(String(localized: "av.evi.bullet.urlWhereCodePosted"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)

                        Text(String(localized: "av.evi.bullet.detailWhereCodePosted"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)
                            .padding(.bottom, 10)

                        FormRow(String(localized: "av.evi.field.url")) {
                            TextField(String(localized: "av.evi.placeholder.channelUrl"), text: $viewModel.form.evidenceChannelURL)
                                .textFieldStyle(WebLinkTextFieldStyle())
                                .secondaryTextStyle()
                                .focused($eviFocused, equals: .channelURL)
                        }
                        .padding(.bottom, 10)

                        FormRow(String(localized: "av.evi.field.detail")) {
                            TextField(String(localized: "av.evi.placeholder.channelDetail"), text: $viewModel.form.evidenceChannelDetail)
                                .textFieldStyle(BaseFormTextFieldStyle())
                                .secondaryTextStyle()
                                .focused($eviFocused, equals: .channelDetail)
                        }
                        .padding(.bottom, 10)

                        Divider()
                            .background(.main)
                            .padding(.top, 35)
                        HStack {
                            Spacer()
                            Text(String(localized: "av.evi.step2.postCode"))
                                .primaryTextStyle()
                            Spacer()
                        }
                        Divider()
                            .background(.main)
                            .padding(.bottom, 5)

                        Text(String(localized: "av.evi.bullet.postCodeThenSubmit"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)

                        Text(String(localized: "av.evi.bullet.channelsExample"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)

                        Button {
                            copyToClipboard(viewModel.form.verificationCode)
                            toastCenter.show(.init(message: String(localized: "av.toast.copied")))
                        } label: {
                            VStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(String(localized: "av.evi.label.verificationCode"))
                                        .captionTextStyle()
                                    Divider()
                                }
                                Label(viewModel.form.verificationCode, systemImage: "document.on.document")
                            }
                            .padding(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(lineWidth: 1)
                            }
                        }
                        .tint(.main)
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 15)

                        Text(String(localized: "av.evi.bullet.removeAfterApproved"))
                            .secondaryTextStyle()
                            .padding(.vertical, 2)

                    }

                }
                Divider()
                    .background(.main)
                    .padding(.top, 35)
                HStack {
                    Spacer()
                    Text(String(localized: "av.evi.step3.submit"))
                        .primaryTextStyle()
                    Spacer()
                }
                Divider()
                    .background(.main)
                    .padding(.bottom, 10)

                Button {
                    viewModel.submitEvidence()
                } label: {
                    Text(String(localized: "av.evi.button.submitEvidence"))
                        .frame(maxWidth: .infinity)
                }
                .disabled(!viewModel.form.canSubmitEvidence)
                .opacity(viewModel.form.canSubmitEvidence ? 1 : 0.5)
                .buttonStyle(PrimaryButtonStyle())

                .padding(.bottom, 15)

                Text(String(localized: "av.evi.text.contactIfNoMethod"))
                    .captionTextStyle()
            }
        }
        .keyboardFocusToolbar($eviFocused, order: eviOrder)
        .scrollDismissesKeyboard(.interactively)
        .onChange(of: viewModel.form.selectedEvidenceMethod) { _, _ in
            eviFocused = nil
        }
    }
    
}


enum ApplyVendorTab: String, Hashable {
    case registration
    case evidence
}


struct ApplyCurtainView: View {

    let userId: String
    @Environment(\.dismiss) private var dismiss
    @State private var shouldBypassCurtain: Bool = false
    @State private var didCheckExistingApplication: Bool = false

    var body: some View {
        Group {
            if didCheckExistingApplication == false {
                ZStack {
                    Color.black.opacity(0.03)
                        .ignoresSafeArea()

                    ProgressView()
                        .tint(.main)
                }
            } else if shouldBypassCurtain {
                ApplyVendorView(userId: userId)
                    .transition(.opacity)
            } else {
                ZStack {
                    LinearGradient(
                        colors: [Color.highlight.opacity(0.9), Color.highlight.opacity(0.55)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Spacer(minLength: 10)

                        VStack(spacing: 10) {
                            Text(String(localized: "avc.title.becomeVendor"))
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.main)

                            Text(String(localized: "avc.text.subtitle"))
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            stepRow(index: 1, title: String(localized: "avc.step.registration.title"), detail: String(localized: "avc.step.registration.detail"))
                            stepRow(index: 2, title: String(localized: "avc.step.evidence.title"), detail: String(localized: "avc.step.evidence.detail"))
                            stepRow(index: 3, title: String(localized: "avc.step.submit.title"), detail: String(localized: "avc.step.submit.detail"))
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .padding(.horizontal, 18)

                        VStack(spacing: 10) {
                            Button {
                                shouldBypassCurtain = true
                            } label: {
                                Text(String(localized: "avc.button.startApplication"))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .padding(.horizontal, 18)

                            Button {
                                dismiss()
                            } label: {
                                Text(String(localized: "avc.button.notNow"))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    .tint(.main)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .padding(.horizontal, 18)
                        }

                        Spacer(minLength: 10)
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: didCheckExistingApplication)
        .animation(.easeInOut(duration: 0.18), value: shouldBypassCurtain)
        .task(id: userId) {
            let vm = ApplyVendorViewModel(userId: userId)
            vm.load()

            shouldBypassCurtain = vm.applicationExists
            didCheckExistingApplication = true
        }
        .navigationTitle(String(localized: "avc.nav.vendorApplication"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stepRow(index: Int, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(index)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Color.main)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.main)

                Text(detail)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
    }
}



//#Preview {
//    NavigationStack {
//        ApplyVendorView(userId: users[2].id)

//    }
//            .environment(ToastCenter())
//            .environment(SessionManager())
//}


#Preview {
    NavigationStack {
        ApplyCurtainView(userId: UserMockSeed.makeUsers()[5].id)
    }
    .environment(ToastCenter())
    .environment(SessionManager())
}
