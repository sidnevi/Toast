import SwiftUI
import UIKit

final class NotificationDemoHomeContextPreviewController: UIViewController {
    private var hostingController: UIHostingController<AnyView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    func render(
        scenario: NotificationScenario,
        controller: NotificationAnimationController,
        preferredColorScheme: ColorScheme?,
        dynamicTypeSize: DynamicTypeSize
    ) {
        let rootView = AnyView(
            NotificationDemoHomeContextCanvas(
                scenario: scenario,
                controller: controller
            )
            .environment(\.dynamicTypeSize, dynamicTypeSize)
        )

        switch preferredColorScheme {
        case .dark:
            overrideUserInterfaceStyle = .dark
        case .light:
            overrideUserInterfaceStyle = .light
        case nil:
            overrideUserInterfaceStyle = .unspecified
        @unknown default:
            overrideUserInterfaceStyle = .unspecified
        }

        if let hostingController {
            hostingController.rootView = rootView
            return
        }

        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
        self.hostingController = hostingController
    }
}
