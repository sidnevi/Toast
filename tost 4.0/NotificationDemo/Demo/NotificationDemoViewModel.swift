import Combine
import SwiftUI

@MainActor
final class NotificationDemoViewModel: ObservableObject {
    @Published var state: NotificationDemoState

    let animationController: NotificationAnimationController
    let scenarios: [NotificationScenario]
    private var hasAutoPresentedOnOpen = false

    init(
        scenarios: [NotificationScenario],
        initialKind: NotificationKind,
        animationController: NotificationAnimationController
    ) {
        self.scenarios = scenarios
        self.animationController = animationController

        let initialScenario = NotificationScenarioCatalog.defaultScenario(for: initialKind)
        self.state = NotificationDemoState(
            selectedKind: initialKind,
            selectedScenarioID: initialScenario.id
        )
        self.animationController.setShowsSourceBell(state.showsSourceBell)
    }

    convenience init(initialKind: NotificationKind = .inApp) {
        self.init(
            scenarios: NotificationScenarioCatalog.all,
            initialKind: initialKind,
            animationController: NotificationAnimationController()
        )
    }

    var scenariosForSelectedKind: [NotificationScenario] {
        scenarios.filter { $0.kind == state.selectedKind }
    }

    var selectedScenario: NotificationScenario {
        if let selectedScenarioID = state.selectedScenarioID,
           let selectedScenario = scenarios.first(where: { $0.id == selectedScenarioID }) {
            return selectedScenario
        }

        return NotificationScenarioCatalog.defaultScenario(for: state.selectedKind)
    }

    func selectKind(_ kind: NotificationKind) {
        guard state.selectedKind != kind else { return }

        state.selectedKind = kind
        state.selectedScenarioID = NotificationScenarioCatalog.defaultScenario(for: kind).id
        handleScenarioMutation()
    }

    func selectScenario(id: String) {
        guard state.selectedScenarioID != id else { return }

        state.selectedScenarioID = id
        handleScenarioMutation()
    }

    func setPreviewMode(_ previewMode: NotificationPreviewMode) {
        state.previewMode = previewMode
    }

    func setColorScheme(_ colorScheme: ColorScheme?) {
        state.preferredColorScheme = colorScheme
    }

    func setDynamicTypeSize(_ dynamicTypeSize: DynamicTypeSize) {
        state.dynamicTypeSize = dynamicTypeSize
    }

    func setShowsSourceBell(_ showsSourceBell: Bool) {
        state.showsSourceBell = showsSourceBell
        animationController.setShowsSourceBell(showsSourceBell)
    }

    func setAutoPresentOnOpen(_ autoPresentOnOpen: Bool) {
        state.autoPresentOnOpen = autoPresentOnOpen

        if autoPresentOnOpen {
            handleDemoAppear(force: true)
        }
    }

    func setAutoPresentOnScenarioChange(_ autoPresentOnScenarioChange: Bool) {
        state.autoPresentOnScenarioChange = autoPresentOnScenarioChange
    }

    func handleDemoAppear(force: Bool = false) {
        guard state.autoPresentOnOpen else { return }
        guard force || !hasAutoPresentedOnOpen else { return }

        hasAutoPresentedOnOpen = true
        triggerAnimation()
    }

    func triggerAnimation() {
        animationController.setShowsSourceBell(state.showsSourceBell)

        if animationController.isPresented {
            animationController.reset(showsSourceBell: state.showsSourceBell)
            state.isAnimationPresented = false

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 120_000_000)
                self.state.isAnimationPresented = true
                self.animationController.present()
            }
            return
        }

        state.isAnimationPresented = true
        animationController.present()
    }

    func dismissAnimation() {
        state.isAnimationPresented = false
        animationController.dismiss()
    }

    func resetAnimation() {
        state.isAnimationPresented = false
        animationController.reset(showsSourceBell: state.showsSourceBell)
    }

    private func handleScenarioMutation() {
        resetAnimation()

        if state.autoPresentOnScenarioChange {
            triggerAnimation()
        }
    }
}
