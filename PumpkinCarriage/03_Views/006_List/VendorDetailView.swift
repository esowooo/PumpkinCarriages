






import SwiftUI

struct VendorDetailView: View {
    
    private let publicId: String

    @Environment(SessionManager.self) var sessionManager: SessionManager

    @State private var pendingExternalURL: String?
    @State private var showOpenExternalLinkAlert = false
    @State private var viewModel: VendorDetailViewModel

    init(publicId: String) {
        self.publicId = publicId
        _viewModel = State(initialValue: VendorDetailViewModel(publicId: publicId))
    }
    
    init(vendorSummary: VendorSummary) {
        self.publicId = vendorSummary.publicId
        _viewModel = State(initialValue: VendorDetailViewModel(publicId: vendorSummary.publicId, initialSummary: vendorSummary))
    }

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 35) {

                if let summary = viewModel.vendorSummary {
                    let shareText = """
                    \(summary.name)
                    \(summary.locationCity.displayName), \(summary.locationCountry.displayName)

                    \(String(localized: "vdv.share.checkOutVendor"))
                    """

                    let shareURL = URL(string: "https://pumpkincarriages.com/vendors/\(summary.publicId)")!

                    VendorDetailComponentView(
                        vendorSummary: summary,
                        vendorDetails: viewModel.vendorDetail ?? .placeholder,
                        vendorProfileImages: viewModel.vendorProfileImage?.images ?? [],
                        onExternalLinkTap: { urlString in
                            pendingExternalURL = urlString
                            showOpenExternalLinkAlert = true
                        },
                        buttonOne: {
                            ShareLink(
                                item: shareURL,
                                subject: Text(summary.name),
                                message: Text(shareText)
                            ) {
                                Image(systemName: "square.and.arrow.up")
                                    .primaryTextStyle()
                                    .tint(.main)
                            }
                        },
                        buttonTwo: {
                            Button {
                                Task {
                                    await viewModel.toggleBookmark(
                                        vendorId: summary.id,
                                        currentUser: sessionManager.currentUser
                                    )
                                }
                            } label: {
                                Image(systemName: viewModel.isMarked ? "bookmark.fill" : "bookmark")
                                    .primaryTextStyle()
                                    .tint(.main)
                            }
                        }
                    )
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading...")
                            .secondaryTextStyle()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                }
            }
            .task(id: publicId) {
                await viewModel.loadInitialState(currentUserId: sessionManager.currentUser?.id)
            }
//            .refreshable {
//                await viewModel.loadInitialState(currentUserId: sessionManager.currentUser?.id)
//            }
            .alert(
                String(localized: "vdv.alert.openExternal.title"),
                isPresented: $showOpenExternalLinkAlert,
                presenting: pendingExternalURL
            ) { urlString in
                Button(String(localized: "vdv.button.open")) {
                    openURL(urlString)
                    pendingExternalURL = nil
                }
                Button(String(localized: "vdv.button.cancel"), role: .cancel) {
                    pendingExternalURL = nil
                }
            } message: { urlString in
                Text(urlString)
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showMessage) {
                Button(String(localized: "vdv.button.ok")) {
                }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}


#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[4]
    
    // Use an existing seeded summary from your mock store.
    // This runs on MainActor so it can access MainActor-isolated shared stores.

    return VendorDetailView(vendorSummary: VendorMockSeed.makeSummaries()[0])
        .environment(session)
        .environment(ToastCenter())
}
