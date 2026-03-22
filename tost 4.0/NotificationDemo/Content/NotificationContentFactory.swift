import SwiftUI

struct NotificationPresentationMetrics {
    let contentWidth: CGFloat
    let contentHeight: CGFloat
    let containerHeight: CGFloat
}

enum NotificationContentFactory {
    @ViewBuilder
    static func makeView(for scenario: NotificationScenario) -> some View {
        switch scenario.payload {
        case .inApp(let model):
            InAppNotificationView(model: model)
        case .push(let model):
            PushNotificationView(model: model, actions: scenario.actions)
        case .event(let model):
            EventNotificationView(model: model, actions: scenario.actions)
        }
    }

    static func presentationMetrics(for scenario: NotificationScenario) -> NotificationPresentationMetrics {
        switch scenario.payload {
        case .inApp:
            return .init(contentWidth: 351, contentHeight: 114, containerHeight: 134)
        case .push:
            return .init(contentWidth: 351, contentHeight: 114, containerHeight: 134)
        case .event(let model):
            if let foregroundSVG = model.foregroundSVG, !foregroundSVG.isEmpty {
                return .init(
                    contentWidth: 351,
                    contentHeight: model.preferredHeight,
                    containerHeight: model.preferredHeight
                )
            }

            return .init(contentWidth: 351, contentHeight: 114, containerHeight: 134)
        }
    }
}
