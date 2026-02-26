import Foundation

@MainActor
@Observable
class MainListViewModel {
    
    private var openVendorReadRepository: any OpenVendorReadRepository { Repositories.shared.vendorRead.open }
    
    var vendorSummaryList: [VendorSummary] = []
    var searchText: String = ""
    var order: VendorListOrder = .byNameAsc
    var showFilterSheet = false
    var filters = VendorFilters()
    
    //error handling
    var alertTitle: String = ""
    var alertMessage: String = ""
    var showAlert: Bool = false
    var showMessage: Bool = false
    
    //MARK: - Error Handling (Prototype)
    func createAlert(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func createMessage(title: String, message: String, error: Error? = nil){
        if let error = error {
            print(error.localizedDescription)
        }
        alertTitle = title
        alertMessage = message
        showMessage = true
    }
    
    //MARK: - Step1: Fetch Vendors (Open Scope)
    func readVendorSummaries(_ category: VendorCategory) async {
        do {
            // Open scope enforces public visibility (e.g., active/visible only).
            // Keep search/order/filter locally for now to preserve current UI behavior.
            let query = VendorQuery(category: category)
            vendorSummaryList = try await openVendorReadRepository.readOpenSummaries(query: query)
        } catch {
            createAlert(title: String(localized: "mlvm.alert.error.title"), message: String(localized: "mlvm.alert.loadFailed.msg"), error: error)
            vendorSummaryList = []
        }
    }
    

    //MARK: - Step2: Filtered Vendors (category + sheet filters)
    var filteredVendors: [VendorSummary] {
        var result = vendorSummaryList

        if filters.country != .none {
            result = result.filter { $0.locationCountry == filters.country }
        }

        if filters.city != .none {
            result = result.filter { $0.locationCity == filters.city }
        }

        if !filters.district.isEmpty, filters.district != District.none {
            result = result.filter { $0.locationDistrict == filters.district }
        }

        if !filters.languages.isEmpty {
            result = result.filter { vendor in
                !Set(vendor.languages).isDisjoint(with: Set(filters.languages))
            }
        }

        return result
    }

    //MARK: - Step3: Searched Vendors
    var searchedVendors: [VendorSummary] {
        let searchedVendors = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchedVendors.isEmpty else { return filteredVendors }

        return filteredVendors.filter {
            $0.name.localizedCaseInsensitiveContains(searchedVendors)
        }
    }

    //MARK: - Step4: Order
    var orderedVendors: [VendorSummary] {
        switch order {
        case .byNameAsc:
            return searchedVendors.sorted {
                $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        case .byNameDsc:
            return searchedVendors.sorted {
                $0.name.localizedStandardCompare($1.name) == .orderedDescending
            }
        case .byMarkCount:
            return searchedVendors.sorted {
                if $0.markCount != $1.markCount { return $0.markCount > $1.markCount }
                return $0.name.localizedStandardCompare($1.name) == .orderedAscending
            }
        }
    }
    
    

    
}
