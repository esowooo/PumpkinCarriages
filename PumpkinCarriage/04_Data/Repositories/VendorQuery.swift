import Foundation

//FIXME: - Currently Filter/Order is handling on ViewModel level(MainListviewModel), when implementing firebase, integrate by using VendorStore
// MARK: - Query Types (Read)
struct VendorQuery: Equatable {
    var category: VendorCategory? = nil
    var filters: VendorFilters? = nil
    var searchName: String? = nil
    var searchId: String? = nil
    var searchPublicId: String? = nil
    var searchMode: VendorSearchMode = .auto
    var order: VendorListOrder = .byNameAsc
    var limit: Int? = nil

    init(
        category: VendorCategory? = nil,
        filters: VendorFilters? = nil,
        searchName: String? = nil,
        searchId: String? = nil,
        searchPublicId: String? = nil,
        searchMode: VendorSearchMode = .auto,
        order: VendorListOrder = .byNameAsc,
        limit: Int? = nil
    ) {
        self.category = category
        self.filters = filters
        self.searchName = searchName
        self.searchId = searchId
        self.searchPublicId = searchPublicId
        self.searchMode = searchMode
        self.order = order
        self.limit = limit
    }
}

//MARK: - Filter
struct VendorFilters: Equatable {
    var country: Country = .none
    var city: City = .none
    var district: String = District.none
    var languages: [Language] = []
    
    var summaryText: String {
        var parts: [String] = []
        if country != .none { parts.append(country.displayName) }
        if city != .none { parts.append(city.displayName) }
        if district != District.none { parts.append(district) }
        if !languages.isEmpty {
            parts.append(languages.map(\.shortCode).joined(separator: ","))
        }
        return parts.isEmpty ? "All vendors" : parts.joined(separator: " · ")
    }
}

//MARK: - Order
enum VendorListOrder: String, CaseIterable, Identifiable {
    var id: Self { self }

    case byNameAsc = "Name Ascending"
    case byNameDsc = "Name Descending"
    case byMarkCount = "Mark Count"
}

enum VendorSearchMode: Equatable {
    case auto
    case name
    case id
    case publicId
}


// MARK: - Shared Layer
/// Read scope is part of the query (important for server-side enforcement).
/// - open: public listing/detail (active/visible only)
/// - portal: vendor portal (self-only, excluding archived)
/// - admin: admin access (all)
enum VendorReadScope: Equatable {
    case open
    case portal(userId: String)
    case admin
}

/// A compiled query spec that a remote store can translate into server queries.
/// Mock store will still apply this locally.
struct VendorQuerySpec: Equatable {
    let scope: VendorReadScope
    let query: VendorQuery

    init(scope: VendorReadScope, query: VendorQuery) {
        self.scope = scope
        self.query = query
    }
}

/// Converts high-level inputs (scope + VendorQuery) into a single spec.
/// Remote store implementation should translate this into server-side query constraints.
struct VendorQueryCompiler {
    static func compile(scope: VendorReadScope, query: VendorQuery) -> VendorQuerySpec {
        VendorQuerySpec(scope: scope, query: query)
    }
}



// MARK: - Local Engine (Mock / SwiftData fallback)
/// Local pipeline used by Mock store.
/// When you switch to a remote store, the server should do most of this work.
struct VendorQueryEngineLocal {
    static func apply(_ input: [VendorSummary], query: VendorQuery) -> [VendorSummary] {
        var result = input

        // Category
        if let category = query.category, category != .all {
            result = result.filter { $0.category == category }
        }

        // Filters (adjust property names to your Vendor/VendorFilters model if needed)
        if let filters = query.filters {
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
                let wanted = Set(filters.languages)
                result = result.filter { vendor in
                    !Set(vendor.languages).isDisjoint(with: wanted)
                }
            }
        }

        // Search (by mode)
        switch query.searchMode {
        case .name:
            if let text = query.searchName?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
                result = result.filter { $0.name.localizedCaseInsensitiveContains(text) }
            }
        case .id:
            if let idText = query.searchId?.trimmingCharacters(in: .whitespacesAndNewlines), !idText.isEmpty {
                result = result.filter { $0.id.caseInsensitiveCompare(idText) == .orderedSame }
            }
        case .publicId:
            if let pidText = query.searchPublicId?.trimmingCharacters(in: .whitespacesAndNewlines), !pidText.isEmpty {
                result = result.filter { $0.publicId.caseInsensitiveCompare(pidText) == .orderedSame }
            }
        case .auto:
            let input = (query.searchName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if !input.isEmpty {
                if UUID(uuidString: input) != nil {
                    result = result.filter { $0.id.caseInsensitiveCompare(input) == .orderedSame }
                } else {
                    // prefer exact publicId match; if none, fallback to name contains
                    let exactPublicMatches = result.filter { $0.publicId.caseInsensitiveCompare(input) == .orderedSame }
                    result = exactPublicMatches.isEmpty ? result.filter { $0.name.localizedCaseInsensitiveContains(input) } : exactPublicMatches
                }
            }
        }

        // Order
        switch query.order {
        case .byNameAsc:
            result = result.sorted {
                let cmp = $0.name.localizedStandardCompare($1.name)
                if cmp != .orderedSame { return cmp == .orderedAscending }
                return $0.id < $1.id
            }

        case .byNameDsc:
            result = result.sorted {
                let cmp = $0.name.localizedStandardCompare($1.name)
                if cmp != .orderedSame { return cmp == .orderedDescending }
                return $0.id < $1.id
            }

        case .byMarkCount:
            result = result.sorted {
                if $0.markCount != $1.markCount { return $0.markCount > $1.markCount }
                let cmp = $0.name.localizedStandardCompare($1.name)
                if cmp != .orderedSame { return cmp == .orderedAscending }
                return $0.id < $1.id
            }
        }

        // Limit
        if let limit = query.limit {
            result = Array(result.prefix(max(0, limit)))
        }

        return result
    }
}

