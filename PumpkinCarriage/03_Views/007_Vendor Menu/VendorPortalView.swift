






import SwiftUI

struct VendorPortalView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = VendorPortalViewModel()
    
    var user: User

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    // MARK: - Header
                    HStack {
                        Text(String(localized: "vpv.title.vendorPortal"))
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
                        Text(String(localized: "vpv.section.accountInfo"))
                            .captionTextStyle()
                        Divider()
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                // Username
                                Text(String(format: String(localized: "vpv.user.format"), user.username))
                                    .primaryTextStyle()
                                
                                Text(String(localized: "vpv.text.manageVendorsHere"))
                                    .captionTextStyle()
                            }
                            
                            Spacer()
                            VStack (spacing: 5) {
                                Image(systemName: "storefront.fill")
                                .foregroundStyle(Color.highlight)
                                .menuTitleStyle()
                                
                                Text(user.role.displayName.capitalized)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 2)
                                    .background(Color.highlight.opacity(0.15))
                                    .foregroundStyle(Color.highlight)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    
                    // MARK: - Vendor Actions
                    VStack(spacing: 12) {
                        
                        NavigationLink {
                            VendorUpdateView(vendorSummary: nil)
                        } label: {
                            vendorActionRow(
                                title: String(localized: "vpv.action.register.title"),
                                subtitle: String(localized: "vpv.action.register.subtitle"),
                                systemImage: "plus.app"
                            )
                        }
                        
                        NavigationLink {
                            VendorManageView()
                        } label: {
                            vendorActionRow(
                                title: String(localized: "vpv.action.manage.title"),
                                subtitle: String(localized: "vpv.action.manage.subtitle"),
                                systemImage: "pencil"
                            )
                        }
                        
                        //NavigationLink {
                        //    VendorAnalyticsView()
                        //} label: {
                        //    vendorActionRow(
                        //        title: "Analytics",
                        //        subtitle: "View performance & likes",
                        //        systemImage: "chart.bar"
                        //    )
                        //}
                        
                        NavigationLink {
                            VendorGuideView()
                        } label: {
                            vendorActionRow(
                                title: String(localized: "vpv.action.guide.title"),
                                subtitle: String(localized: "vpv.action.guide.subtitle"),
                                systemImage: "questionmark.circle"
                            )
                        }
                    }
                    Spacer(minLength: 30)
                }
                .padding()
            }
        }
        .onAppear {
            
        }
    }
    
    // MARK: - Reusable Action Button
    @ViewBuilder
    private func vendorActionRow(
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
    session.authLevel = .authenticated
    session.currentUser = UserMockSeed.makeUsers()[2]

    return VendorPortalView(user: UserMockSeed.makeUsers()[2])
        .environment(session)
        .environment(ToastCenter())
}
