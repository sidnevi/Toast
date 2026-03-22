import SwiftUI

struct InAppNotificationView: View {
    let model: InAppNotificationContent

    var body: some View {
        InlineSVGWebView(svg: model.foregroundSVG)
            .frame(width: Layout.width, height: Layout.height)
    }
}

private enum Layout {
    static let width: CGFloat = 351
    static let height: CGFloat = 114
}
