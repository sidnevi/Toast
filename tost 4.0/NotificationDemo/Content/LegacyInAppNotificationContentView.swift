import SwiftUI

struct LegacyInAppNotificationContentView: View {
    let model: InAppNotificationContent

    var body: some View {
        InAppNotificationView(model: model)
    }
}
