import Foundation

@Observable
class AdminStatusViewModel {
    
    private var adminVendorReadRepository: any AdminVendorReadRepository { Repositories.shared.vendorRead.admin }
    private var statusApplicationRepository: any StatusApplicationRepository { Repositories.shared.statusApplication }
    
    var currentUser: User?
    var shouldDismissOnAlert = false
    
    var searchText: String = ""
    var selectedRequestType: VendorStatusRequestType? = nil
    var selectedDecision: VendorStatusDecision? = nil
    var applications: [VendorStatusApplication] = []
    
    /// Cache for rendering list rows without re-fetching every time.
    /// Key: vendorId
    var vendorSummaryById: [String: VendorSummary] = [:]
    
    var filteredApplications: [VendorStatusApplication] {
        applications
            .filter { matchesSearch($0) }
            .filter { matchesRequestType($0) }
    }
    
    var pendingApplications: [VendorStatusApplication] {
        filteredApplications.filter { $0.decision == .pending }
    }
    
    private var baseHistoryApplications: [VendorStatusApplication] {
        filteredApplications.filter { $0.decision != .pending }
    }
    
    var historyApplications: [VendorStatusApplication] {
        baseHistoryApplications.filter { matchesDecision($0) }
    }
    
    var pendingRequestTypes: [VendorStatusRequestType] {
        Array(Set(pendingApplications.map { $0.requestType }))
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    var historyRequestTypes: [VendorStatusRequestType] {
        Array(Set(baseHistoryApplications.map { $0.requestType }))
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    var uniqueRequestTypes: [VendorStatusRequestType] {
        Array(Set(applications.map { $0.requestType }))
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    var uniqueHistoryDecisions: [VendorStatusDecision] {
        Array(Set(baseHistoryApplications.map { $0.decision }))
            .filter { $0 != .pending }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
   
    //error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    
    //MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    //MARK: - Access Check (Prototype)
    func checkAccessPermission(user: User?) {
        guard let user = user,
              user.role == Role.admin else {
            shouldDismissOnAlert = true
            createAlert(
                title: String(localized: "asvm.alert.permissionDenied.title"),
                message: String(localized: "asvm.alert.permissionDenied.msg")
            )
            return
        }
        currentUser = user
        vendorSummaryById = [:]
    }
    
    @MainActor
    func readApplications() async {
        guard currentUser?.role == .admin else { return }
        applications = statusApplicationRepository.listAllLatest()
        await preloadVendorSummaries()
    }

    
    @MainActor
    private func preloadVendorSummaries() async {
        guard let _ = currentUser else { return }

        let ids = Array(Set(applications.map { $0.vendorId }))
        guard !ids.isEmpty else {
            vendorSummaryById = [:]
            return
        }

        // Fetch sequentially (simple + reliable for mock). If you want, this can be upgraded
        // to a TaskGroup later when you move to network.
        var cache: [String: VendorSummary] = [:]
        for vendorId in ids {
            do {
                if let summary = try await adminVendorReadRepository.readAdminSummary(id: vendorId) {
                    cache[vendorId] = summary
                }
            } catch {
                // Non-fatal: we still render rows using vendorId if summary is missing.
                print("Failed to read admin vendor summary for \(vendorId): \(error)")
            }
        }
        vendorSummaryById = cache
    }
    
    func matchesSearch(_ app: VendorStatusApplication) -> Bool {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return true }

        let vendorName = vendorSummaryById[app.vendorId]?.name ?? ""
        let vendorPublicId = app.vendorPublicId

        return app.vendorId.localizedCaseInsensitiveContains(q)
        || vendorPublicId.localizedCaseInsensitiveContains(q)
        || vendorName.localizedCaseInsensitiveContains(q)
        || app.applicantUserId.localizedCaseInsensitiveContains(q)
        || (app.message ?? "").localizedCaseInsensitiveContains(q)
        || app.requestType.displayName.localizedCaseInsensitiveContains(q)
    }
    
    func matchesRequestType(_ app: VendorStatusApplication) -> Bool {
        guard let selectedRequestType else { return true }
        return app.requestType == selectedRequestType
    }
    
    func matchesDecision(_ app: VendorStatusApplication) -> Bool {
        guard let selectedDecision else { return true }
        return app.decision == selectedDecision
    }
    
    func matchesSearch(_ e: VendorStatusApplicationEvent) -> Bool {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return true }

        let vendorName = vendorSummaryById[e.vendorId]?.name ?? ""

        return e.vendorId.localizedCaseInsensitiveContains(q)
        || vendorName.localizedCaseInsensitiveContains(q)
        || e.actorUserId.localizedCaseInsensitiveContains(q)
        || (e.message ?? "").localizedCaseInsensitiveContains(q)
        || (e.rejectionReason ?? "").localizedCaseInsensitiveContains(q)
        || e.type.displayName.localizedCaseInsensitiveContains(q)
    }

    func matchesRequestType(_ e: VendorStatusApplicationEvent) -> Bool {
        guard let selectedRequestType else { return true }
        return e.requestType == selectedRequestType
    }

    func matchesDecision(_ e: VendorStatusApplicationEvent) -> Bool {
        guard let selectedDecision else { return true }
        return e.decision == selectedDecision
    }

    
    // Fetch Vendor Detail for Review (Prototype)
    func vendorDetails(vendorId: String) -> VendorSummary? {
        vendorSummaryById[vendorId]
    }
    
}
