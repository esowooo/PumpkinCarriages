import SwiftUI

struct VendorManageView: View {
        
    @Environment(SessionManager.self) var sessionManager: SessionManager

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = VendorManageViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    
    @ViewBuilder
    private func selectionBadge(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .inset(by: 2)
            .stroke(isSelected ? Color.highlight : .clear, lineWidth: 3)
            .allowsHitTesting(false)
    }
    
    private func statusRow(for vendor: VendorSummary) -> some View {
        let (text, color) = statusStyle(from: vendor.status)
        
        return HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.main.opacity(0.2), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    private func statusStyle(from status: VendorStatus) -> (text: String, color: Color) {
        
        switch status {
        case .active:
            return (status.displayName, .green)
        case .pending:
            return (status.displayName, .yellow)
        case .rejected:
            return (status.displayName, .red)
        case .hidden:
            return (status.displayName, .gray)
        case .archived:
            return (status.displayName, .main)
        }
    }
    
    @ViewBuilder
    private func vendorCell(vendor: VendorSummary) -> some View {
        VStack(spacing: 10) {
            NavigationLink {
                VendorReviewView(vendorSummary: vendor)
            } label: {
                VendorGridCardView(vendor: vendor)
                    .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            
            NavigationLink {
                VendorStatusView(vendorSummary: vendor)
            } label: {
                statusRow(for: vendor)
            }
            .buttonStyle(.plain)
        }
    }
    
    private struct VendorGridCardView: View {
        let vendor: VendorSummary
        @Environment(\.repositories) private var repos
        let imageHeight: CGFloat = 180
        let imageWidth: CGFloat = 165
        let corner: CGFloat = 10

        var body: some View {
            VStack(alignment: .center) {
                if let vendorThumbnail = vendor.thumbnail {
                    ImageResourceView(
                        storagePath: vendorThumbnail.storagePath,
                        repository: repos.imageResolve,
                        contentMode: .fill,
                        cornerRadius: corner,
                        placeholderHeight: imageHeight
                    )
                    .frame(width: imageWidth, height: imageHeight)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: corner))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.main.opacity(1), lineWidth: 1)
                    )
                } else {
                    ImagePlaceholderView(height: imageHeight, cornerRadius: corner)
                        .frame(width: imageWidth, height: imageHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Color.main.opacity(1), lineWidth: 1)
                        )
                }

                
                VStack(alignment: .leading) {
                    Text(vendor.name)
                        .lineLimit(2)
                        .primaryTextStyle()
                        .foregroundStyle(.main)
                    
                    Text("\(vendor.locationDistrict)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 2) {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.main)
                            .secondaryTextStyle()
                        Text("\(vendor.markCount)")
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(vendor.category.displayName)
                            .font(.caption)
                            .foregroundStyle(.main)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.main.opacity(1), lineWidth: 1)
                            )
                        
//                        Text(vendor.category.displayName)
//                            .font(.caption)
//                            .foregroundStyle(.white)
//                            .padding(.horizontal, 10)
//                            .padding(.vertical, 4)
//                            .background(Capsule().fill(Color.main))
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 5)
                
            }
            .padding(.top, 1.5)
            .padding(.vertical, 5)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.main.opacity(1), lineWidth: 1)
            )
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text(String(localized: "vmv.title.myVendors"))
                    .menuTitleStyle()
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.managedVendors.isEmpty {
                        Text(String(localized: "vmv.text.noManagedVendors"))
                            .captionTextStyle()
                            .foregroundStyle(.secondary)
                            .padding(.top, 20)
                    } else {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.managedVendors) { vendor in
                                vendorCell(vendor: vendor)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.checkAccessPermission(user: sessionManager.currentUser)
                if viewModel.currentUser != nil {
                    await viewModel.readManagedVendors()
                }
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button(String(localized: "vmv.button.ok")) {
                    if viewModel.shouldDismissOnAlert {
                        viewModel.shouldDismissOnAlert = false
                        dismiss()
                    }
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
    session.authLevel = .authenticated
    session.currentUser = UserMockSeed.makeUsers()[2]

    return NavigationStack {
        VendorManageView()
    }
    .environment(session)
    .environment(ToastCenter())
    .environment(\.repositories, Repositories.shared)
}
