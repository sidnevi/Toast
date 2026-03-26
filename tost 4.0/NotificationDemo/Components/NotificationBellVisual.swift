import SwiftUI

struct NotificationBellVisual: View {
    let size: CGFloat
    var isFilled = false
    var isCritical = false

    var body: some View {
        ZStack {
            NotificationBellBubbleBackgroundVisual(size: size)

            NotificationBellOutlineGlyphVisual(size: size)
                .opacity(isFilled ? 0 : 1)
                .scaleEffect(isFilled ? 0.96 : 1)

            NotificationBellFilledGlyphVisual(size: size)
                .opacity(isFilled && !isCritical ? 1 : 0)
                .scaleEffect(isFilled && !isCritical ? 1 : 1.04)

            NotificationBellCriticalGlyphVisual(size: size)
                .opacity(isFilled && isCritical ? 1 : 0)
                .scaleEffect(isFilled && isCritical ? 1 : 1.04)
        }
        .frame(width: size, height: size)
        .animation(.easeInOut(duration: 0.22), value: isFilled)
        .animation(.easeInOut(duration: 0.22), value: isCritical)
    }
}

struct NotificationBellBubbleBackgroundVisual: View {
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.1))
            .frame(width: size, height: size)
    }
}

struct NotificationBellGlyphVisual: View {
    let size: CGFloat

    var body: some View {
        NotificationBellOutlineGlyphVisual(size: size)
    }
}

struct NotificationBellBubbleVisual: View {
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.1))
            .frame(width: size, height: size)
    }
}

struct NotificationBellFilledGlyphVisual: View {
    let size: CGFloat

    var body: some View {
        NotificationBellFilledShape()
            .fill(Color.white)
            .frame(width: size, height: size)
    }
}

struct NotificationBellCriticalGlyphVisual: View {
    let size: CGFloat

    var body: some View {
        NotificationBellFilledShape()
            .fill(Color(red: 1.0, green: 0.30, blue: 0.30))
            .frame(width: size, height: size)
    }
}

private struct NotificationBellOutlineGlyphVisual: View {
    let size: CGFloat

    var body: some View {
        NotificationBellOutlineShape()
            .fill(Color.white, style: FillStyle(eoFill: true))
            .frame(width: size, height: size)
    }
}

private struct NotificationBellOutlineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.addPath(makeBellFootPath(in: rect))
        path.addPath(makeBellOutlineBodyPath(in: rect))

        return path
    }

    private func makeBellFootPath(in rect: CGRect) -> Path {
        let x = rect.width / 40
        let y = rect.height / 40

        var path = Path()
        path.move(to: CGPoint(x: 16.5 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 23.5 * x, y: 27 * y))
        path.addCurve(
            to: CGPoint(x: 20.5 * x, y: 30 * y),
            control1: CGPoint(x: 23.5 * x, y: 28.6569 * y),
            control2: CGPoint(x: 22.1569 * x, y: 30 * y)
        )
        path.addLine(to: CGPoint(x: 19.5 * x, y: 30 * y))
        path.addCurve(
            to: CGPoint(x: 16.5 * x, y: 27 * y),
            control1: CGPoint(x: 17.8431 * x, y: 30 * y),
            control2: CGPoint(x: 16.5 * x, y: 28.6569 * y)
        )
        path.closeSubpath()
        return path
    }

    private func makeBellOutlineBodyPath(in rect: CGRect) -> Path {
        let x = rect.width / 40
        let y = rect.height / 40

        var path = Path()
        path.move(to: CGPoint(x: 20.5 * x, y: 13.1 * y))
        path.addLine(to: CGPoint(x: 19.5 * x, y: 13.1 * y))
        path.addCurve(
            to: CGPoint(x: 15.1 * x, y: 17.5 * y),
            control1: CGPoint(x: 17.0699 * x, y: 13.1 * y),
            control2: CGPoint(x: 15.1 * x, y: 15.0699 * y)
        )
        path.addLine(to: CGPoint(x: 15.1 * x, y: 22.2181 * y))
        path.addCurve(
            to: CGPoint(x: 14.7289 * x, y: 24.4 * y),
            control1: CGPoint(x: 15.1 * x, y: 22.9656 * y),
            control2: CGPoint(x: 14.9731 * x, y: 23.7029 * y)
        )
        path.addLine(to: CGPoint(x: 25.2711 * x, y: 24.4 * y))
        path.addCurve(
            to: CGPoint(x: 24.9 * x, y: 22.2181 * y),
            control1: CGPoint(x: 25.0269 * x, y: 23.7029 * y),
            control2: CGPoint(x: 24.9 * x, y: 22.9656 * y)
        )
        path.addLine(to: CGPoint(x: 24.9 * x, y: 17.5 * y))
        path.addCurve(
            to: CGPoint(x: 20.5 * x, y: 13.1 * y),
            control1: CGPoint(x: 24.9 * x, y: 15.0699 * y),
            control2: CGPoint(x: 22.9301 * x, y: 13.1 * y)
        )
        path.closeSubpath()

        path.move(to: CGPoint(x: 28.1475 * x, y: 24.4 * y))
        path.addCurve(
            to: CGPoint(x: 27.5 * x, y: 22.2181 * y),
            control1: CGPoint(x: 27.7256 * x, y: 23.7518 * y),
            control2: CGPoint(x: 27.5 * x, y: 22.994 * y)
        )
        path.addLine(to: CGPoint(x: 27.5 * x, y: 17.5 * y))
        path.addCurve(
            to: CGPoint(x: 20.5 * x, y: 10.5 * y),
            control1: CGPoint(x: 27.5 * x, y: 13.634 * y),
            control2: CGPoint(x: 24.366 * x, y: 10.5 * y)
        )
        path.addLine(to: CGPoint(x: 19.5 * x, y: 10.5 * y))
        path.addCurve(
            to: CGPoint(x: 12.5 * x, y: 17.5 * y),
            control1: CGPoint(x: 15.634 * x, y: 10.5 * y),
            control2: CGPoint(x: 12.5 * x, y: 13.634 * y)
        )
        path.addLine(to: CGPoint(x: 12.5 * x, y: 22.2181 * y))
        path.addCurve(
            to: CGPoint(x: 11.8525 * x, y: 24.4 * y),
            control1: CGPoint(x: 12.5 * x, y: 22.994 * y),
            control2: CGPoint(x: 12.2744 * x, y: 23.7518 * y)
        )
        path.addCurve(
            to: CGPoint(x: 11.7549 * x, y: 24.5431 * y),
            control1: CGPoint(x: 11.8211 * x, y: 24.4483 * y),
            control2: CGPoint(x: 11.7886 * x, y: 24.496 * y)
        )
        path.addLine(to: CGPoint(x: 10 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 30 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 28.2451 * x, y: 24.5431 * y))
        path.addCurve(
            to: CGPoint(x: 28.1475 * x, y: 24.4 * y),
            control1: CGPoint(x: 28.2114 * x, y: 24.496 * y),
            control2: CGPoint(x: 28.1789 * x, y: 24.4483 * y)
        )
        path.closeSubpath()

        return path
    }
}

