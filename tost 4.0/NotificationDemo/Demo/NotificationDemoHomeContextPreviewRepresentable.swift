import SwiftUI

struct NotificationDemoHomeContextPreviewRepresentable: UIViewControllerRepresentable {
    let scenario: NotificationScenario
    @ObservedObject var controller: NotificationAnimationController
    let preferredColorScheme: ColorScheme?
    let dynamicTypeSize: DynamicTypeSize

    func makeUIViewController(context: Context) -> NotificationDemoHomeContextPreviewController {
        NotificationDemoHomeContextPreviewController()
    }

    func updateUIViewController(
        _ uiViewController: NotificationDemoHomeContextPreviewController,
        context: Context
    ) {
        uiViewController.render(
            scenario: scenario,
            controller: controller,
            preferredColorScheme: preferredColorScheme,
            dynamicTypeSize: dynamicTypeSize
        )
    }
}
