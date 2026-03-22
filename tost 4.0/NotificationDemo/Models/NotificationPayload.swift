import Foundation

enum NotificationPayload: Hashable {
    case inApp(InAppNotificationContent)
    case push(PushNotificationContent)
    case event(EventNotificationContent)
}

struct InAppNotificationContent: Hashable {
    let foregroundSVG: String
}

struct PushNotificationContent: Hashable {
    let appName: String
    let title: String
    let message: String
    let accessoryText: String?
}

struct EventNotificationContent: Hashable {
    struct Detail: Identifiable, Hashable {
        let id: String
        let title: String
        let value: String
    }

    let eyebrow: String?
    let title: String
    let message: String
    let details: [Detail]
    let foregroundSVG: String?
    let preferredHeight: CGFloat

    init(
        eyebrow: String?,
        title: String,
        message: String,
        details: [Detail],
        foregroundSVG: String? = nil,
        preferredHeight: CGFloat = 114
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.message = message
        self.details = details
        self.foregroundSVG = foregroundSVG
        self.preferredHeight = preferredHeight
    }
}
