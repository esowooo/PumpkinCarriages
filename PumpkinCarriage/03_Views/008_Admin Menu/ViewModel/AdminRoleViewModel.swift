import Foundation

@Observable
final class AdminRoleViewModel {

    private var roleApplicationRepository: any RoleApplicationRepository { Repositories.shared.roleApplication }
    
    // MARK: - Tab
    enum Tab: String, CaseIterable, Identifiable {
        var id: Self { self }
        case pending
        case history
    }
    
    enum PendingEvidenceFilter: String, CaseIterable, Identifiable {
        var id: Self { self }
        case all
        case codePost
        case officialEmail

        var title: String {
            switch self {
            case .all: return String(localized: "arvm.filter.all")
            case .codePost: return String(localized: "arvm.filter.codePost")
            case .officialEmail: return String(localized: "arvm.filter.officialEmail")
            }
        }

        var method: EvidenceMethod? {
            switch self {
            case .all: return nil
            case .codePost: return .codePost
            case .officialEmail: return .officialEmail
            }
        }
    }
    var pendingEvidenceFilter: PendingEvidenceFilter = .all

    // MARK: - UI State
    var selectedTab: Tab = .pending

    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""

    // MARK: - Data
    var applications: [RoleApplication] = []


    // MARK: - Derived Lists
    var pendingApplications: [RoleApplication] {
        let base = applications
            .filter { $0.status == .pending || $0.status == .initial }
            .sorted(by: { $0.updatedAt > $1.updatedAt })
        
        guard let method = pendingEvidenceFilter.method else { return base }

        return base.filter { app in
            app.evidence.contains(where: { $0.method == method })
        }
    }

    var historyApplications: [RoleApplication] {
        applications
            .filter { !($0.status == .pending || $0.status == .initial) }
            .sorted(by: { $0.updatedAt > $1.updatedAt })
    }

    // MARK: - Init
    init(preview: Bool = false) {
        if preview {
            // In preview, seed from the repository's in-memory source of truth.
            applications = roleApplicationRepository.allLatestApplications()
        }
    }

    // MARK: - read Application (Prototype)
    func readApplications(methodFilter: EvidenceMethod? = nil, forceReload: Bool = true) {
        // Mock: refresh from the repository's in-memory source of truth.
        // Firebase: replace this with an async repository fetch.
        if forceReload || applications.isEmpty {
            applications = roleApplicationRepository.allLatestApplications()
        }

        if let methodFilter {
            switch methodFilter {
            case .codePost:
                pendingEvidenceFilter = .codePost
            case .officialEmail:
                pendingEvidenceFilter = .officialEmail
            }
        } else {
            pendingEvidenceFilter = .all
        }
    }

    // MARK: - Alert
    private func createAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    
}
