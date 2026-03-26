import Foundation

enum NotificationCandidatePreset: String, CaseIterable, Identifiable, Hashable {
    case onlyStack
    case stackAndPush
    case pushAndInApp
    case stackPushInApp
    case multiplePush
    case multipleStack
    case multipleInApp

    var id: String { rawValue }

    var title: String {
        switch self {
        case .onlyStack:
            return "Only Stack"
        case .stackAndPush:
            return "Stack + Push"
        case .pushAndInApp:
            return "Push + In-App"
        case .stackPushInApp:
            return "Stack + Push + In-App"
        case .multiplePush:
            return "Many Push"
        case .multipleStack:
            return "Many Stack"
        case .multipleInApp:
            return "Many In-App"
        }
    }

    var subtitle: String {
        switch self {
        case .onlyStack:
            return "Shows a stack event when it is the only active source."
        case .stackAndPush:
            return "Shows why stack outranks a critical push."
        case .pushAndInApp:
            return "Shows critical push winning when no stack event exists."
        case .stackPushInApp:
            return "Shows the full priority ladder with all three sources."
        case .multiplePush:
            return "Several critical push candidates of the same priority."
        case .multipleStack:
            return "Several stack events with mock internal product ordering."
        case .multipleInApp:
            return "Several in-app candidates with mock RTB ranking."
        }
    }
}

enum NotificationCandidateCatalog {
    static func candidates(for preset: NotificationCandidatePreset) -> [NotificationCandidate] {
        switch preset {
        case .onlyStack:
            return [
                .init(
                    id: "candidate.stack.only",
                    scenarioID: NotificationScenarioCatalog.richEvent.id,
                    source: .stackEvent,
                    sourceLabel: "AML Check",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 1,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Only active stack event."
                )
            ]
        case .stackAndPush:
            return [
                .init(
                    id: "candidate.stack.priority",
                    scenarioID: NotificationScenarioCatalog.actionRequiredEvent.id,
                    source: .stackEvent,
                    sourceLabel: "Product Onboarding",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 1,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Live status from backend."
                ),
                .init(
                    id: "candidate.push.critical",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Critical Push",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 23, hour: 11, minute: 40),
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "One-shot notification."
                )
            ]
        case .pushAndInApp:
            return [
                .init(
                    id: "candidate.push.critical.only",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Critical Push",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 23, hour: 12, minute: 10),
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Needs attention."
                ),
                .init(
                    id: "candidate.inapp.crosssell",
                    scenarioID: NotificationScenarioCatalog.currentInApp.id,
                    source: .inApp,
                    sourceLabel: "RTB Cross-Sell",
                    sourceSelectionRule: "Highest RTB score",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: 0.81,
                    rtbRank: 2,
                    note: "Fallback marketing slot."
                )
            ]
        case .stackPushInApp:
            return [
                .init(
                    id: "candidate.stack.full",
                    scenarioID: NotificationScenarioCatalog.richEvent.id,
                    source: .stackEvent,
                    sourceLabel: "AML Check",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 1,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Current backend status."
                ),
                .init(
                    id: "candidate.push.full",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Critical Push",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 23, hour: 11, minute: 55),
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Could already be outdated."
                ),
                .init(
                    id: "candidate.inapp.full",
                    scenarioID: NotificationScenarioCatalog.currentInApp.id,
                    source: .inApp,
                    sourceLabel: "RTB Cross-Sell",
                    sourceSelectionRule: "Highest RTB score",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: 0.76,
                    rtbRank: 3,
                    note: "Lowest-priority fallback."
                )
            ]
        case .multiplePush:
            return [
                .init(
                    id: "candidate.push.oldest",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Penalty Reminder",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 21, hour: 8, minute: 0),
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Unread but older."
                ),
                .init(
                    id: "candidate.push.read",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Credit Delay",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 23, hour: 10, minute: 5),
                    isUnread: false,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Read notification should lose."
                ),
                .init(
                    id: "candidate.push.freshest",
                    scenarioID: NotificationScenarioCatalog.criticalInfoPush.id,
                    source: .criticalPush,
                    sourceLabel: "Tax Alert",
                    sourceSelectionRule: "Freshest unread",
                    createdAt: date(year: 2026, month: 3, day: 23, hour: 13, minute: 15),
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Freshest unread push should win."
                )
            ]
        case .multipleStack:
            return [
                .init(
                    id: "candidate.stack.second",
                    scenarioID: NotificationScenarioCatalog.pendingEvent.id,
                    source: .stackEvent,
                    sourceLabel: "Account Restriction",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 2,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Lower internal priority."
                ),
                .init(
                    id: "candidate.stack.first",
                    scenarioID: NotificationScenarioCatalog.actionRequiredEvent.id,
                    source: .stackEvent,
                    sourceLabel: "AML Check",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 1,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Highest-priority stack event."
                ),
                .init(
                    id: "candidate.stack.third",
                    scenarioID: NotificationScenarioCatalog.errorEvent.id,
                    source: .stackEvent,
                    sourceLabel: "Product Connection",
                    sourceSelectionRule: "Mock product order",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: 3,
                    rtbScore: nil,
                    rtbRank: nil,
                    note: "Lowest stack priority."
                )
            ]
        case .multipleInApp:
            return [
                .init(
                    id: "candidate.inapp.second",
                    scenarioID: NotificationScenarioCatalog.currentInApp.id,
                    source: .inApp,
                    sourceLabel: "Leasing Promo",
                    sourceSelectionRule: "Highest RTB score",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: 0.67,
                    rtbRank: 2,
                    note: "Good score, but not the best."
                ),
                .init(
                    id: "candidate.inapp.first",
                    scenarioID: NotificationScenarioCatalog.currentInApp.id,
                    source: .inApp,
                    sourceLabel: "Credit Card Offer",
                    sourceSelectionRule: "Highest RTB score",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: 0.91,
                    rtbRank: 1,
                    note: "Top RTB candidate."
                ),
                .init(
                    id: "candidate.inapp.third",
                    scenarioID: NotificationScenarioCatalog.currentInApp.id,
                    source: .inApp,
                    sourceLabel: "Insurance Upsell",
                    sourceSelectionRule: "Highest RTB score",
                    createdAt: nil,
                    isUnread: true,
                    productPriority: nil,
                    rtbScore: 0.51,
                    rtbRank: 3,
                    note: "Lowest RTB score."
                )
            ]
        }
    }

    private static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar(identifier: .gregorian).date(from: components) ?? .distantPast
    }
}
