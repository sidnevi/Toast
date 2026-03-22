import SwiftUI
import UIKit

@available(iOS 26.0, *)
struct GlassMorphNotificationStyle {
    var containerSize = CGSize(width: 375, height: 134)
    var notificationFrame = CGRect(x: 12, y: 0, width: 351, height: 134)
    var buttonSize: CGFloat = 56
    var buttonCenter = CGPoint(x: 335, y: 36)
    var glassContainerSpacing: CGFloat = 50
    var splitStartProgress: CGFloat = 0.95
    var preTearStartProgress: CGFloat = 0.968
    var tearProgress: CGFloat = 0.992
    var animationDuration: Double = 0.86
    var contentRevealDelay: Double = 0.8
    var contentRevealDuration: Double = 0.12
    var contentEntryOffset: CGFloat = 12
    var contentEntryBlurRadius: CGFloat = 10
    var contentEntryScale: CGFloat = 0.985
    var footerEntryOffset: CGFloat = 8
    var finalCornerRadius: CGFloat = 32
    var swipeDismissThreshold: CGFloat = 50
    var swipeDismissPredictedThreshold: CGFloat = 120
    var bounceLift: CGFloat = 24
    var bounceHoldDuration: Double = 0.2
    var morphResponse: Double = 0.55
    var morphDampingFraction: Double = 0.68
    var bellLandingLeadTime: Double = 0.11
    var bellLandingCompressionDuration: Double = 0.075
    var bellLandingResponse: Double = 0.32
    var bellLandingDampingFraction: Double = 0.6
    var bellLandingScaleX: CGFloat = 1.055
    var bellLandingScaleY: CGFloat = 0.94

    var notificationCenter: CGPoint {
        CGPoint(x: notificationFrame.midX, y: notificationFrame.midY)
    }

    var footerFrame: CGRect {
        CGRect(
            x: notificationFrame.minX,
            y: notificationFrame.maxY,
            width: notificationFrame.width,
            height: max(containerSize.height - notificationFrame.height, 0)
        )
    }

    var footerCenter: CGPoint {
        CGPoint(x: footerFrame.midX, y: footerFrame.midY)
    }
}

@available(iOS 26.0, *)
struct GlassMorphNotificationView<NotificationContent: View>: View {
    @Binding var isPresented: Bool
    @Binding var showsSourceBell: Bool

    let style: GlassMorphNotificationStyle
    let onDismissMorphStart: (() -> Void)?
    @ViewBuilder let notificationContent: () -> NotificationContent

    @State private var progress: CGFloat = 0
    @State private var isAnimating = false
    @State private var showsContent = false
    @State private var animationTask: Task<Void, Never>?
    @State private var bounceDismissTask: Task<Void, Never>?
    @State private var interactiveDismissOffset: CGFloat = 0
    @State private var dismissSurfaceLift: CGFloat = 0
    @State private var isBounceDismissing = false
    @State private var isBellHandedOff = false
    @State private var bellLandingBounceProgress: CGFloat = 0
    @State private var bellLandingTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            GlassEffectContainer(spacing: style.glassContainerSpacing) {
                notificationSurface
                    .position(seedCenter)
                    .offset(y: surfaceVerticalOffset)
                    .opacity(notificationSurfaceOpacity)
                    .frame(width: style.containerSize.width, height: style.containerSize.height)
            }

            if showsOverlayBellBubble {
                bellBubble
                    .position(style.buttonCenter)
                    .opacity(bellBubbleOpacity)
                    .allowsHitTesting(false)
            }

