import SwiftUI

struct NotificationDemoState: Equatable {
    var previewMode: NotificationPreviewMode = .homeContext
    var preferredColorScheme: ColorScheme? = nil
    var dynamicTypeSize: DynamicTypeSize = .large
    var showsSourceBell = true
    var autoPresentOnOpen = false
    var autoPresentOnScenarioChange = false
    var isAnimationPresented = false
}
