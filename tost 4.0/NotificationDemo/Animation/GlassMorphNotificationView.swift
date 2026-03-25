import SwiftUI
import UIKit

enum NotificationGlassMotionPreset {
    static let animationDuration: Double = 0.46
    static let contentRevealDelay: Double = 0.16
    static let contentRevealDuration: Double = 0.13
    static let contentEntryOffset: CGFloat = 10
    static let contentEntryBlurRadius: CGFloat = 8
    static let contentEntryScale: CGFloat = 0.992
    static let contentEntryHorizontalOffset: CGFloat = -14
    static let footerEntryOffset: CGFloat = 6

    static let anticipationEndProgress: CGFloat = 0.14
    static let anticipationScaleX: CGFloat = 0.9
    static let anticipationScaleY: CGFloat = 1.08
    static let anticipationLift: CGFloat = 6
    static let midStageWidth: CGFloat = 74
    static let midStageHeight: CGFloat = 44
    static let finalExpansionStartProgress: CGFloat = 0.2
    static let finalExpansionEndProgress: CGFloat = 0.84

    static let morphResponse: Double = 0.31
    static let morphDampingFraction: Double = 0.82

    static let bellRingLeadTime: Double = 0.24
    static let bellRingDuration: Double = 0.30
    static let bellRingAmplitude: CGFloat = 5.5
    static let bellRingCycles: CGFloat = 2.35
    static let bellRingPivotY: CGFloat = 0.12
    static let bellRingWaveInset: CGFloat = 5
    static let bellRingWaveTravel: CGFloat = 7

    static let presentationSettleLeadTime: Double = 0.18
    static let presentationSettleCompressionDuration: Double = 0.06
    static let presentationSettleReturnDuration: Double = 0.09
    static let presentationSettleRevealLeadTime: Double = 0.12
    static let presentationSettleScaleX: CGFloat = 1.04
    static let presentationSettleScaleY: CGFloat = 0.955
}

