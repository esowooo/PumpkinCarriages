import SwiftUI

@MainActor
struct Repositories {

    static let shared: Repositories = {
        let store: any VendorStore = MockVendorStore.shared

        return Repositories(
            user: MockUserRepository.shared,
            mark: MockMarkRepository.shared,
            statusApplication: MockStatusApplicationRepository.shared,
            roleApplication: MockRoleApplicationRepository.shared,
            userConsent: MockUserConsentRepository.shared,

            vendorRead: VendorReadRepositoryBundle(
                open: MockOpenVendorReadRepository(store: store),
                portal: MockVendorPortalVendorReadRepository(store: store),
                admin: MockAdminVendorReadRepository(store: store)
            ),

            image: ImageRepositoryBundle(
                resolve: MockImageResolveRepository.shared,
                upload: MockImageUploadRepository.shared
            )
        )
    }()

    let user: any UserRepository
    let mark: any MarkRepository
    let statusApplication: any StatusApplicationRepository
    let roleApplication: any RoleApplicationRepository
    let userConsent: any UserConsentRepository

    let vendorRead: VendorReadRepositoryBundle

    var imageResolve: any ImageResolveRepository { image.resolve }
    private let image: ImageRepositoryBundle
}

struct ImageRepositoryBundle {
    let resolve: any ImageResolveRepository
    let upload: any ImageUploadRepository
}

struct VendorReadRepositoryBundle {
    let open: any OpenVendorReadRepository
    let portal: any VendorPortalVendorReadRepository
    let admin: any AdminVendorReadRepository
}

@MainActor
private struct RepositoriesKey: EnvironmentKey {
    static let defaultValue: Repositories = .shared
}

extension EnvironmentValues {
    var repositories: Repositories {
        get { self[RepositoriesKey.self] }
        set { self[RepositoriesKey.self] = newValue }
    }
}
