import SwiftUI

struct NotificationPresenter<NotificationContent: View>: View {
    @Binding var isPresented: Bool
    @Binding var showsSourceBell: Bool
    @Binding var isSourceBellFilled: Bool
    @Binding var isSourceBellCritical: Bool

    let allowsInteractiveDismiss: Bool
    let glassStyle: GlassMorphNotificationStyle
    let liquidConfig: LiquidNotificationConfig
    let liquidNotificationText: String
    let liquidOffset: CGSize
    let onDismissMorphStart: (() -> Void)?
    @ViewBuilder let notificationContent: () -> NotificationContent

    var body: some View {
        Group {
            if #available(iOS 26.0, *) {
                GlassMorphNotificationView(
                    isPresented: $isPresented,
                    showsSourceBell: $showsSourceBell,
                    isSourceBellFilled: $isSourceBellFilled,
                    isSourceBellCritical: $isSourceBellCritical,
                    allowsInteractiveDismiss: allowsInteractiveDismiss,
                    style: glassStyle,
                    onDismissMorphStart: onDismissMorphStart,
                    notificationContent: notificationContent
                )
                .allowsHitTesting(isPresented)
            } else {
                LiquidNotificationButton(
                    isExpanded: $isPresented,
                    config: liquidConfig,
                    allowsInteractiveDismiss: allowsInteractiveDismiss,
                    notificationText: liquidNotificationText
                )
                .offset(x: liquidOffset.width, y: liquidOffset.height)
                .allowsHitTesting(isPresented)
            }
        }
    }
}