@available(iOS 26.0, *)
struct GlassMorphNotificationStyle {
    var containerSize = CGSize(width: 375, height: 134)
    var notificationFrame = CGRect(x: 12, y: 0, width: 351, height: 134)
    var footerVariant: NotificationFooterView.Variant = .inApp
    var buttonSize: CGFloat = 56
    var buttonCenter = CGPoint(x: 335, y: 36)
    var glassContainerSpacing: CGFloat = 50
    var splitStartProgress: CGFloat = 0.95
    var preTearStartProgress: CGFloat = 0.968
    var tearProgress: CGFloat = 0.992
    // Общая длина morph-анимации появления.
    var animationDuration: Double = NotificationGlassMotionPreset.animationDuration
    // Через сколько после старта morph начинает раскрываться контент.
    var contentRevealDelay: Double = NotificationGlassMotionPreset.contentRevealDelay
    // Длительность появления контента после раскрытия.
    var contentRevealDuration: Double = NotificationGlassMotionPreset.contentRevealDuration
    var contentEntryOffset: CGFloat = NotificationGlassMotionPreset.contentEntryOffset
    var contentEntryBlurRadius: CGFloat = NotificationGlassMotionPreset.contentEntryBlurRadius
    var contentEntryScale: CGFloat = NotificationGlassMotionPreset.contentEntryScale
    var footerEntryOffset: CGFloat = NotificationGlassMotionPreset.footerEntryOffset
    var finalCornerRadius: CGFloat = 32
    // Ранняя фаза "anticipation": bubble чуть сжимается/тянется перед раскрытием.
    var anticipationEndProgress: CGFloat = NotificationGlassMotionPreset.anticipationEndProgress
    var anticipationScaleX: CGFloat = NotificationGlassMotionPreset.anticipationScaleX
    var anticipationScaleY: CGFloat = NotificationGlassMotionPreset.anticipationScaleY
    var anticipationLift: CGFloat = NotificationGlassMotionPreset.anticipationLift
    // Промежуточная компактная форма перед полным раскрытием.
    var midStageWidth: CGFloat = NotificationGlassMotionPreset.midStageWidth
    var midStageHeight: CGFloat = NotificationGlassMotionPreset.midStageHeight
    var finalExpansionStartProgress: CGFloat = NotificationGlassMotionPreset.finalExpansionStartProgress
    var finalExpansionEndProgress: CGFloat = NotificationGlassMotionPreset.finalExpansionEndProgress
    var swipeDismissThreshold: CGFloat = 50
    var swipeDismissPredictedThreshold: CGFloat = 120
    var bounceLift: CGFloat = 24
    var bounceHoldDuration: Double = 0.2
    // "Пружинистость" основного morph.
    // Меньше = быстрее и резче, больше = мягче и длиннее.
    var morphResponse: Double = NotificationGlassMotionPreset.morphResponse
    var morphDampingFraction: Double = NotificationGlassMotionPreset.morphDampingFraction
    // Небольшой ring колокола на финале dismiss.
    // LeadTime: больше = стартует раньше до конца сворачивания.
    var bellRingLeadTime: Double = NotificationGlassMotionPreset.bellRingLeadTime
    var bellRingDuration: Double = NotificationGlassMotionPreset.bellRingDuration
    var bellRingAmplitude: CGFloat = NotificationGlassMotionPreset.bellRingAmplitude
    var bellRingCycles: CGFloat = NotificationGlassMotionPreset.bellRingCycles
    var bellRingPivotY: CGFloat = NotificationGlassMotionPreset.bellRingPivotY
    var bellRingWaveInset: CGFloat = NotificationGlassMotionPreset.bellRingWaveInset
    var bellRingWaveTravel: CGFloat = NotificationGlassMotionPreset.bellRingWaveTravel
    // Смещение bounce внутри финальной фазы morph.
    // Больше = раньше по таймлайну.
    var presentationSettleLeadTime: Double = NotificationGlassMotionPreset.presentationSettleLeadTime
    // Длительность сжатия перед bounce-back.
    var presentationSettleCompressionDuration: Double = NotificationGlassMotionPreset.presentationSettleCompressionDuration
    // Длительность возврата после сжатия.
    var presentationSettleReturnDuration: Double = NotificationGlassMotionPreset.presentationSettleReturnDuration
    // Насколько раньше запустить bounce относительно reveal.
    // Больше = bounce стартует раньше, ещё до появления контента.
    var presentationSettleRevealLeadTime: Double = NotificationGlassMotionPreset.presentationSettleRevealLeadTime
    // Амплитуда bounce.
    // X > 1 расширяет, Y < 1 сжимает по вертикали.
    var presentationSettleScaleX: CGFloat = NotificationGlassMotionPreset.presentationSettleScaleX
    var presentationSettleScaleY: CGFloat = NotificationGlassMotionPreset.presentationSettleScaleY
    // Лёгкий horizontal catch-up для контента, чтобы он входил вслед за morph.
    var contentEntryHorizontalOffset: CGFloat = NotificationGlassMotionPreset.contentEntryHorizontalOffset

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

