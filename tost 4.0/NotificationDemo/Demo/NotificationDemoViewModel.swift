import Combine
import SwiftUI

@MainActor
final class NotificationDemoViewModel: ObservableObject {
    @Published var state: NotificationDemoState

    let selectionStore: NotificationSelectionStore
    let animationController: NotificationAnimationController
    private var hasAutoPresentedOnOpen = false

    init(
        selectionStore: NotificationSelectionStore,
        animationController: NotificationAnimationController
    ) {
        self.selectionStore = selectionStore
        self.animationController = animationController
        self.state = NotificationDemoState()
        self.animationController.setShowsSourceBell(state.showsSourceBell)
    }

    convenience init(selectionStore: NotificationSelectionStore) {
        self.init(
            selectionStore: selectionStore,
            animationController: NotificationAnimationController()
        )
    }

    var scenariosForSelectedKind: [NotificationScenario] {
        selectionStore.scenariosForSelectedKind
    }

    var selectedScenario: NotificationScenario {
        selectionStore.selectedScenario
    }

    func selectKind(_ kind: NotificationKind) {
        guard selectionStore.selectedKind != kind else { return }
        selectionStore.selectKind(kind)
        handleScenarioMutation()
    }

    func selectScenario(id: String) {
        guard selectionStore.selectedScenarioID != id else { return }
        selectionStore.selectScenario(id: id)
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
