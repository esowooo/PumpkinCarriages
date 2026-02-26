import SwiftUI

struct StatusApplicationView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(\.locale) private var locale

    @FocusState private var focusedField: Field?
    private enum Field: Hashable {
        case message
    }
    private let focusOrder: [Field] = [.message]
    
    let action: StatusRequestAction
    let vendorId: String
    let vendorPublicId: String
    let vendorName: String
    let vendorStatus: VendorStatus
    let onFinish: (StatusRequestResult) -> Void
    
    // MARK: - Alerts / Sheets
    @State private var showTermsSheet = false
    @State private var hasOpenedTerms = false

    private enum AlertKind: Identifiable {
        case confirmHide(vendorName: String)
        case confirmArchive(vendorName: String)
        case mustOpenTerms(message: String)

        var id: String {
            switch self {
            case .confirmHide: return "confirmHide"
            case .confirmArchive: return "confirmArchive"
            case .mustOpenTerms: return "mustOpenTerms"
            }
        }
    }

    @State private var alert: AlertKind? = nil

    // MARK: - Consent (only one applies per action)
    @State private var consentChecked = false
    @State private var note = ""
    @State private var latestVendorTermsVersion: String?
    @State private var isLoadingTermsVersion = false

    // MARK: - Versions
    // Activation terms version is fetched from Hosting manifest; fallback is used when offline.
    private let activationFallbackTermsVersion = "20260213"

    // Hide/Archive are in-app notices (not web legal docs). Keep a lightweight version for audit/telemetry.
    private let noticeTermsVersion = "20260213"

    // MARK: - Dependencies
    private let webDocsClient = WebDocsClient()

    private var hideClauses: [String] {
        [
            String(localized: "tv.vendorHide.001.c1"),
            String(localized: "tv.vendorHide.001.c2"),
            String(localized: "tv.vendorHide.001.c3")
        ]
    }

    private var archiveClauses: [String] {
        [
            String(localized: "tv.vendorArchive.001.c1"),
            String(localized: "tv.vendorArchive.001.c2"),
            String(localized: "tv.vendorArchive.001.c3")
        ]
    }
    
    private var termsLang: String {
        let code = locale.language.languageCode?.identifier ?? "ja"
        switch code {
        case "ko": return "ko"
        case "ja": return "ja"
        case "en": return "ja"  // Currently not keeping "en"
        default: return "ja"
        }
    }

    private var isSubmitting: Bool {
        action == .applyForActivation || action == .resubmitForReview
    }

    private var isHiding: Bool {
        action == .requestToHide
    }

    private var isArchiving: Bool {
        action == .requestToArchive
    }

    private var canSubmit: Bool {
        if isSubmitting {
            return consentChecked && !isLoadingTermsVersion
        }
        if isHiding || isArchiving {
            return consentChecked
        }
        return true
    }
    
    private func fetchLatestVendorTermsVersionIfNeeded() async {
        guard isSubmitting else { return }
        if latestVendorTermsVersion != nil { return }

        isLoadingTermsVersion = true
        defer { isLoadingTermsVersion = false }

        do {
            let v = try await webDocsClient.fetchLegalLatestVersion(
                preferredLang: termsLang,
                docKey: "vendorTerms"
            )
            latestVendorTermsVersion = v
        } catch {
            // Fallback to local constant version if fetch fails.
            latestVendorTermsVersion = activationFallbackTermsVersion
        }
    }
    
    
    func createApp() -> VendorStatusApplication {
        var decision: VendorStatusDecision
        if isSubmitting {
            decision = .pending
        } else {
            decision = .approved
        }
        return VendorStatusApplication(
            id: UUID().uuidString,
            vendorId: vendorId,
            vendorPublicId: vendorPublicId,
            applicantUserId: sessionManager.currentUser?.id ?? "unknown",
            requestType: VendorStatusRequestType.from(action),
            currentStatus: vendorStatus,
            message: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note,
            termsVersion: {
                if isSubmitting {
                    return latestVendorTermsVersion ?? activationFallbackTermsVersion
                }
                // Hide/Archive are in-app notices (not web legal docs)
                if isHiding || isArchiving {
                    return noticeTermsVersion
                }
                return "99999"
            }(),
            agreedAt: Date(),
            decision: decision,
            reviewedByUserId: nil,
            reviewedAt: nil,
            rejectionReason: nil,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack{
                    Spacer()
                    Text(action.title)
                        .menuTitleStyle()
                    Spacer()
                }
                header
                
                vendorSummary
                
                if isSubmitting {
                    activationTermsCard
                }
                
                if isHiding {
                    hideTermsCard
                }
                
                if isArchiving {
                    archiveTermsCard
                }
                
                noteCard
                
                submitHint
            }
            .padding()
            
        }
        .task {
            await fetchLatestVendorTermsVersionIfNeeded()
        }
        .keyboardFocusToolbar($focusedField, order: focusOrder)
        .scrollDismissesKeyboard(.interactively)
        .alert(item: $alert) { kind in
            switch kind {
            case .confirmHide(let vendorName):
                return Alert(
                    title: Text(String(format: String(localized: "sav.confirm.hide.format"), vendorName)),
                    primaryButton: .cancel(Text(String(localized: "sav.alert.cancel"))),
                    secondaryButton: .default(Text(String(localized: "sav.alert.confirm"))) {
                        onFinish(.submitted(createApp()))
                    }
                )

            case .confirmArchive(let vendorName):
                return Alert(
                    title: Text(String(format: String(localized: "sav.confirm.delete.format"), vendorName)),
                    primaryButton: .cancel(Text(String(localized: "sav.alert.cancel"))),
                    secondaryButton: .default(Text(String(localized: "sav.alert.confirm"))) {
                        onFinish(.submitted(createApp()))
                    }
                )

            case .mustOpenTerms(let message):
                return Alert(
                    title: Text(String(localized: "sav.alert.openTermsFirst")),
                    message: Text(message),
                    dismissButton: .default(Text(String(localized: "vsv.button.ok")))
                )
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Button {
                    onFinish(.cancelled)
                } label: {
                    FormFieldLabel(text: String(localized: "sav.button.close"))
                }

                Spacer()

                Button {
                    if isHiding {
                        alert = .confirmHide(vendorName: vendorName)
                    } else if isArchiving {
                        alert = .confirmArchive(vendorName: vendorName)
                    } else {
                        onFinish(.submitted(createApp()))
                    }
                } label: {
                    Text(action.primaryButtonTitle)
                        .primaryTextStyle()
                        .foregroundStyle(.white)
                        .frame(width: 120, height: 32, alignment: .center)
                        .background(canSubmit ? Color.main : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .opacity(canSubmit ? 1.0 : 0.65)
                        .animation(.easeInOut(duration: 0.18), value: canSubmit)
                }
                .disabled(!canSubmit)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
    }
    
    private var vendorSummary: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(vendorName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.main)

            Text(String(format: String(localized: "sav.vendorPublicId.format"), vendorPublicId))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    private var activationTermsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "sav.card.termsAgreement"))
                .font(.system(size: 15, weight: .semibold))

            Button {
                showTermsSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                    Text(String(localized: "sav.terms.open"))
                        .font(.caption)
                        .foregroundStyle(.main)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.04))
                )
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showTermsSheet, onDismiss: {
                // Mark as opened only after the sheet has actually been shown and dismissed.
                hasOpenedTerms = true
            }) {
                SafariView(url: WebDocs.vendorTerms(lang: termsLang))
                    .ignoresSafeArea()
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)

            consentRow(isOn: $consentChecked, requiresTermsOpened: true, text: String(localized: "sav.consent.agreeProceed"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    private var hideTermsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "sav.card.termsAgreement"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(hideClauses, id: \.self) { clause in
                        bullet(clause)
                    }
                }
            }
            .frame(maxHeight: 300)

            consentRow(isOn: $consentChecked, requiresTermsOpened: false, text: String(localized: "sav.consent.agreeProceed"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    private var archiveTermsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "sav.card.termsAgreement"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(archiveClauses, id: \.self) { clause in
                        bullet(clause)
                    }
                    Button {
                        showTermsSheet = true
                    } label: {
                        HStack{
                            Spacer()
                            Text("sav.card.seePolicies")
                                .captionTextStyle()
                            Spacer()
                        }
                    }

                }
            }
            .frame(maxHeight: 300)
            consentRow(isOn: $consentChecked, requiresTermsOpened: false, text: String(localized: "sav.consent.archiveAgree"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
        .sheet(isPresented: $showTermsSheet) {
            SafariView(url: WebDocs.deletionRetention(lang: termsLang))
        }
    }

    
    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(String(localized: "sav.notes.titleOptional"))
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.main)

            TextField(String(localized: "sav.notes.placeholder"), text: $note, axis: .vertical)
                .font(.caption)
                .foregroundStyle(.main)
                .focused($focusedField, equals: .message)
                .lineLimit(3...6)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.04))
                )

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    private var submitHint: some View {
        HStack {
            Text(String(localized: "sav.hint.submitEnabled"))
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func consentRow(isOn: Binding<Bool>, requiresTermsOpened: Bool, text: String) -> some View {
        Button {
            if requiresTermsOpened && !hasOpenedTerms {
                alert = .mustOpenTerms(message: String(localized: "sav.hint.termsNotOpened"))
                return
            }
            isOn.wrappedValue.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isOn.wrappedValue ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isOn.wrappedValue ? Color.highlight : Color.main)

                Text(text)
                    .font(.system(size: 14, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
    
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text("•").font(.caption).foregroundStyle(.secondary)
            Text(text).font(.caption).foregroundStyle(.main)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack{
        StatusApplicationView(
            action: .requestToArchive,
            vendorId: "vendor_001",
            vendorPublicId: "public_vendor_001",
            vendorName: "Dress Dream",
            vendorStatus: .active
        ) { _ in }
    }
    .environment(SessionManager())
    .environment(ToastCenter())
}

