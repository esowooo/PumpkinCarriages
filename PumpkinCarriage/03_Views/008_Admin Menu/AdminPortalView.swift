






import SwiftUI

struct AdminPortalView: View {
    
    @Environment(SessionManager.self) var sessionManager: SessionManager
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = AdminPortalViewModel()
    
    var user: User

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    // MARK: - Header
                    HStack {
                        Text(String(localized: "apv.title.adminPortal"))
                            .menuTitleStyle()
                            .foregroundStyle(.main)

                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .primaryTextStyle()
                                .foregroundStyle(.highlight)
                        }
                    }
                    
                    // MARK: - User Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text(String(localized: "apv.section.accountInfo"))
                            .captionTextStyle()
                        Divider()
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                // Username
                                Text(String(format: String(localized: "apv.user.format"), user.username))
                                    .primaryTextStyle()
                                
                                Text(String(localized: "apv.user.roleApplicationCount"))
                                    .captionTextStyle()
                                Text(String(localized: "apv.user.pendingVendorCount"))
                                    .captionTextStyle()
                            }
                            
                            Spacer()
                            VStack (spacing: 5) {
                                Image(
                                    systemName: "person.badge.key.fill"
                                )
                                .foregroundStyle(Color.blue)
                                .menuTitleStyle()
                                
                                Text(user.role.displayName.capitalized)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 2)
                                    .background( Color.blue.opacity(0.15))
                                    .foregroundStyle(Color.blue)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    
                    // MARK: - Admin Actions
                    VStack(spacing: 12) {
                        
                        NavigationLink {
                            AdminVendorView()
                        } label: {
                            adminActionRow(
                                title: String(localized: "apv.action.manageVendors.title"),
                                subtitle: String(localized: "apv.action.manageVendors.subtitle"),
                                systemImage: "pencil"
                            )
                        }
                        
                        NavigationLink {
                            AdminRoleView()
                        } label: {
                            adminActionRow(
                                title: String(localized: "apv.action.reviewRoles.title"),
                                subtitle: String(localized: "apv.action.reviewRoles.subtitle"),
                                systemImage: "person.badge.shield.checkmark"
                            )
                        }
                        
                        NavigationLink {
                            AdminStatusView()
                        } label: {
                            adminActionRow(
                                title: String(localized: "apv.action.reviewVendors.title"),
                                subtitle: String(localized: "apv.action.reviewVendors.subtitle"),
                                systemImage: "ipad.badge.checkmark"
                            )
                        }
                    }
                    Spacer(minLength: 30)
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.checkAccessPermission(user: sessionManager.currentUser)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button(String(localized: "apv.button.ok")) {
                if viewModel.shouldDismissOnAlert {
                    viewModel.shouldDismissOnAlert = false
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    
    // MARK: - Reusable Action Button
    @ViewBuilder
    private func adminActionRow(
        title: String,
        subtitle: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: 15) {
            Image(systemName: systemImage)
                .primaryTextStyle()
                .foregroundStyle(.highlight)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .primaryTextStyle()
                    .foregroundStyle(.main)
                Text(subtitle)
                    .captionTextStyle()
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.highlight)
        }
        .padding()
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    let session = SessionManager()
    session.sessionState = .signedIn
    session.currentUser = UserMockSeed.makeUsers()[1]
    session.authLevel = .authenticated

    return AdminPortalView(user: UserMockSeed.makeUsers()[1])
        .environment(session)
        .environment(ToastCenter())
}