    mutating func applySharedMotionPreset() {
        animationDuration = NotificationGlassMotionPreset.animationDuration
        contentRevealDelay = NotificationGlassMotionPreset.contentRevealDelay
        contentRevealDuration = NotificationGlassMotionPreset.contentRevealDuration
        contentEntryOffset = NotificationGlassMotionPreset.contentEntryOffset
        contentEntryBlurRadius = NotificationGlassMotionPreset.contentEntryBlurRadius
        contentEntryScale = NotificationGlassMotionPreset.contentEntryScale
        contentEntryHorizontalOffset = NotificationGlassMotionPreset.contentEntryHorizontalOffset
        footerEntryOffset = NotificationGlassMotionPreset.footerEntryOffset
        anticipationEndProgress = NotificationGlassMotionPreset.anticipationEndProgress
        anticipationScaleX = NotificationGlassMotionPreset.anticipationScaleX
        anticipationScaleY = NotificationGlassMotionPreset.anticipationScaleY
        anticipationLift = NotificationGlassMotionPreset.anticipationLift
        midStageWidth = NotificationGlassMotionPreset.midStageWidth
        midStageHeight = NotificationGlassMotionPreset.midStageHeight
        finalExpansionStartProgress = NotificationGlassMotionPreset.finalExpansionStartProgress
        finalExpansionEndProgress = NotificationGlassMotionPreset.finalExpansionEndProgress
        morphResponse = NotificationGlassMotionPreset.morphResponse
        morphDampingFraction = NotificationGlassMotionPreset.morphDampingFraction
        bellRingLeadTime = NotificationGlassMotionPreset.bellRingLeadTime
        bellRingDuration = NotificationGlassMotionPreset.bellRingDuration
        bellRingAmplitude = NotificationGlassMotionPreset.bellRingAmplitude
        bellRingCycles = NotificationGlassMotionPreset.bellRingCycles
        bellRingPivotY = NotificationGlassMotionPreset.bellRingPivotY
        bellRingWaveInset = NotificationGlassMotionPreset.bellRingWaveInset
        bellRingWaveTravel = NotificationGlassMotionPreset.bellRingWaveTravel
        presentationSettleLeadTime = NotificationGlassMotionPreset.presentationSettleLeadTime
        presentationSettleCompressionDuration = NotificationGlassMotionPreset.presentationSettleCompressionDuration
        presentationSettleReturnDuration = NotificationGlassMotionPreset.presentationSettleReturnDuration
        presentationSettleRevealLeadTime = NotificationGlassMotionPreset.presentationSettleRevealLeadTime
        presentationSettleScaleX = NotificationGlassMotionPreset.presentationSettleScaleX
        presentationSettleScaleY = NotificationGlassMotionPreset.presentationSettleScaleY
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
    @State private var isReturningSourceBell = false
    @State private var bellRingOffsetXState: CGFloat = 0
    @State private var bellRingAngleState: CGFloat = 0
    @State private var isBellRinging = false
    @State private var bellRingTask: Task<Void, Never>?
    @State private var presentationSettleProgress: CGFloat = 0
    @State private var presentationSettleTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            GlassEffectContainer(spacing: style.glassContainerSpacing) {
                notificationSurface
                    .position(seedCenter)
                    .offset(y: surfaceVerticalOffset)
                    .opacity(notificationSurfaceOpacity)
                    .frame(width: style.containerSize.width, height: style.containerSize.height)
            }

            bellStaticLayer
            bellBubbleLayer
            bellGlyphLayer
            notificationFooterLayer
            notificationContentLayer
        }
        .frame(width: style.containerSize.width, height: style.containerSize.height)
        .contentShape(Rectangle())
        .highPriorityGesture(swipeUpToDismissGesture, including: .gesture)
        .onAppear {
            syncImmediately(with: isPresented)
        }
        .onDisappear {
            animationTask?.cancel()
            bounceDismissTask?.cancel()
            bellRingTask?.cancel()
            presentationSettleTask?.cancel()
            showsSourceBell = true
            isBellHandedOff = false
            isReturningSourceBell = false
            bellRingOffsetXState = 0
            bellRingAngleState = 0
            isBellRinging = false
            presentationSettleProgress = 0
        }
        .onChange(of: isPresented) { _, newValue in
            scheduleAnimation(for: newValue)
        }
    }

    private var notificationSurface: some View {
        let shape = RoundedRectangle(cornerRadius: notificationCornerRadius, style: .continuous)

        return shape
            .fill(.clear)
            .frame(width: notificationWidth, height: notificationHeight)
            .scaleEffect(x: notificationSurfaceScaleX, y: notificationSurfaceScaleY)
            .glassEffect(in: shape)
    }

    private var bellStaticLayer: some View {
        NotificationBellVisual(size: style.buttonSize)
            .position(style.buttonCenter)
            .opacity(sourceBellOpacity * (isBellRinging ? 0 : 1))
            .allowsHitTesting(false)
    }

    private var bellBubbleLayer: some View {
        NotificationBellBubbleVisual(size: style.buttonSize)
            .position(style.buttonCenter)
            .opacity(sourceBellOpacity * (isBellRinging ? 1 : 0))
            .allowsHitTesting(false)
    }

    private var bellGlyphLayer: some View {
        NotificationBellGlyphVisual(size: style.buttonSize)
            .position(style.buttonCenter)
            .opacity(sourceBellOpacity * (isBellRinging ? 1 : 0))
            .offset(x: bellRingOffsetX)
            .allowsHitTesting(false)
    }

    private var notificationContentLayer: some View {
        notificationContent()
            .frame(width: style.notificationFrame.width, height: style.notificationFrame.height)
            .opacity(contentOpacity)
            .scaleEffect(
                x: contentScale * presentationSettleScaleX,
                y: contentScale * presentationSettleScaleY,
                anchor: .center
            )
            .offset(x: contentHorizontalOffset)
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
                    style: .init(
                        size: style.footerFrame.size,
                        variant: style.footerVariant
                    )
                )
                .opacity(footerOpacity)
                .scaleEffect(
                    x: footerScale * presentationSettleScaleX,
                    y: footerScale * presentationSettleScaleY,
                    anchor: .center
                )
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
        let seedTravel = softenedSegment(progress, start: style.anticipationEndProgress * 0.5, end: 0.88)
        let anticipationLift = lerp(0, -style.anticipationLift, anticipationProgress) * (1 - seedTravel)
        return CGPoint(
            x: lerp(style.buttonCenter.x, style.notificationCenter.x, seedTravel),
            y: lerp(style.buttonCenter.y, style.notificationCenter.y, seedTravel) + anticipationLift
        )
    }

    private var notificationWidth: CGFloat {
        if progress < style.anticipationEndProgress {
            return lerp(style.buttonSize, style.buttonSize * style.anticipationScaleX, anticipationProgress)
        }
        if progress < style.finalExpansionStartProgress {
            return lerp(
                style.buttonSize * style.anticipationScaleX,
                style.midStageWidth,
                softenedSegment(progress, start: style.anticipationEndProgress, end: style.finalExpansionStartProgress)
            )
        }
        return lerp(
            style.midStageWidth,
            style.notificationFrame.width,
            softenedSegment(progress, start: style.finalExpansionStartProgress, end: style.finalExpansionEndProgress)
        )
    }

    private var notificationHeight: CGFloat {
        if progress < style.anticipationEndProgress {
            return lerp(style.buttonSize, style.buttonSize * style.anticipationScaleY, anticipationProgress)
        }
        if progress < style.finalExpansionStartProgress {
            return lerp(
                style.buttonSize * style.anticipationScaleY,
                style.midStageHeight,
                softenedSegment(progress, start: style.anticipationEndProgress, end: style.finalExpansionStartProgress)
            )
        }
        return lerp(
            style.midStageHeight,
            style.notificationFrame.height,
            softenedSegment(progress, start: style.finalExpansionStartProgress, end: style.finalExpansionEndProgress)
        )
    }

    private var notificationCornerRadius: CGFloat {
        let initialRadius = style.buttonSize / 2
        let compactRadius: CGFloat = 22
        if progress < style.anticipationEndProgress {
            return lerp(initialRadius, initialRadius * 0.9, anticipationProgress)
        }
        if progress < style.finalExpansionStartProgress {
            return lerp(
                initialRadius * 0.9,
                compactRadius,
                softenedSegment(progress, start: style.anticipationEndProgress, end: style.finalExpansionStartProgress)
            )
        }
        return lerp(
            compactRadius,
            style.finalCornerRadius,
            softenedSegment(progress, start: style.finalExpansionStartProgress, end: style.finalExpansionEndProgress)
        )
    }

    private var notificationOpacity: CGFloat {
        lerp(0.92, 1, progress)
    }

    private var notificationSurfaceOpacity: CGFloat {
        let baseOpacity = (isBellHandedOff || progress > 0.001) ? notificationOpacity : 0
        return baseOpacity * (1 - bellLandingHandoffProgress)
    }

    private var sourceBellOpacity: CGFloat {
        let persistedOpacity: CGFloat = showsSourceBell ? 1 : 0
        let handoffOpacity: CGFloat = isBellHandedOff ? 1 : 0
        let returningOpacity: CGFloat = isReturningSourceBell ? bellLandingHandoffProgress : 0
        return max(persistedOpacity, max(handoffOpacity, returningOpacity))
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

    private var contentHorizontalOffset: CGFloat {
        showsContent ? 0 : style.contentEntryHorizontalOffset
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

    private var sourceBellIsStatic: Bool {
        showsSourceBell && !isPresented
    }

    private var bellScaleX: CGFloat {
        guard !sourceBellIsStatic else { return 1 }
        let release = softenedSegment(progress, start: style.anticipationEndProgress, end: 0.42)
        if progress < style.anticipationEndProgress {
            return lerp(1, 1.06, anticipationProgress)
        }
        return lerp(1.06, 1, release)
    }

    private var bellScaleY: CGFloat {
        guard !sourceBellIsStatic else { return 1 }
        let release = softenedSegment(progress, start: style.anticipationEndProgress, end: 0.42)
        if progress < style.anticipationEndProgress {
            return lerp(1, 0.93, anticipationProgress)
        }
        return lerp(0.93, 1, release)
    }

    private var anticipationProgress: CGFloat {
        softenedSegment(progress, start: 0, end: style.anticipationEndProgress)
    }

    private var notificationSurfaceScaleX: CGFloat {
        lerp(1, 1.01, bellLandingHandoffProgress) * presentationSettleScaleX
    }

    private var notificationSurfaceScaleY: CGFloat {
        lerp(1, 0.99, bellLandingHandoffProgress) * presentationSettleScaleY
    }

    private var presentationSettleScaleX: CGFloat {
        lerp(1, style.presentationSettleScaleX, presentationSettleProgress)
    }

    private var presentationSettleScaleY: CGFloat {
        lerp(1, style.presentationSettleScaleY, presentationSettleProgress)
    }

    private var bellLandingHandoffProgress: CGFloat {
        guard !isPresented, !isBellHandedOff else { return 0 }
        return 1 - softenedSegment(progress, start: 0.02, end: 0.12)
    }

    private var bellRingAngle: CGFloat {
        isBellRinging ? bellRingAngleState : 0
    }

    private var bellRingOffsetX: CGFloat {
        isBellRinging ? bellRingOffsetXState : 0
    }

    private func scheduleAnimation(for presented: Bool) {
        animationTask?.cancel()
        bounceDismissTask?.cancel()
        bellRingTask?.cancel()
        presentationSettleTask?.cancel()

        animationTask = Task { @MainActor in
            isAnimating = false
            isReturningSourceBell = false
            bellRingOffsetXState = 0
            bellRingAngleState = 0
            isBellRinging = false
            presentationSettleProgress = 0

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
        bellRingTask?.cancel()
        presentationSettleTask?.cancel()
        interactiveDismissOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        isReturningSourceBell = false
        bellRingOffsetXState = 0
        bellRingAngleState = 0
        isBellRinging = false
        presentationSettleProgress = 0

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
        let feedback = UIImpactFeedbackGenerator(style: .soft)
        feedback.prepare()
        feedback.impactOccurred(intensity: 0.9)

        isAnimating = true
        interactiveDismissOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        isReturningSourceBell = false
        bellRingOffsetXState = 0
        bellRingAngleState = 0
        isBellRinging = false
        presentationSettleProgress = 0
        isBellHandedOff = true
        showsSourceBell = false
        showsContent = false

        withAnimation(morphAnimation) {
            progress = 1
        }

        // Ждём почти до момента reveal, но оставляем небольшой люфт,
        // чтобы bounce стартовал чуть раньше появления контента.
        let settleRevealLeadTime = min(style.presentationSettleRevealLeadTime, style.contentRevealDelay)
        let contentRevealWait = max(style.contentRevealDelay - settleRevealLeadTime, 0)

        try? await Task.sleep(nanoseconds: UInt64(contentRevealWait * 1_000_000_000))
        guard !Task.isCancelled, isPresented else { return }

        // Стартуем bounce чуть ДО reveal.
        schedulePresentationSettleBounce()

        if settleRevealLeadTime > 0 {
            try? await Task.sleep(nanoseconds: UInt64(settleRevealLeadTime * 1_000_000_000))
        }

        guard !Task.isCancelled, isPresented else { return }

        // А здесь уже раскрывается сам контент.
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
        isAnimating = true
        isBellHandedOff = false
        bellRingTask?.cancel()
        bellRingOffsetXState = 0
        bellRingAngleState = 0
        isBellRinging = false
        presentationSettleTask?.cancel()
        presentationSettleProgress = 0
        isReturningSourceBell = true

        withAnimation(contentHideAnimation) {
            showsContent = false
        }

        showsSourceBell = false
        onDismissMorphStart?()

        withAnimation(morphAnimation) {
            progress = 0
            interactiveDismissOffset = 0
            dismissSurfaceLift = 0
        }

        try? await Task.sleep(nanoseconds: UInt64(style.animationDuration * 1_000_000_000))
        guard !Task.isCancelled else { return }
        isReturningSourceBell = false
        showsSourceBell = true
        isBellHandedOff = false
        isBounceDismissing = false
        isAnimating = false
        scheduleBellRing(after: 0.02)
    }

    private func startBounceDismissal() {
        bounceDismissTask?.cancel()
        bounceDismissTask = Task { @MainActor in
            isBounceDismissing = true

            withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
                interactiveDismissOffset = 0
                dismissSurfaceLift = -style.bounceLift
            }

            isPresented = false
        }
    }

    private func scheduleBellRing(after delay: Double = 0) {
        bellRingTask?.cancel()
        bellRingTask = Task { @MainActor in
            let startDelay = max(delay, 0)

            if startDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(startDelay * 1_000_000_000))
            }

            guard !Task.isCancelled, !isPresented else { return }

            bellRingOffsetXState = 0
            isBellRinging = true

            // Bell ring только по X внутри статичной bubble.
            // Поворот убран полностью, чтобы исключить диагональное и "кивающее" движение.
            let travel = max(style.bellRingAmplitude * 0.7, 2.5)
            let keyframes: [(offsetX: CGFloat, duration: Double)] = [
                (-travel, 0.050),
                (travel * 0.84, 0.065),
                (-travel * 0.58, 0.060),
                (travel * 0.32, 0.055),
                (-travel * 0.14, 0.050),
                (0, max(style.bellRingDuration - 0.280, 0.08))
            ]

            for keyframe in keyframes {
                guard !Task.isCancelled, !isPresented else { return }

                withAnimation(.easeInOut(duration: keyframe.duration)) {
                    bellRingOffsetXState = keyframe.offsetX
                }

                try? await Task.sleep(nanoseconds: UInt64(keyframe.duration * 1_000_000_000))
            }
            guard !Task.isCancelled else { return }

            bellRingOffsetXState = 0
            bellRingAngleState = 0
            isBellRinging = false
        }
    }

    private func schedulePresentationSettleBounce() {
        presentationSettleTask?.cancel()
        presentationSettleTask = Task { @MainActor in
            let impactDelay = max(
                style.animationDuration -
                    style.contentRevealDelay -
                    style.presentationSettleLeadTime -
                    style.presentationSettleCompressionDuration -
                    style.presentationSettleReturnDuration,
                0
            )

            if impactDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(impactDelay * 1_000_000_000))
            }

            guard !Task.isCancelled, isPresented else { return }

            withAnimation(.easeOut(duration: style.presentationSettleCompressionDuration)) {
                presentationSettleProgress = 1
            }

            try? await Task.sleep(
                nanoseconds: UInt64(style.presentationSettleCompressionDuration * 1_000_000_000)
            )

            guard !Task.isCancelled, isPresented else { return }

            withAnimation(.easeOut(duration: style.presentationSettleReturnDuration)) {
                presentationSettleProgress = 0
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
