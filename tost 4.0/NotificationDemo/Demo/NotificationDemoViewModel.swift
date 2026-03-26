import Combine
import SwiftUI

@MainActor
final class NotificationDemoViewModel: ObservableObject {
    @Published var state: NotificationDemoState

    let animationController: NotificationAnimationController
    let scenarios: [NotificationScenario]
    let homeBridge: NotificationDemoHomeBridge
    private var hasAutoPresentedOnOpen = false

    init(
        scenarios: [NotificationScenario],
        initialKind: NotificationKind,
        animationController: NotificationAnimationController,
        homeBridge: NotificationDemoHomeBridge
    ) {
        self.scenarios = scenarios
        self.animationController = animationController
        self.homeBridge = homeBridge

        let initialScenario = NotificationScenarioCatalog.defaultScenario(for: initialKind)
        self.state = NotificationDemoState(
            selectedKind: initialKind,
            selectedScenarioID: initialScenario.id
        )
        self.animationController.setShowsSourceBell(state.showsSourceBell)
        self.homeBridge.setSelectedScenario(id: initialScenario.id, requestPlayback: false)
    }

    convenience init(
        initialKind: NotificationKind = .inApp,
        homeBridge: NotificationDemoHomeBridge
    ) {
        self.init(
            scenarios: NotificationScenarioCatalog.all,
            initialKind: initialKind,
            animationController: NotificationAnimationController(),
            homeBridge: homeBridge
        )
    }

    var scenariosForSelectedKind: [NotificationScenario] {
        scenarios.filter { $0.kind == state.selectedKind }
    }

    var showsScenarioPicker: Bool {
        guard state.displayMode == .single else { return false }
        return state.selectedKind != .inApp && scenariosForSelectedKind.count > 1
    }

    var selectedSingleScenario: NotificationScenario {
        if let selectedScenarioID = state.selectedScenarioID,
           let selectedScenario = scenarios.first(where: { $0.id == selectedScenarioID }) {
            return selectedScenario
        }

        return NotificationScenarioCatalog.defaultScenario(for: state.selectedKind)
    }

    var multipleCandidates: [NotificationCandidate] {
        NotificationCandidateCatalog.candidates(for: state.candidatePreset)
    }

    var selectionResult: NotificationSelectionResult {
        NotificationSelectionEngine.selectWinner(from: multipleCandidates)
    }

    var selectedScenario: NotificationScenario {
        switch state.displayMode {
        case .single:
            return selectedSingleScenario
        case .multiple:
            if let winnerScenarioID = selectionResult.winnerScenarioID,
               let winnerScenario = NotificationScenarioCatalog.scenario(id: winnerScenarioID) {
                return winnerScenario
            }

            return NotificationScenarioCatalog.currentInApp
        }
    }

    var multipleWinnerLabel: String {
        selectedScenario.title
    }

    var selectedCandidatePresetSubtitle: String {
        state.candidatePreset.subtitle
    }

    func selectKind(_ kind: NotificationKind) {
        guard state.selectedKind != kind else { return }

        state.selectedKind = kind
        state.selectedScenarioID = NotificationScenarioCatalog.defaultScenario(for: kind).id
        syncSelectedScenarioToHome()
        handleScenarioMutation()
    }

    func setDisplayMode(_ displayMode: NotificationDisplayMode) {
        guard state.displayMode != displayMode else { return }

        state.displayMode = displayMode
        syncSelectedScenarioToHome()
        handleScenarioMutation()
    }

    func setCandidatePreset(_ candidatePreset: NotificationCandidatePreset) {
        guard state.candidatePreset != candidatePreset else { return }

        state.candidatePreset = candidatePreset
        syncSelectedScenarioToHome()
        handleScenarioMutation()
    }

    func selectScenario(id: String) {
        guard state.selectedScenarioID != id else { return }

        state.selectedScenarioID = id
        syncSelectedScenarioToHome()
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

    func setAutoPlayOnHomeSelection(_ isEnabled: Bool) {
        homeBridge.autoPlayOnHomeSelection = isEnabled
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

    private func syncSelectedScenarioToHome() {
        homeBridge.setSelectedScenario(id: selectedScenario.id)
    }
}
