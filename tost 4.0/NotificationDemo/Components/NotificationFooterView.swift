import SwiftUI

struct NotificationFooterView: View {
    enum Variant {
        case inApp
        case push
        case event
    }

    struct Style {
        var size = CGSize(width: 351, height: 20)
        var cardTint = Color.white.opacity(0.1)
        var variant: Variant = .inApp
    }

    var style = Style()

    var body: some View {
        GeometryReader { proxy in
            let scaleX = proxy.size.width / FooterLayout.canvasSize.width
            let scaleY = proxy.size.height / FooterLayout.canvasSize.height

            ZStack(alignment: .topLeading) {
                FooterHighlightShape(variant: style.variant)
                    .fill(tailTint)
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .topLeading)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
        .frame(width: style.size.width, height: style.size.height, alignment: .leading)
    }

    private var tailTint: Color {
        switch style.variant {
        case .event:
            return Color(red: 39 / 255, green: 28 / 255, blue: 30 / 255)
        case .inApp, .push:
            return style.cardTint
        }
    }
}

struct NotificationUnifiedSurfaceShape: Shape {
    let cornerRadius: CGFloat
    let footerHeight: CGFloat
    let variant: NotificationFooterView.Variant

    func path(in rect: CGRect) -> Path {
        let bodyHeight = max(rect.height - footerHeight, 0)
        let bodyRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: bodyHeight)

        guard footerHeight > 0.1 else {
            return RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .path(in: bodyRect)
        }

        let radius = min(cornerRadius, min(bodyRect.width, bodyRect.height) / 2)
        let scaleX = rect.width / FooterLayout.canvasSize.width
        let scaleY = footerHeight / FooterLayout.canvasSize.height
        let shiftX = horizontalShift(for: variant)

        let tailLeft = rect.minX + (291 + shiftX) * scaleX
        let tailShoulderLeft = rect.minX + (307.388 + shiftX) * scaleX
        let tailNotchLeft = rect.minX + (312.426 + shiftX) * scaleX
        let tailNotchRight = rect.minX + (319.017 + shiftX) * scaleX
        let tailShoulderRight = rect.minX + min(319, 326 + shiftX) * scaleX
        let tailBottomY = bodyRect.maxY + 8.59135 * scaleY
        let tailJoinY = bodyRect.maxY

        var path = Path()
        path.move(to: CGPoint(x: bodyRect.minX + radius, y: bodyRect.minY))
        path.addLine(to: CGPoint(x: bodyRect.maxX - radius, y: bodyRect.minY))
        path.addQuadCurve(
            to: CGPoint(x: bodyRect.maxX, y: bodyRect.minY + radius),
            control: CGPoint(x: bodyRect.maxX, y: bodyRect.minY)
        )
        path.addLine(to: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: bodyRect.maxX - radius, y: bodyRect.maxY),
            control: CGPoint(x: bodyRect.maxX, y: bodyRect.maxY)
        )
        path.addLine(to: CGPoint(x: tailShoulderRight, y: tailJoinY))
        path.addCurve(
            to: CGPoint(x: tailNotchRight, y: bodyRect.maxY + 6.23681 * scaleY),
            control1: CGPoint(x: tailShoulderRight - 3.073 * scaleX, y: tailJoinY),
            control2: CGPoint(x: tailNotchRight + 1.208 * scaleX, y: bodyRect.maxY + 2.03425 * scaleY)
        )
        path.addCurve(
            to: CGPoint(x: tailNotchLeft, y: tailBottomY),
            control1: CGPoint(x: tailNotchRight - 0.814 * scaleX, y: bodyRect.maxY + 9.06856 * scaleY),
            control2: CGPoint(x: tailNotchLeft + 2.424 * scaleX, y: bodyRect.maxY + 10.2662 * scaleY)
        )
        path.addLine(to: CGPoint(x: tailShoulderLeft, y: bodyRect.maxY + 5.11047 * scaleY))
        path.addCurve(
            to: CGPoint(x: tailLeft, y: tailJoinY),
            control1: CGPoint(x: tailShoulderLeft - 4.817 * scaleX, y: bodyRect.maxY + 1.78253 * scaleY),
            control2: CGPoint(x: tailLeft + 5.855 * scaleX, y: tailJoinY)
        )
        path.addLine(to: CGPoint(x: bodyRect.minX + radius, y: bodyRect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: bodyRect.minX, y: bodyRect.maxY - radius),
            control: CGPoint(x: bodyRect.minX, y: bodyRect.maxY)
        )
        path.addLine(to: CGPoint(x: bodyRect.minX, y: bodyRect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: bodyRect.minX + radius, y: bodyRect.minY),
            control: CGPoint(x: bodyRect.minX, y: bodyRect.minY)
        )
        path.closeSubpath()

        return path
    }

    private func horizontalShift(for variant: NotificationFooterView.Variant) -> CGFloat {
        switch variant {
        case .inApp, .push, .event:
            return -4
        }
    }
}

private enum FooterLayout {
    static let canvasSize = CGSize(width: 351, height: 20)
}

private struct FooterHighlightShape: Shape {
    let variant: NotificationFooterView.Variant

    func path(in rect: CGRect) -> Path {
        basePath(shiftX: horizontalShift(for: variant))
    }

    private func horizontalShift(for variant: NotificationFooterView.Variant) -> CGFloat {
        switch variant {
        case .inApp, .push, .event:
            return -4
        }
    }

    private func basePath(shiftX: CGFloat) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 303.922 + shiftX, y: 0))
        path.addLine(to: CGPoint(x: 312.068 + shiftX, y: 0))
        path.addLine(to: CGPoint(x: 326 + shiftX, y: 0))
        path.addCurve(
            to: CGPoint(x: 319.376 + shiftX, y: 4.98743),
            control1: CGPoint(x: 322.927 + shiftX, y: 0),
            control2: CGPoint(x: 320.225 + shiftX, y: 2.03425)
        )
        path.addLine(to: CGPoint(x: 319.017 + shiftX, y: 6.23681))
        path.addCurve(
            to: CGPoint(x: 312.426 + shiftX, y: 8.59135),
            control1: CGPoint(x: 318.203 + shiftX, y: 9.06856),
            control2: CGPoint(x: 314.85 + shiftX, y: 10.2662)
        )
        path.addLine(to: CGPoint(x: 307.388 + shiftX, y: 5.11047))
        path.addCurve(
            to: CGPoint(x: 291 + shiftX, y: 0),
            control1: CGPoint(x: 302.571 + shiftX, y: 1.78253),
            control2: CGPoint(x: 296.855 + shiftX, y: 0)
        )
        path.addLine(to: CGPoint(x: 303.922 + shiftX, y: 0))
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