            bellGlyphLayer
            notificationFooterLayer
            notificationContentLayer
        }
        .frame(width: style.containerSize.width, height: style.containerSize.height)
        .contentShape(Rectangle())
        .gesture(swipeUpToDismissGesture)
        .onAppear {
            syncImmediately(with: isPresented)
        }
        .onDisappear {
            animationTask?.cancel()
            bounceDismissTask?.cancel()
            bellLandingTask?.cancel()
            showsSourceBell = true
            isBellHandedOff = false
            bellLandingBounceProgress = 0
        }
        .onChange(of: isPresented) { _, newValue in
            scheduleAnimation(for: newValue)
        }
    }

    private var bellBubble: some View {
        let bubble = Circle()

        return ZStack {
            bubble
                .fill(.clear)
                .frame(width: style.buttonSize, height: style.buttonSize)
                .glassEffect(in: bubble)
        }
        .scaleEffect(x: bellBubbleScaleX, y: bellBubbleScaleY)
    }

    private var notificationSurface: some View {
        let shape = RoundedRectangle(cornerRadius: notificationCornerRadius, style: .continuous)

        return shape
            .fill(.clear)
            .frame(width: notificationWidth, height: notificationHeight)
            .scaleEffect(x: notificationSurfaceScaleX, y: notificationSurfaceScaleY)
            .glassEffect(in: shape)
    }

    private var bellGlyphLayer: some View {
        NotificationBellGlyphVisual(size: style.buttonSize)
            .position(style.buttonCenter)
            .opacity(bellBubbleOpacity)
            .scaleEffect(x: bellScaleX, y: bellScaleY)
            .allowsHitTesting(false)
    }

    private var notificationContentLayer: some View {
        notificationContent()
            .frame(width: style.notificationFrame.width, height: style.notificationFrame.height)
            .opacity(contentOpacity)
            .scaleEffect(contentScale, anchor: .center)
            .offset(y: contentVerticalOffset)
            .blur(radius: contentBlurRadius, opaque: false)
            .position(seedCenter)
            .offset(y: surfaceVerticalOffset)
            .mask {
                RoundedRectangle(cornerRadius: notificationCornerRadius, style: .continuous)
                    .frame(width: notificationWidth, height: notificationHeight)
                    .position(seedCenter)
            }
            .allowsHitTesting(false)
    }

    private var notificationFooterLayer: some View {
        Group {
            if style.footerFrame.height > 0 {
                NotificationFooterView(
                    style: .init(size: style.footerFrame.size)
                )
                .opacity(footerOpacity)
                .scaleEffect(footerScale, anchor: .center)
                .position(style.footerCenter)
                .offset(y: surfaceVerticalOffset + footerVerticalOffset)
                .blur(radius: footerBlurRadius, opaque: false)
                .allowsHitTesting(false)
            }
        }
    }

    private var swipeUpToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else { return }
                interactiveDismissOffset = max(-style.bounceLift, min(0, value.translation.height))
            }
            .onEnded { value in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else { return }
                let shouldDismiss =
                    value.translation.height < -style.swipeDismissThreshold ||
                    value.predictedEndTranslation.height < -style.swipeDismissPredictedThreshold

                if shouldDismiss {
                    startBounceDismissal()
                } else {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
                        interactiveDismissOffset = 0
                    }
                }
            }
    }

    private var surfaceVerticalOffset: CGFloat {
        interactiveDismissOffset + dismissSurfaceLift
    }

    private var seedCenter: CGPoint {
        let seedTravel = softenedSegment(progress, start: 0.06, end: 0.88)
        return CGPoint(
            x: lerp(style.buttonCenter.x, style.notificationCenter.x, seedTravel),
            y: lerp(style.buttonCenter.y, style.notificationCenter.y, seedTravel)
        )
    }

    private var notificationWidth: CGFloat {
        if progress < 0.34 {
            return lerp(style.buttonSize, 72, softenedSegment(progress, start: 0, end: 0.34))
        }
        return lerp(
            62,
            style.notificationFrame.width,
            softenedSegment(progress, start: 0.34, end: 0.9)
        )
    }

    private var notificationHeight: CGFloat {
        if progress < 0.34 {
            return lerp(style.buttonSize, 48, softenedSegment(progress, start: 0, end: 0.34))
        }
        return lerp(
            48,
            style.notificationFrame.height,
            softenedSegment(progress, start: 0.34, end: 0.9)
        )
    }

    private var notificationCornerRadius: CGFloat {
        let initialRadius = style.buttonSize / 2
        return lerp(
            initialRadius,
            style.finalCornerRadius,
            softenedSegment(progress, start: 0.18, end: 0.9)
        )
    }

    private var notificationOpacity: CGFloat {
        lerp(0.92, 1, progress)
    }

    private var notificationSurfaceOpacity: CGFloat {
        let baseOpacity = (isBellHandedOff || progress > 0.001) ? notificationOpacity : 0
        return baseOpacity * (1 - bellLandingHandoffProgress)
    }

    private var bellBubbleOpacity: CGFloat {
        (showsSourceBell || isBellHandedOff) ? 1 : 0
    }

    private var showsDetachedBellBubble: Bool {
        isPresented &&
            !isAnimating &&
            !isBounceDismissing &&
            !isBellHandedOff &&
            showsSourceBell &&
            showsContent &&
            progress >= 0.999
    }

    private var showsOverlayBellBubble: Bool {
        showsSourceBell || isBellHandedOff || showsDetachedBellBubble
    }

    private var contentOpacity: CGFloat {
        showsContent ? 1 : 0
    }

    private var contentScale: CGFloat {
        showsContent ? 1 : style.contentEntryScale
    }

    private var contentVerticalOffset: CGFloat {
        showsContent ? 0 : style.contentEntryOffset
    }

    private var contentBlurRadius: CGFloat {
        showsContent ? 0 : style.contentEntryBlurRadius
    }

    private var footerOpacity: CGFloat {
        showsContent ? 1 : 0
    }

    private var footerScale: CGFloat {
        showsContent ? 1 : 0.992
    }

    private var footerVerticalOffset: CGFloat {
        showsContent ? 0 : style.footerEntryOffset
    }

    private var footerBlurRadius: CGFloat {
        showsContent ? 0 : style.contentEntryBlurRadius * 0.55
    }

    private var bellScaleX: CGFloat {
        let press = softenedSegment(progress, start: 0, end: 0.34)
        let release = softenedSegment(progress, start: 0.34, end: 0.68)
        if progress < 0.34 {
            return lerp(1, 1.045, press)
        }
        return lerp(1.045, 1, release)
    }

    private var bellScaleY: CGFloat {
        let press = softenedSegment(progress, start: 0, end: 0.34)
        let release = softenedSegment(progress, start: 0.34, end: 0.68)
        if progress < 0.34 {
            return lerp(1, 0.96, press)
        }
        return lerp(0.96, 1, release)
    }

    private var bellBubbleScaleX: CGFloat {
        bellScaleX *
            lerp(1, 1.012, bellLandingHandoffProgress) *
            lerp(1, style.bellLandingScaleX, bellLandingBounceProgress)
    }

    private var bellBubbleScaleY: CGFloat {
        bellScaleY *
            lerp(1, 0.988, bellLandingHandoffProgress) *
            lerp(1, style.bellLandingScaleY, bellLandingBounceProgress)
    }

    private var notificationSurfaceScaleX: CGFloat {
        lerp(1, 1.01, bellLandingHandoffProgress)
    }

    private var notificationSurfaceScaleY: CGFloat {
        lerp(1, 0.99, bellLandingHandoffProgress)
    }

    private var bellLandingHandoffProgress: CGFloat {
        guard !isPresented, !isBellHandedOff else { return 0 }
        return 1 - softenedSegment(progress, start: 0.02, end: 0.12)
    }

    private func scheduleAnimation(for presented: Bool) {
        animationTask?.cancel()
        animationTask = Task { @MainActor in
            if presented {
                await playPresentation()
            } else {
                await playDismissal()
            }
        }
    }

    private var morphAnimation: Animation {
        .spring(
            response: style.morphResponse,
            dampingFraction: style.morphDampingFraction,
            blendDuration: 0
        )
    }

    private var contentRevealAnimation: Animation {
        .easeOut(duration: style.contentRevealDuration)
    }

    private var contentHideAnimation: Animation {
        .easeInOut(duration: max(style.contentRevealDuration * 0.82, 0.12))
    }

    @MainActor
    private func syncImmediately(with presented: Bool) {
        animationTask?.cancel()
        bounceDismissTask?.cancel()
        bellLandingTask?.cancel()
        interactiveDismissOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        bellLandingBounceProgress = 0

        if presented {
            progress = 1
            showsContent = true
            isBellHandedOff = false
            showsSourceBell = true
        } else {
            progress = 0
            showsContent = false
            isBellHandedOff = false
            showsSourceBell = true
        }
    }

    @MainActor
    private func playPresentation() async {
        guard !isAnimating else { return }

        let feedback = UIImpactFeedbackGenerator(style: .soft)
        feedback.prepare()
        feedback.impactOccurred(intensity: 0.9)

        isAnimating = true
        interactiveDismissOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        bellLandingTask?.cancel()
        bellLandingBounceProgress = 0
        isBellHandedOff = true
        showsSourceBell = false
        showsContent = false

        withAnimation(morphAnimation) {
            progress = 1
        }

        try? await Task.sleep(nanoseconds: UInt64(style.contentRevealDelay * 1_000_000_000))
        guard !Task.isCancelled, isPresented else { return }

        withAnimation(contentRevealAnimation) {
            showsContent = true
        }

        try? await Task.sleep(nanoseconds: UInt64(max(style.animationDuration - style.contentRevealDelay, 0) * 1_000_000_000))
        guard !Task.isCancelled else { return }
        showsSourceBell = true
        isBellHandedOff = false
        isAnimating = false
    }

    @MainActor
    private func playDismissal() async {
        guard !isAnimating else { return }
        isAnimating = true
        bounceDismissTask?.cancel()
        bellLandingTask?.cancel()
        isBellHandedOff = false
        bellLandingBounceProgress = 0

        withAnimation(contentHideAnimation) {
            showsContent = false
        }

        let sourceBellReturnDelay = min(style.contentRevealDuration * 0.35, 0.10)
        try? await Task.sleep(nanoseconds: UInt64(sourceBellReturnDelay * 1_000_000_000))
        guard !Task.isCancelled else { return }

        showsSourceBell = true
        onDismissMorphStart?()

        withAnimation(morphAnimation) {
            progress = 0
            interactiveDismissOffset = 0
            dismissSurfaceLift = 0
        }

        scheduleBellLandingBounce()

        try? await Task.sleep(nanoseconds: UInt64(style.animationDuration * 1_000_000_000))
        guard !Task.isCancelled else { return }
        showsSourceBell = true
        isBellHandedOff = false
        isBounceDismissing = false
        isAnimating = false
    }

    private func startBounceDismissal() {
        bounceDismissTask?.cancel()
        bounceDismissTask = Task { @MainActor in
            isBounceDismissing = true

            withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
                interactiveDismissOffset = 0
                dismissSurfaceLift = -style.bounceLift
            }

            try? await Task.sleep(nanoseconds: UInt64(style.bounceHoldDuration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            isPresented = false
        }
    }

    private func scheduleBellLandingBounce() {
        bellLandingTask?.cancel()
        bellLandingTask = Task { @MainActor in
            let impactDelay = max(style.animationDuration - style.bellLandingLeadTime, 0)

            if impactDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(impactDelay * 1_000_000_000))
            }

            guard !Task.isCancelled, !isPresented else { return }

            withAnimation(.easeOut(duration: style.bellLandingCompressionDuration)) {
                bellLandingBounceProgress = 1
            }

            try? await Task.sleep(
                nanoseconds: UInt64(style.bellLandingCompressionDuration * 0.75 * 1_000_000_000)
            )

            guard !Task.isCancelled else { return }

            withAnimation(
                .spring(
                    response: style.bellLandingResponse,
                    dampingFraction: style.bellLandingDampingFraction,
                    blendDuration: 0
                )
            ) {
                bellLandingBounceProgress = 0
            }
        }
    }

    private func segment(_ value: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
        guard end > start else { return 0 }
        return min(max((value - start) / (end - start), 0), 1)
    }

    private func softenedSegment(_ value: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
        smoothStep(segment(value, start: start, end: end))
    }

    private func smoothStep(_ value: CGFloat) -> CGFloat {
        value * value * (3 - (2 * value))
    }

    private func lerp(_ from: CGFloat, _ to: CGFloat, _ t: CGFloat) -> CGFloat {
        from + (to - from) * t
    }
}

