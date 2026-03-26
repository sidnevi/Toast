import Foundation

enum NotificationScenarioCatalog {
    static let currentInApp = NotificationScenario(
        id: "in-app.current-home-toast",
        title: "Current In-App Toast",
        kind: .inApp,
        isCriticalAttention: false,
        payload: .inApp(
            InAppNotificationContent(
                foregroundSVG: toastForegroundSVG
            )
        ),
        actions: []
    )

    static let infoPush = NotificationScenario(
        id: "push.info",
        title: "Info",
        kind: .push,
        isCriticalAttention: false,
        payload: .push(
            PushNotificationContent(
                appName: "Toast",
                title: "Информационное уведомление",
                message: "Спокойный push для обычного информирования пользователя.",
                accessoryText: "Сейчас",
                foregroundSVG: pushInfoSVG,
                preferredHeight: 74
            )
        ),
        actions: []
    )

    static let criticalInfoPush = NotificationScenario(
        id: "push.critical-info",
        title: "Critical Info",
        kind: .push,
        isCriticalAttention: true,
        payload: .push(
            PushNotificationContent(
                appName: "Toast",
                title: "Критически важная информация",
                message: "Уведомление требует внимания. Проверьте детали на главной странице.",
                accessoryText: "Только что",
                foregroundSVG: pushCriticalInfoSVG,
                preferredHeight: 92
            )
        ),
        actions: []
    )

    static let richEvent = NotificationScenario(
        id: "event.long-running",
        title: "Long Running Event",
        kind: .event,
        isCriticalAttention: true,
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
        isCriticalAttention: true,
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
        isCriticalAttention: true,
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
        isCriticalAttention: false,
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
        isCriticalAttention: true,
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
        isCriticalAttention: false,
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
        infoPush,
        criticalInfoPush,
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

    static func scenario(id: String) -> NotificationScenario? {
        all.first(where: { $0.id == id })
    }

    static func defaultScenario(for kind: NotificationKind) -> NotificationScenario {
        scenarios(for: kind).first ?? currentInApp
    }
}
