import Foundation

enum NotificationCandidateSource: String, Hashable {
    case stackEvent
    case criticalPush
    case inApp

    nonisolated var title: String {
        switch self {
        case .stackEvent:
            return "Stack Event"
        case .criticalPush:
            return "Critical Push"
        case .inApp:
            return "In-App"
        }
    }

    nonisolated var priorityTitle: String {
        switch self {
        case .stackEvent:
            return "High"
        case .criticalPush:
            return "Medium"
        case .inApp:
            return "Low"
        }
    }

    nonisolated var priorityOrder: Int {
        switch self {
        case .stackEvent:
            return 0
        case .criticalPush:
            return 1
        case .inApp:
            return 2
        }
    }
}

struct NotificationCandidate: Identifiable, Hashable {
    let id: String
    let scenarioID: String
    let source: NotificationCandidateSource
    let sourceLabel: String
    let sourceSelectionRule: String
    let createdAt: Date?
    let isUnread: Bool
    let productPriority: Int?
    let rtbScore: Double?
    let rtbRank: Int?
    let note: String?
}
