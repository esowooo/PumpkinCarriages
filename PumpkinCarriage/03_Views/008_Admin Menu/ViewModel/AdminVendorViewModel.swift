import Foundation

@MainActor
@Observable
final class AdminVendorViewModel {

    private var adminVendorReadRepository: any AdminVendorReadRepository { Repositories.shared.vendorRead.admin }

    var vendorSummaryList: [VendorSummary] = []
    var searchText: String = ""

    // Error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false

    func createAlert(title: String, message: String, error: Error? = nil) {
        if let error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

//    func readVendorSummaries(_ category: VendorCategory) async {
//        do {
//            let query = VendorQuery(category: category)
//            vendorSummaryList = try await adminVendorReadRepository.readAdminSummaries(query: query)
//        } catch {
//            createAlert(
//                title: String(localized: "avvm.alert.error.title"),
//                message: String(localized: "avvm.alert.loadFailed.msg"),
//                error: error
//            )
//            vendorSummaryList = []
//        }
//    }
    
    func filteredVendors(status: VendorStatus?) -> [VendorSummary] {
        var base = vendorSummaryList

        if let status {
            base = base.filter { $0.status == status }
        }

        return base
    }
    
    func searchVendors(_ category: VendorCategory) async {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            vendorSummaryList = []
            return
        }
        do {
            let query = VendorQuery(category: category, searchName: keyword, searchId: keyword, searchMode: .auto)
            vendorSummaryList = try await adminVendorReadRepository.readAdminSummaries(query: query)
        } catch {
            createAlert(
                title: String(localized: "avvm.alert.error.title"),
                message: String(localized: "avvm.alert.loadFailed.msg"),
                error: error
            )
            vendorSummaryList = []
        }
    }
    
    func searchByName(_ category: VendorCategory) async {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            vendorSummaryList = []
            return
        }
        do {
            let query = VendorQuery(category: category, searchName: keyword, searchMode: .name)
            vendorSummaryList = try await adminVendorReadRepository.readAdminSummaries(query: query)
        } catch {
            createAlert(
                title: String(localized: "avvm.alert.error.title"),
                message: String(localized: "avvm.alert.loadFailed.msg"),
                error: error
            )
            vendorSummaryList = []
        }
    }

    func searchById(_ category: VendorCategory) async {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            vendorSummaryList = []
            return
        }
        do {
            let query = VendorQuery(category: category, searchId: keyword, searchMode: .id)
            vendorSummaryList = try await adminVendorReadRepository.readAdminSummaries(query: query)
        } catch {
            createAlert(
                title: String(localized: "avvm.alert.error.title"),
                message: String(localized: "avvm.alert.loadFailed.msg"),
                error: error
            )
            vendorSummaryList = []
        }
    }

    func searchByPublicId(_ category: VendorCategory) async {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if keyword.isEmpty {
            vendorSummaryList = []
            return
        }
        do {
            let query = VendorQuery(category: category, searchPublicId: keyword, searchMode: .publicId)
            vendorSummaryList = try await adminVendorReadRepository.readAdminSummaries(query: query)
        } catch {
            createAlert(
                title: String(localized: "avvm.alert.error.title"),
                message: String(localized: "avvm.alert.loadFailed.msg"),
                error: error
            )
            vendorSummaryList = []
        }
    }
}
