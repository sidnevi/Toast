import Foundation

struct NotificationScenario: Identifiable, Hashable {
    let id: String
    let title: String
    let kind: NotificationKind
    let payload: NotificationPayload
    let actions: [NotificationAction]
}
