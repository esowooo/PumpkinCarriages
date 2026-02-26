import Foundation

struct VendorSummary: Codable, Identifiable, Hashable {

    let id: String // IMMUTABLE vendorId
    var publicId: String
    var name: String
    var manager: String

    var thumbnail: VendorThumbnailRef?

    var locationCountry: Country
    var locationCity: City
    var locationDistrict: String
    var locationDetail: String

    var status: VendorStatus

    let createdAt: Date // IMMUTABLE
    var updatedAt: Date

    var languages: [Language]
    var category: VendorCategory

    var reviewCount: Int // Cloud Function
    var rating: Double   // Cloud Function
    var markCount: Int   // Cloud Function
}

extension VendorSummary {
    var isVisibleToCustomers: Bool { status == .active }

    static let placeholder = VendorSummary(
        id: String(localized: "vs.placeholder.loading"),
        publicId: "",
        name: String(localized: "vs.placeholder.loading"),
        manager: String(localized: "vs.placeholder.loading"),
        thumbnail: VendorThumbnailRef(imageId: "", storagePath: ""),
        locationCountry: .none,
        locationCity: .none,
        locationDistrict: District.none,
        locationDetail: "",
        status: .hidden,
        createdAt: .now,
        updatedAt: .now,
        languages: [],
        category: .studio,
        reviewCount: 0,
        rating: 0,
        markCount: 0
    )
}

struct VendorThumbnailRef: Codable, Hashable {
    var imageId: String
    var storagePath: String
}

//MARK: - Vendor Status Section
enum VendorStatus: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }

    case active // Visible to customers.
    case pending // Submitted and waiting for admin review.
    case hidden // Not visible to customers. Default for newly created vendors.
    case rejected // Rejected or Hidden by Admin
    case archived // Removed from circulation; not visible to customers & vendors.

    var displayName: String {
        switch self {
        case .active: return String(localized: "vs.status.active")
        case .pending: return String(localized: "vs.status.pending")
        case .hidden: return String(localized: "vs.status.hidden")
        case .rejected: return String(localized: "vs.status.rejected")
        case .archived: return String(localized: "vs.status.archived")
        }
    }

    var uiDescription: String {
        switch self {
        case .active:
            return String(localized: "vs.statusDesc.active")
        case .pending:
            return String(localized: "vs.statusDesc.pending")
        case .rejected:
            return String(localized: "vs.statusDesc.rejected")
        case .hidden:
            return String(localized: "vs.statusDesc.hidden")
        case .archived:
            return String(localized: "vs.statusDesc.archived")
        }
    }
    
    var canEditVendorContent: Bool {
        switch self {
        case .pending: return false
        case .archived: return false
        default: return true
        }
    }

    func statusAfterContentUpdate() -> VendorStatus {
        switch self {
        case .active:
            return .hidden
        case .rejected:
            return .rejected
        case .hidden:
            return .hidden
        case .pending:
            return .pending
        case .archived:
            return .archived
        }
    }
}


//MARK: - Vendor Category Section
enum VendorCategory: String, Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case all
    case studio
    case dress
    case hairMake
    case planner
    case coupleSnap
    
    var displayName: String {
        switch self {
        case .all: return String(localized: "vs.category.all")
        case .studio: return String(localized: "vs.category.studio")
        case .dress: return String(localized: "vs.category.dress")
        case .hairMake: return String(localized: "vs.category.hairMake")
        case .planner: return String(localized: "vs.category.planner")
        case .coupleSnap: return String(localized: "vs.category.coupleSnap")
        }
    }
    
    var iconName: String {
        switch self {
        case .all: return "list.bullet"
        case .studio: return "person.2.crop.square.stack.fill"
        case .dress: return "figure.stand.dress"
        case .hairMake: return "scissors"
        case .planner: return "document.badge.clock"
        case .coupleSnap: return "camera.fill"
        }
    }
}
