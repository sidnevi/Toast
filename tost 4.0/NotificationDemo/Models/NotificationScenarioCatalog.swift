import Foundation

enum NotificationScenarioCatalog {
    static let currentInApp = NotificationScenario(
        id: "in-app.current-home-toast",
        title: "Current In-App Toast",
        kind: .inApp,
        payload: .inApp(
            InAppNotificationContent(
                foregroundSVG: toastForegroundSVG
            )
        ),
        actions: []
    )

    static let longInApp = NotificationScenario(
        id: "in-app.long-message",
        title: "Long In-App",
        kind: .inApp,
        payload: .inApp(
            InAppNotificationContent(
                foregroundSVG: toastForegroundSVG
            )
        ),
        actions: []
    )

    static let compactPush = NotificationScenario(
        id: "push.compact",
        title: "Compact Push",
        kind: .push,
        payload: .push(
            PushNotificationContent(
                appName: "Toast",
                title: "Новое уведомление",
                message: "Компактный push с коротким текстом.",
                accessoryText: "Сейчас"
            )
        ),
        actions: []
    )

    static let actionPush = NotificationScenario(
        id: "push.with-action",
        title: "Push With CTA",
        kind: .push,
        payload: .push(
            PushNotificationContent(
                appName: "Toast",
                title: "Платеж требует подтверждения",
                message: "Откройте главный экран, чтобы подтвердить действие и проверить детали операции.",
                accessoryText: "1 мин назад"
            )
        ),
        actions: [
            NotificationAction(id: "push.open", title: "Открыть", style: .primary)
        ]
    )

    static let richEvent = NotificationScenario(
        id: "event.long-running",
        title: "Long Running Event",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Для продолжительных событий",
                message: "Статус с прогресс-баром.",
                details: [],
                foregroundSVG: eventLongRunningSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let minimalEvent = NotificationScenario(
        id: "event.error-alert",
        title: "Error Alert",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Ошибка - алерт",
                message: "Аварийный статус события.",
                details: [],
                foregroundSVG: eventErrorAlertSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let errorEvent = NotificationScenario(
        id: "event.error",
        title: "Error",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Ошибка",
                message: "Ошибка в статусе события.",
                details: [],
                foregroundSVG: eventErrorSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let successEvent = NotificationScenario(
        id: "event.success",
        title: "Success",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Успех",
                message: "Успешный статус события.",
                details: [],
                foregroundSVG: eventSuccessSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let actionRequiredEvent = NotificationScenario(
        id: "event.action-required",
        title: "Action Required",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Действие требует внимания",
                message: "Статус, требующий реакции пользователя.",
                details: [],
                foregroundSVG: eventActionRequiredSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let pendingEvent = NotificationScenario(
        id: "event.pending",
        title: "Pending",
        kind: .event,
        payload: .event(
            EventNotificationContent(
                eyebrow: "Событие",
                title: "Ожидание",
                message: "Статус ожидания.",
                details: [],
                foregroundSVG: eventPendingSVG,
                preferredHeight: 74
            )
        ),
        actions: [
            NotificationAction(id: "event.review", title: "Проверить", style: .primary)
        ]
    )

    static let all: [NotificationScenario] = [
        currentInApp,
        longInApp,
        compactPush,
        actionPush,
        richEvent,
        minimalEvent,
        errorEvent,
        successEvent,
        actionRequiredEvent,
        pendingEvent
    ]

    static func scenarios(for kind: NotificationKind) -> [NotificationScenario] {
        all.filter { $0.kind == kind }
    }

    static func defaultScenario(for kind: NotificationKind) -> NotificationScenario {
        scenarios(for: kind).first ?? currentInApp
    }
}
