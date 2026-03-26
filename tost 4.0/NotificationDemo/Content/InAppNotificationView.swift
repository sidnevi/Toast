import SwiftUI

struct InAppNotificationView: View {
    let model: InAppNotificationContent

    var body: some View {
        PrewarmedSVGView(
            svg: model.foregroundSVG,
            size: CGSize(width: Layout.width, height: Layout.height)
        )
    }
}

private enum Layout {
    static let width: CGFloat = 351
    static let height: CGFloat = 114
}
