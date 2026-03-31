import SwiftUI

struct NotificationDemoState: Equatable {
    var displayMode: NotificationDisplayMode = .single
    var candidatePreset: NotificationCandidatePreset = .stackPushInApp
    var selectedKind: NotificationKind = .inApp
    var notificationCenterLayoutMode: NotificationCenterLayoutMode = .united
    var selectedScenarioID: String?
    var previewMode: NotificationPreviewMode = .homeContext
    var preferredColorScheme: ColorScheme? = nil
    var dynamicTypeSize: DynamicTypeSize = .large
    var showsSourceBell = true
    var autoPresentOnOpen = false
    var autoPresentOnScenarioChange = false
    var isAnimationPresented = false
}
