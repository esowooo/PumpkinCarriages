import SwiftUI

struct AdminVendorDetailView: View {
    
    var vendorSummary: VendorSummary
    
    @State private var viewModel: AdminVendorDetailViewModel

    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
        _viewModel = State(initialValue: AdminVendorDetailViewModel(vendorSummary: vendorSummary))
    }
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(ToastCenter.self) var toastCenter

    @State private var pendingExternalURL: String?
    @State private var showOpenExternalLinkAlert = false
    @State private var showChangeStatusSheet = false
    @State private var selectedVendorStatus: VendorStatus = .hidden
    @State private var showChangeStatusConfirmAlert = false
    @State private var isApplyingStatusChange = false
    
    private func button() -> some View {
        Menu {

            Button {
                copyToClipboard(vendorSummary.id)
                toastCenter.show(.init(message: String(localized: "avdv.toast.copied")))
            } label: {
                Label(String(localized: "avdv.menu.copyVendorId"),
                      systemImage: "doc.on.doc")
            }
            
            Button {
                copyToClipboard(vendorSummary.publicId)
                toastCenter.show(.init(message: String(localized: "avdv.toast.copied")))


            } label: {
                Label(String(localized: "avdv.menu.copyVendorPublicId"),
                      systemImage: "doc.on.doc")
            }

            Divider()
                .padding(.vertical, 2)

            Button {
                selectedVendorStatus = viewModel.vendorSummary.status
                showChangeStatusSheet = true
            } label: {
                Label(String(localized: "avdv.menu.changeStatus"),
                      systemImage: "slider.horizontal.3")
            }
        } label: {
            Image(systemName: "ellipsis")
                .tint(.main)
                .primaryTextStyle()
                .padding(10)
        }
    }
    
    private struct ChangeVendorStatusSheetView: View {

        let vendorName: String
        @Binding var selectedStatus: VendorStatus
        @Binding var showConfirmAlert: Bool
        @Binding var isApplying: Bool

        let onConfirm: () async -> Void
        let onCancelTap: () -> Void

        var body: some View {
            VStack{
                Form {
                    Section(String(localized: "avdv.section.status")) {
                        Picker("", selection: $selectedStatus) {
                            ForEach(VendorStatus.allCases) { status in
                                Text(status.displayName).tag(status)
                            }
                        }
                        .pickerStyle(.inline)
                        .labelsHidden()
                    }
                }
                .padding(.top, 30)
                HStack{
                    Button {
                        onCancelTap()
                    } label: {
                        Text(String(localized: "avdv.button.cancel"))
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Button {
                        showConfirmAlert = true
                    } label: {
                        Text(String(localized: "avdv.button.apply"))
                    }
                    .disabled(isApplying)
                    .buttonStyle(PrimaryButtonStyle())
                }

            }
            .padding(.horizontal,15)
            .alert(
                String(localized: "avdv.alert.confirmChange.title"),
                isPresented: $showConfirmAlert
            ) {
                Button(String(localized: "avdv.button.cancel"), role: .cancel) { }
                Button(String(localized: "avdv.button.confirm")) {
                    isApplying = true
                    Task {
                        await onConfirm()
                        isApplying = false
                    }
                }
            } message: {
                Text(
                    String(
                        format: String(localized: "avdv.alert.confirmChange.format"),
                        vendorName,
                        selectedStatus.displayName
                    )
                )
            }
        }
    }

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 35) {
                                
                VendorDetailComponentView(
                    vendorSummary: viewModel.vendorSummary,
                    vendorDetails: viewModel.vendorDetail ?? .placeholder,
                    vendorProfileImages: viewModel.vendorProfileImage?.images ?? [],
                    onExternalLinkTap: { urlString in
                        pendingExternalURL = urlString
                        showOpenExternalLinkAlert = true
                    },
                    buttonOne: {
                        EmptyView()
                    },
                    buttonTwo: {
                        button()
                    }
                )
            }
        }
        .task(id: vendorSummary.id) {
            await viewModel.loadInitialState(
                vendorId: vendorSummary.id,
                currentUserId: sessionManager.currentUser?.id
            )
        }
        .refreshable {
            await viewModel.loadInitialState(
                vendorId: vendorSummary.id,
                currentUserId: sessionManager.currentUser?.id
            )
        }
        .sheet(isPresented: $showChangeStatusSheet) {
            ChangeVendorStatusSheetView(
                vendorName: viewModel.vendorSummary.name,
                selectedStatus: $selectedVendorStatus,
                showConfirmAlert: $showChangeStatusConfirmAlert,
                isApplying: $isApplyingStatusChange,
                onConfirm: {
                    let ok = await viewModel.changeStatus(
                        vendorId: viewModel.vendorSummary.id,
                        status: selectedVendorStatus,
                        actor: sessionManager.currentUser
                    )
                    if ok {
                        showChangeStatusSheet = false
                    }
                },
                onCancelTap: {
                    showChangeStatusSheet = false
                }
            )
            .presentationDetents([.medium])
        }
        .alert(
            String(localized: "avdv.alert.openExternal.title"),
            isPresented: $showOpenExternalLinkAlert,
            presenting: pendingExternalURL
        ) { urlString in
            Button(String(localized: "avdv.button.open")) {
                openURL(urlString)
                pendingExternalURL = nil
            }
            Button(String(localized: "avdv.button.cancel"), role: .cancel) {
                pendingExternalURL = nil
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "avdv.button.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showMessage) {
            Button(String(localized: "avdv.button.ok"), role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    let session = SessionManager()
    session.authLevel = .authenticated
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[1]
    
    return AdminVendorDetailView(vendorSummary: VendorMockSeed.makeSummaries()[0])
        .environment(session)
        .environment(ToastCenter())

}
