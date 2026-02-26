






import SwiftUI

struct VendorReviewView: View {
    
    let vendorSummary: VendorSummary

    @Environment(SessionManager.self) var sessionManager: SessionManager
    @State private var viewModel: VendorReviewViewModel
    
    init(vendorSummary: VendorSummary) {
        self.vendorSummary = vendorSummary
        _viewModel = State(initialValue: VendorReviewViewModel(vendorSummary: vendorSummary))
    }
    
    @State private var pendingExternalURL: String?
    @State private var showOpenExternalLinkAlert = false
    
    func button() -> some View {
        NavigationLink {
            VendorUpdateView(vendorSummary: viewModel.vendorSummary)
        } label: {
            Text(String(localized: "vrv.button.edit"))
                .primaryTextStyle()
        }
        .disabled(viewModel.vendorSummary.status == .pending || viewModel.vendorSummary.status == .archived)
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
        .alert(
            String(localized: "vrv.alert.openExternal.title"),
            isPresented: $showOpenExternalLinkAlert,
            presenting: pendingExternalURL
        ) { urlString in
            Button(String(localized: "vrv.button.open")) {
                openURL(urlString)
                pendingExternalURL = nil
            }
            Button(String(localized: "vrv.button.cancel"), role: .cancel) {
                pendingExternalURL = nil
            }
        } message: { urlString in
            Text(urlString)
        }
    }
}


#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.authLevel = .authenticated
    session.currentUser = UserMockSeed.makeUsers()[1]

    return NavigationStack {
        VendorReviewView(vendorSummary: VendorMockSeed.makeSummaries()[0])
    }
    .environment(session)
    .environment(ToastCenter())
}
