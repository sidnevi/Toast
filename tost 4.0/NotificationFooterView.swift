import SwiftUI

struct NotificationFooterView: View {
    struct Style {
        var size = CGSize(width: 351, height: 20)
        var cardTint = Color.white.opacity(0.1)
    }

    var style = Style()

    var body: some View {
        GeometryReader { proxy in
            let scaleX = proxy.size.width / FooterLayout.canvasSize.width
            let scaleY = proxy.size.height / FooterLayout.canvasSize.height

            ZStack(alignment: .topLeading) {
                FooterHighlightShape()
                    .fill(style.cardTint)
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .topLeading)

                Circle()
                    .fill(style.cardTint)
                    .frame(
                        width: FooterLayout.indicatorDiameter * scaleX,
                        height: FooterLayout.indicatorDiameter * scaleY
                    )
                    .position(
                        x: FooterLayout.indicatorCenter.x * scaleX,
                        y: FooterLayout.indicatorCenter.y * scaleY
                    )
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
        .frame(width: style.size.width, height: style.size.height, alignment: .leading)
    }
}

private enum FooterLayout {
    static let canvasSize = CGSize(width: 351, height: 20)
    static let indicatorCenter = CGPoint(x: 319, y: 16)
    static let indicatorDiameter: CGFloat = 10
}

private struct FooterHighlightShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 303.922, y: 0))
        path.addLine(to: CGPoint(x: 312.068, y: 0))
        path.addLine(to: CGPoint(x: 326, y: 0))
        path.addCurve(
            to: CGPoint(x: 319.376, y: 4.98743),
            control1: CGPoint(x: 322.927, y: 0),
            control2: CGPoint(x: 320.225, y: 2.03425)
        )
        path.addLine(to: CGPoint(x: 319.017, y: 6.23681))
        path.addCurve(
            to: CGPoint(x: 312.426, y: 8.59135),
            control1: CGPoint(x: 318.203, y: 9.06856),
            control2: CGPoint(x: 314.85, y: 10.2662)
        )
        path.addLine(to: CGPoint(x: 307.388, y: 5.11047))
        path.addCurve(
            to: CGPoint(x: 291, y: 0),
            control1: CGPoint(x: 302.571, y: 1.78253),
            control2: CGPoint(x: 296.855, y: 0)
        )
        path.addLine(to: CGPoint(x: 303.922, y: 0))
        path.closeSubpath()

        return path
    }
}

struct NotificationFooterView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            NotificationFooterView()
        }
        .frame(width: 375, height: 40)
    }
}