private struct NotificationBellFilledShape: Shape {
    func path(in rect: CGRect) -> Path {
        let x = rect.width / 40
        let y = rect.height / 40

        var path = Path()
        path.move(to: CGPoint(x: 16.5 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 23.5 * x, y: 27 * y))
        path.addCurve(
            to: CGPoint(x: 20.5 * x, y: 30 * y),
            control1: CGPoint(x: 23.5 * x, y: 28.6569 * y),
            control2: CGPoint(x: 22.1569 * x, y: 30 * y)
        )
        path.addLine(to: CGPoint(x: 19.5 * x, y: 30 * y))
        path.addCurve(
            to: CGPoint(x: 16.5 * x, y: 27 * y),
            control1: CGPoint(x: 17.8431 * x, y: 30 * y),
            control2: CGPoint(x: 16.5 * x, y: 28.6569 * y)
        )
        path.closeSubpath()

        path.move(to: CGPoint(x: 12.5 * x, y: 17.5 * y))
        path.addCurve(
            to: CGPoint(x: 19.5 * x, y: 10.5 * y),
            control1: CGPoint(x: 12.5 * x, y: 13.634 * y),
            control2: CGPoint(x: 15.634 * x, y: 10.5 * y)
        )
        path.addLine(to: CGPoint(x: 20.5 * x, y: 10.5 * y))
        path.addCurve(
            to: CGPoint(x: 27.5 * x, y: 17.5 * y),
            control1: CGPoint(x: 24.366 * x, y: 10.5 * y),
            control2: CGPoint(x: 27.5 * x, y: 13.634 * y)
        )
        path.addLine(to: CGPoint(x: 27.5 * x, y: 22.2181 * y))
        path.addCurve(
            to: CGPoint(x: 28.2451 * x, y: 24.5431 * y),
            control1: CGPoint(x: 27.5 * x, y: 23.0518 * y),
            control2: CGPoint(x: 27.7605 * x, y: 23.8647 * y)
        )
        path.addLine(to: CGPoint(x: 30 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 10 * x, y: 27 * y))
        path.addLine(to: CGPoint(x: 11.7549 * x, y: 24.5431 * y))
        path.addCurve(
            to: CGPoint(x: 12.5 * x, y: 22.2181 * y),
            control1: CGPoint(x: 12.2395 * x, y: 23.8647 * y),
            control2: CGPoint(x: 12.5 * x, y: 23.0518 * y)
        )
        path.addLine(to: CGPoint(x: 12.5 * x, y: 17.5 * y))
        path.closeSubpath()

        return path
    }
}
