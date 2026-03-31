import Combine
import Foundation

@MainActor
final class NotificationDemoHomeBridge: ObservableObject {
    @Published private(set) var selectedScenarioID: String
    @Published var autoPlayOnHomeSelection = true
    @Published var notificationCenterLayoutMode: NotificationCenterLayoutMode
    @Published private(set) var homePlaybackRequestID: UUID?

    init(
        initialScenarioID: String? = nil,
        initialNotificationCenterLayoutMode: NotificationCenterLayoutMode = .united
    ) {
        self.selectedScenarioID = initialScenarioID ?? NotificationScenarioCatalog.currentInApp.id
        self.notificationCenterLayoutMode = initialNotificationCenterLayoutMode
    }

    var selectedScenario: NotificationScenario {
        NotificationScenarioCatalog.all.first(where: { $0.id == selectedScenarioID })
            ?? NotificationScenarioCatalog.currentInApp
    }

    func setSelectedScenario(id: String, requestPlayback: Bool? = nil) {
        selectedScenarioID = id

        if requestPlayback ?? autoPlayOnHomeSelection {
            homePlaybackRequestID = UUID()
        }
    }

    func requestPlayback(force: Bool = false) {
        guard force || autoPlayOnHomeSelection else { return }
        homePlaybackRequestID = UUID()
    }

    func setNotificationCenterLayoutMode(_ mode: NotificationCenterLayoutMode) {
        notificationCenterLayoutMode = mode
    }
}
