import Foundation

// MARK: - VendorStatusApplication (Latest Snapshot)
// Policy: Keep ONE `VendorStatusApplication` per vendor as the latest snapshot.
struct VendorStatusApplication: Codable, Identifiable, Hashable {
    let id: String

    // Relation
    let vendorId: String
    var vendorPublicId: String
    let applicantUserId: String

    // Request Content
    let requestType: VendorStatusRequestType
    let currentStatus: VendorStatus
    var message: String?

    // Terms Agreed
    var termsVersion: String
    var agreedAt: Date

    // Result
    var decision: VendorStatusDecision
    var reviewedByUserId: String?
    var reviewedAt: Date?
    var rejectionReason: String?    // in case decision == rejected

    // Meta
    let createdAt: Date
    var updatedAt: Date
}

// MARK: - Event (History)
// Policy: Track lifecycle transitions (submit/resubmit/approve/reject/status-applied) as events.
struct VendorStatusApplicationEvent: Codable, Identifiable, Hashable {
    let id: String

    // Relation
    let statusApplicationId: String   // VendorStatusApplication.id
    let vendorId: String              // VendorSummary.id
    let actorUserId: String       // User.id (actor)

    // Type
    let type: VendorStatusApplicationEventType

    // Time
    let occurredAt: Date

    // Optional snapshots (hybrid)
    var requestType: VendorStatusRequestType?
    var currentStatus: VendorStatus?
    var message: String?

    var decision: VendorStatusDecision?
    var rejectionReason: String?

    init(
        id: String = UUID().uuidString,
        statusApplicationId: String,
        vendorId: String,
        actorUserId: String,
        type: VendorStatusApplicationEventType,
        occurredAt: Date = .now,
        requestType: VendorStatusRequestType? = nil,
        currentStatus: VendorStatus? = nil,
        message: String? = nil,
        decision: VendorStatusDecision? = nil,
        rejectionReason: String? = nil
    ) {
        self.id = id
        self.statusApplicationId = statusApplicationId
        self.vendorId = vendorId
        self.actorUserId = actorUserId
        self.type = type
        self.occurredAt = occurredAt
        self.requestType = requestType
        self.currentStatus = currentStatus
        self.message = message
        self.decision = decision
        self.rejectionReason = rejectionReason
    }
}

enum VendorStatusApplicationEventType: String, Codable, CaseIterable {
    case submitted
    case resubmitted
    case decidedApproved
    case decidedRejected
    case vendorStatusApplied
    case termsUpdated

    var displayName: String {
        switch self {
        case .submitted:           return String(localized: "vsa.event.submitted")
        case .resubmitted:         return String(localized: "vsa.event.resubmitted")
        case .decidedApproved:     return String(localized: "vsa.event.approved")
        case .decidedRejected:     return String(localized: "vsa.event.rejected")
        case .vendorStatusApplied: return String(localized: "vsa.event.statusApplied")
        case .termsUpdated: return
            String(localized: "vsa.event.termsUpdated")
        }
    }

    var systemImage: String {
        switch self {
        case .submitted:           return "paperplane"
        case .resubmitted:         return "arrow.clockwise"
        case .decidedApproved:     return "checkmark.seal"
        case .decidedRejected:     return "xmark.seal"
        case .vendorStatusApplied: return "bolt.badge.checkmark"
        case .termsUpdated:        return "doc.badge.gearshape"
        }
    }

    var sortOrder: Int {
        switch self {
        case .submitted:           return 0
        case .resubmitted:         return 1
        case .decidedApproved:     return 2
        case .decidedRejected:     return 3
        case .vendorStatusApplied: return 4
        case .termsUpdated:        return 5
        }
    }
}

// MARK: - Data
enum VendorStatusRequestType: String, Codable, CaseIterable {
    case requestActive
    case requestHidden
    case requestArchived

    static func from(_ action: StatusRequestAction) -> VendorStatusRequestType {
        switch action {
        case .applyForActivation, .resubmitForReview:
            return .requestActive
        case .requestToHide:
            return .requestHidden
        case .requestToArchive:
            return .requestArchived
        }
    }

    var displayName: String {
        switch self {
        case .requestActive:   return String(localized: "vsa.request.activate")
        case .requestHidden:   return String(localized: "vsa.request.hide")
        case .requestArchived: return String(localized: "vsa.request.archive")
        }
    }

    var systemImage: String {
        switch self {
        case .requestActive:   return "checkmark.circle"
        case .requestHidden:   return "eye.slash"
        case .requestArchived: return "archivebox"
        }
    }

    var sortOrder: Int {
        switch self {
        case .requestActive:   return 0
        case .requestHidden:   return 1
        case .requestArchived: return 2
        }
    }
}

enum VendorStatusDecision: String, Codable, CaseIterable {
    case pending
    case approved
    case rejected

    var displayName: String {
        switch self {
        case .pending:  return String(localized: "vsa.decision.pending")
        case .approved: return String(localized: "vsa.decision.approved")
        case .rejected: return String(localized: "vsa.decision.rejected")
        }
    }

    var systemImage: String {
        switch self {
        case .pending:  return "hourglass"
        case .approved: return "checkmark.seal"
        case .rejected: return "xmark.seal"
        }
    }

    var sortOrder: Int {
        switch self {
        case .approved: return 0
        case .rejected: return 1
        case .pending:  return 99
        }
    }
}

// MARK: - UI
enum StatusRequestAction: String, Identifiable {
    var id: String { rawValue }

    case applyForActivation
    case resubmitForReview
    case requestToHide
    case requestToArchive

    var title: String {
        switch self {
        case .applyForActivation: return String(localized: "vsa.action.apply.title")
        case .resubmitForReview:  return String(localized: "vsa.action.resubmit.title")
        case .requestToHide:      return String(localized: "vsa.action.hide.title")
        case .requestToArchive:   return String(localized: "vsa.action.archive.title")
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .applyForActivation: return String(localized: "vsa.action.apply.primary")
        case .resubmitForReview:  return String(localized: "vsa.action.resubmit.primary")
        case .requestToHide:      return String(localized: "vsa.action.hide.primary")
        case .requestToArchive:   return String(localized: "vsa.action.archive.primary")
        }
    }
}

enum StatusRequestResult {
    case submitted(VendorStatusApplication)
    case cancelled
}
