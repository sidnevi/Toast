import Combine
import SwiftUI

@MainActor
final class NotificationSelectionStore: ObservableObject {
    @Published private(set) var selectedKind: NotificationKind
    @Published private(set) var selectedScenarioID: String

    init(initialKind: NotificationKind = .inApp, initialScenarioID: String? = nil) {
        let initialScenario = initialScenarioID
            .flatMap { id in NotificationScenarioCatalog.all.first(where: { $0.id == id }) }
            ?? NotificationScenarioCatalog.defaultScenario(for: initialKind)

        self.selectedKind = initialScenario.kind
        self.selectedScenarioID = initialScenario.id
    }

    var scenariosForSelectedKind: [NotificationScenario] {
        NotificationScenarioCatalog.scenarios(for: selectedKind)
    }

    var selectedScenario: NotificationScenario {
        scenariosForSelectedKind.first(where: { $0.id == selectedScenarioID })
            ?? NotificationScenarioCatalog.defaultScenario(for: selectedKind)
    }

    func selectKind(_ kind: NotificationKind) {
        guard selectedKind != kind else { return }
        selectedKind = kind
        selectedScenarioID = NotificationScenarioCatalog.defaultScenario(for: kind).id
    }

    func selectScenario(id: String) {
        guard selectedScenarioID != id else { return }
        guard let scenario = NotificationScenarioCatalog.all.first(where: { $0.id == id }) else { return }
        selectedKind = scenario.kind
        selectedScenarioID = scenario.id
    }
}
