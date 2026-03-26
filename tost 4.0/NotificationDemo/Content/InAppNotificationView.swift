import SwiftUI

struct InAppNotificationView: View {
    let model: InAppNotificationContent

    var body: some View {
        // Keep the in-app card on a live transparent web view.
        // WKWebView snapshots occasionally flatten transparent SVGs onto a light background.
        InlineSVGWebView(svg: model.foregroundSVG)
            .frame(width: Layout.width, height: Layout.height)
    }
}

private enum Layout {
    static let width: CGFloat = 351
    static let height: CGFloat = 114
}