@available(iOS 26.0, *)
private struct BottomPinchedMask: Shape {
    let cornerRadius: CGFloat
    let pinch: CGFloat

    func path(in rect: CGRect) -> Path {
        let radius = min(cornerRadius, min(rect.width, rect.height) / 2)
        let insetDepth = rect.height * 0.24 * pinch
        let neckHalfWidth = max(rect.width * (0.12 - 0.07 * pinch), rect.width * 0.045)
        let shoulder = rect.width * 0.11
        let bottomY = rect.maxY
        let pinchY = bottomY - insetDepth
        let centerX = rect.midX

        var path = Path()
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + radius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: centerX + neckHalfWidth + shoulder, y: bottomY))
        path.addQuadCurve(
            to: CGPoint(x: centerX + neckHalfWidth, y: pinchY),
            control: CGPoint(x: centerX + neckHalfWidth + shoulder * 0.45, y: bottomY)
        )
        path.addQuadCurve(
            to: CGPoint(x: centerX - neckHalfWidth, y: pinchY),
            control: CGPoint(x: centerX, y: pinchY - insetDepth * 0.2)
        )
        path.addQuadCurve(
            to: CGPoint(x: centerX - neckHalfWidth - shoulder, y: bottomY),
            control: CGPoint(x: centerX - neckHalfWidth - shoulder * 0.45, y: bottomY)
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: bottomY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.closeSubpath()
        return path
    }
}
