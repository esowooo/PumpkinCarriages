import SwiftUI

@MainActor
struct Services {

    static let shared: Services = {
        let imageUpload = DefaultImageUploadService(uploadRepo: MockImageUploadRepository.shared)
        let repos = Repositories.shared
        let vendorWrite = DefaultVendorWriteService(
            vendorWriteRepo: MockVendorWriteRepository.shared,
            vendorReadRepo: repos.vendorRead,
            imageUploadService: imageUpload
        )
        let auth = DefaultAuthService(userRepo: MockUserRepository.shared)
        let roleAppWrite: any RoleApplicationWriteService = DefaultRoleApplicationWriteService(
            repo: MockRoleApplicationRepository.shared, userRepo: MockUserRepository.shared
        )

        return Services(
            imageUpload: imageUpload,
            vendorWrite: vendorWrite,
            auth: auth,
            roleAppWrite: roleAppWrite
        )
    }()

    let imageUpload: any ImageUploadService
    let vendorWrite: any VendorWriteService
    let auth: any AuthService
    let roleAppWrite: any RoleApplicationWriteService
}

private struct ServicesKey: EnvironmentKey {
    static let defaultValue: Services = .shared
}

extension EnvironmentValues {
    var services: Services {
        get { self[ServicesKey.self] }
        set { self[ServicesKey.self] = newValue }
    }
}
