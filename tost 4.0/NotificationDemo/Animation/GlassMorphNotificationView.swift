import SwiftUI
import UIKit

enum NotificationGlassMotionPreset {
    static let timingScale: Double = 1.2

    static let animationDuration: Double = 0.46 * timingScale
    static let contentRevealDelay: Double = 0.16 * timingScale
    static let contentRevealDuration: Double = 0.13 * timingScale
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

    static let morphResponse: Double = 0.31 * timingScale
    static let morphDampingFraction: Double = 0.82

    static let bellRingLeadTime: Double = 0.24 * timingScale
    static let bellRingDuration: Double = 0.58 * timingScale
    static let bellRingAmplitude: CGFloat = 14
    static let bellRingCycles: CGFloat = 2.35
    static let bellRingPivotY: CGFloat = 0.12
    static let bellRingWaveInset: CGFloat = 5
    static let bellRingWaveTravel: CGFloat = 7

    static let presentationSettleLeadTime: Double = 0.18 * timingScale
    static let presentationSettleCompressionDuration: Double = 0.06 * timingScale
    static let presentationSettleReturnDuration: Double = 0.09 * timingScale
    static let presentationSettleRevealLeadTime: Double = 0.12 * timingScale
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
    var anchorsSurfaceStartToBell = false
    var surfaceStartAnchor: CGPoint?
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
    var swipeDismissIslandTopContactDistance: CGFloat = 112
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

    var notificationContainerCenter: CGPoint {
        CGPoint(x: notificationFrame.midX, y: notificationFrame.minY + containerSize.height / 2)
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
    @Binding var isSourceBellFilled: Bool
    @Binding var isSourceBellCritical: Bool

    let allowsInteractiveDismiss: Bool
    let style: GlassMorphNotificationStyle
    let onDismissMorphStart: (() -> Void)?
    let onInteractionChanged: (Bool) -> Void
    @ViewBuilder let notificationContent: () -> NotificationContent

    @State private var progress: CGFloat = 0
    @State private var isAnimating = false
    @State private var showsContent = false
    @State private var animationTask: Task<Void, Never>?
    @State private var bounceDismissTask: Task<Void, Never>?
    @State private var interactiveDismissOffset: CGFloat = 0
    @State private var isBlockedSwipeShaking = false
    @State private var blockedSwipeShakeOffset: CGFloat = 0
    @State private var dismissSurfaceLift: CGFloat = 0
    @State private var isBounceDismissing = false
    @State private var isBellHandedOff = false
    @State private var isReturningSourceBell = false
    @State private var isBellRinging = false
    @State private var bellRingTask: Task<Void, Never>?
    @State private var bellRingStartDate: Date?
    @State private var bellRingDurationState: Double = 0
    @State private var presentationSettleProgress: CGFloat = 0
    @State private var presentationSettleTask: Task<Void, Never>?
    @State private var interactiveBubbleAnchorX: CGFloat = 0.86
    @State private var interactiveBubblePressProgress: CGFloat = 0
    @State private var isUserInteracting = false
    @State private var dismissAnimationDurationScale: Double = 1

    var body: some View {
        ZStack {
            notificationSurfaceLayer

            bellStaticLayer
            bellBubbleLayer
            bellGlyphLayer
            notificationContentLayer
        }
        .frame(width: style.containerSize.width, height: style.containerSize.height)
        .contentShape(Rectangle())
        .highPriorityGesture(swipeUpToDismissGesture, including: .gesture)
        .simultaneousGesture(interactiveBubblePressGesture, including: .gesture)
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
            isBellRinging = false
            bellRingStartDate = nil
            bellRingDurationState = 0
            presentationSettleProgress = 0
            isBlockedSwipeShaking = false
            blockedSwipeShakeOffset = 0
            interactiveBubbleAnchorX = 0.86
            interactiveBubblePressProgress = 0
            setUserInteractionActive(false)
        }
        .onChange(of: isPresented) { _, newValue in
            scheduleAnimation(for: newValue)
        }
    }

    @ViewBuilder
    private var notificationSurfaceLayer: some View {
        if style.anchorsSurfaceStartToBell {
            notificationSurface
                .offset(x: initialSurfaceOrigin.x + blockedSwipeShakeOffset)
                .offset(y: initialSurfaceOrigin.y + notificationSurfaceVerticalOffset)
                .opacity(notificationSurfaceOpacity)
                .frame(
                    width: style.containerSize.width,
                    height: style.containerSize.height,
                    alignment: .topLeading
                )
        } else {
            notificationSurface
                .position(surfaceCenter)
                .offset(x: blockedSwipeShakeOffset)
                .offset(y: notificationSurfaceVerticalOffset)
                .opacity(notificationSurfaceOpacity)
                .frame(width: style.containerSize.width, height: style.containerSize.height)
        }
    }

    private var notificationSurface: some View {
        let shape = NotificationUnifiedSurfaceShape(
            cornerRadius: notificationCornerRadius,
            footerHeight: footerHeight,
            variant: style.footerVariant
        )

        return notificationSurfaceFill(in: shape)
            .overlay {
                shape
                    .stroke(Color.white.opacity(0.1), lineWidth: 1.068)
            }
            .frame(width: surfaceWidth, height: notificationSurfaceHeight)
            .scaleEffect(
                x: notificationSurfaceScaleX,
                y: notificationSurfaceScaleY,
                anchor: notificationSurfaceScaleAnchor
            )
    }

    @ViewBuilder
    private func notificationSurfaceFill(in shape: NotificationUnifiedSurfaceShape) -> some View {
        switch style.footerVariant {
        case .event:
            ZStack {
                shape
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 39 / 255, green: 33 / 255, blue: 35 / 255),
                                Color(red: 51 / 255, green: 30 / 255, blue: 33 / 255),
                                Color(red: 61 / 255, green: 32 / 255, blue: 35 / 255)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                shape
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 94 / 255, green: 20 / 255, blue: 25 / 255).opacity(0.14),
                                Color(red: 94 / 255, green: 20 / 255, blue: 25 / 255).opacity(0.06),
                                Color(red: 94 / 255, green: 20 / 255, blue: 25 / 255).opacity(0.0)
                            ],
                            center: UnitPoint(x: 251 / 351, y: 38 / 94),
                            startRadius: 0,
                            endRadius: 190
                        )
                    )
            }
        case .inApp, .push:
            shape
                .fill(Color.white.opacity(0.1))
        }
    }

    private var bellStaticLayer: some View {
        NotificationBellVisual(
            size: style.buttonSize,
            isFilled: isSourceBellFilled,
            isCritical: isSourceBellCritical
        )
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
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: !isBellRinging)) { timeline in
            ringingBellGlyph
                .rotationEffect(
                    .degrees(Double(bellRingAngle(at: timeline.date))),
                    anchor: UnitPoint(x: 0.5, y: style.bellRingPivotY)
                )
                .position(
                    x: style.buttonCenter.x + bellRingOffsetX(at: timeline.date),
                    y: style.buttonCenter.y
                )
                .opacity(sourceBellOpacity * (isBellRinging ? 1 : 0))
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private var ringingBellGlyph: some View {
        if isSourceBellFilled {
            if isSourceBellCritical {
                NotificationBellCriticalGlyphVisual(size: style.buttonSize)
            } else {
                NotificationBellFilledGlyphVisual(size: style.buttonSize)
            }
        } else {
            NotificationBellGlyphVisual(size: style.buttonSize)
        }
    }

    private var notificationContentLayer: some View {
        notificationContent()
            .frame(width: style.notificationFrame.width, height: style.notificationFrame.height)
            .opacity(contentOpacity)
            .scaleEffect(
                x: contentScale * presentationSettleScaleX * interactiveContentBubbleScale,
                y: contentScale * presentationSettleScaleY * interactiveContentBubbleScale,
                anchor: contentScaleAnchor
            )
            .offset(x: contentHorizontalOffset)
            .offset(y: contentVerticalOffset)
            .blur(radius: contentBlurRadius, opaque: false)
            .position(seedCenter)
            .offset(x: blockedSwipeShakeOffset)
            .offset(y: contentLayerVerticalOffset)
            .mask {
                RoundedRectangle(cornerRadius: notificationCornerRadius, style: .continuous)
                    .frame(width: notificationWidth, height: notificationContentMaskHeight)
                    .position(contentMaskCenter)
            }
            .allowsHitTesting(showsContent && isPresented)
    }

    private var swipeUpToDismissGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else {
                    stopBlockedSwipeShake()
                    return
                }

                setUserInteractionActive(true)
                updateInteractiveBubbleAnchor(from: value)
                startInteractiveBubblePress()

                guard allowsInteractiveDismiss else {
                    interactiveDismissOffset = 0
                    guard value.translation.height < 0 else {
                        stopBlockedSwipeShake()
                        return
                    }
                    startBlockedSwipeShake()
                    return
                }

                stopBlockedSwipeShake()
                interactiveDismissOffset = max(
                    -style.swipeDismissIslandTopContactDistance,
                    min(0, value.translation.height)
                )
            }
            .onEnded { value in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else {
                    stopBlockedSwipeShake()
                    return
                }
                let isVerticalSwipe = abs(value.translation.height) > abs(value.translation.width) * 1.15
                let upwardTranslation = max(-value.translation.height, 0)
                let upwardPrediction = max(-value.predictedEndTranslation.height, 0)
                let passedSwipeDistance = upwardTranslation >= style.swipeDismissThreshold
                let passedSwipeVelocity = upwardPrediction >= style.swipeDismissPredictedThreshold
                let canDismissInteractively = style.footerVariant != .event
                let shouldDismiss = canDismissInteractively &&
                    isVerticalSwipe &&
                    (passedSwipeDistance || passedSwipeVelocity)

                if allowsInteractiveDismiss && shouldDismiss {
                    stopBlockedSwipeShake()
                    setUserInteractionActive(false)
                    startBounceDismissal(durationScale: dismissDurationScale(for: value))
                } else {
                    withAnimation(.interpolatingSpring(stiffness: 220, damping: 15, initialVelocity: 5)) {
                        interactiveDismissOffset = 0
                    }
                    stopBlockedSwipeShake()
                    releaseInteractiveBubblePress()
                    setUserInteractionActive(false)
                }
            }
    }

    private var interactiveBubblePressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else { return }
                setUserInteractionActive(true)
                updateInteractiveBubbleAnchor(from: value)
                startInteractiveBubblePress()
            }
            .onEnded { _ in
                guard progress > 0.98, !isAnimating, !isBounceDismissing else {
                    interactiveBubblePressProgress = 0
                    setUserInteractionActive(false)
                    return
                }

                releaseInteractiveBubblePress()
                setUserInteractionActive(false)
            }
    }

    private var contentLayerVerticalOffset: CGFloat {
        guard allowsInteractiveDismiss else { return dismissSurfaceLift }
        return visualInteractiveDismissOffset + dismissSurfaceLift
    }

    private var notificationSurfaceVerticalOffset: CGFloat {
        dismissSurfaceLift - interactiveStretchAmount / 2
    }

    private var interactiveStretchAmount: CGFloat {
        guard allowsInteractiveDismiss, !isBounceDismissing else { return 0 }

        switch style.footerVariant {
        case .inApp, .push, .event:
            let rawStretch = max(-interactiveDismissOffset, 0)
            let maxStretch: CGFloat = 12
            return maxStretch * (1 - exp(-rawStretch / (maxStretch * 2.4)))
        }
    }

    private var visualInteractiveDismissOffset: CGFloat {
        guard allowsInteractiveDismiss, !isBounceDismissing else { return 0 }

        switch style.footerVariant {
        case .inApp, .push, .event:
            return -interactiveStretchAmount
        }
    }

    private func setUserInteractionActive(_ isActive: Bool) {
        guard isUserInteracting != isActive else { return }
        isUserInteracting = isActive
        onInteractionChanged(isActive)
    }

    private func startBlockedSwipeShake() {
        guard !isBlockedSwipeShaking else { return }

        isBlockedSwipeShaking = true
        blockedSwipeShakeOffset = -8

        withAnimation(.easeInOut(duration: 0.07).repeatForever(autoreverses: true)) {
            blockedSwipeShakeOffset = 8
        }
    }

    private func stopBlockedSwipeShake() {
        guard isBlockedSwipeShaking || blockedSwipeShakeOffset != 0 else { return }

        isBlockedSwipeShaking = false
        withAnimation(.spring(response: 0.24, dampingFraction: 0.72)) {
            blockedSwipeShakeOffset = 0
        }
    }

    private func updateInteractiveBubbleAnchor(from value: DragGesture.Value) {
        let width = max(style.containerSize.width, 1)
        let normalizedX = value.location.x / width
        interactiveBubbleAnchorX = min(max(normalizedX, 0.08), 0.94)
    }

    private func startInteractiveBubblePress() {
        guard interactiveBubblePressProgress < 0.98 else { return }

        withAnimation(.interactiveSpring(response: 0.18, dampingFraction: 0.48, blendDuration: 0)) {
            interactiveBubblePressProgress = 1
        }
    }

    private func releaseInteractiveBubblePress() {
        withAnimation(.interpolatingSpring(stiffness: 230, damping: 14, initialVelocity: 8)) {
            interactiveBubblePressProgress = 0
        }
    }

    private var seedCenter: CGPoint {
        let seedTravel = softenedSegment(progress, start: style.anticipationEndProgress * 0.5, end: 0.88)
        let anticipationLift = lerp(0, -style.anticipationLift, anticipationProgress) * (1 - seedTravel)
        return CGPoint(
            x: lerp(style.buttonCenter.x, style.notificationCenter.x, seedTravel),
            y: lerp(style.buttonCenter.y, style.notificationCenter.y, seedTravel) + anticipationLift
        )
    }

    private var surfaceCenter: CGPoint {
        let finalCenter = CGPoint(
            x: style.notificationContainerCenter.x,
            y: style.notificationContainerCenter.y
        )
        let seedTravel = softenedSegment(
            progress,
            start: style.anticipationEndProgress * 0.5,
            end: style.anchorsSurfaceStartToBell ? style.finalExpansionEndProgress : 0.88
        )
        let anticipationLift = lerp(0, -style.anticipationLift, anticipationProgress) * (1 - seedTravel)

        if style.anchorsSurfaceStartToBell {
            let surfaceAnchor = style.surfaceStartAnchor ?? style.buttonCenter
            let edgeTravel = softenedSegment(
                progress,
                start: style.finalExpansionStartProgress,
                end: style.finalExpansionEndProgress
            )
            let rightEdge = lerp(
                surfaceAnchor.x + style.buttonSize / 2,
                style.notificationFrame.maxX,
                edgeTravel
            )

            return CGPoint(
                x: rightEdge - surfaceWidth / 2,
                y: lerp(surfaceAnchor.y, finalCenter.y, seedTravel) + anticipationLift
            )
        }

        return CGPoint(
            x: lerp(style.buttonCenter.x, finalCenter.x, seedTravel),
            y: lerp(style.buttonCenter.y, finalCenter.y, seedTravel) + anticipationLift
        )
    }

    private var initialSurfaceOrigin: CGPoint {
        CGPoint(
            x: surfaceCenter.x - surfaceWidth / 2,
            y: surfaceCenter.y - notificationSurfaceHeight / 2
        )
    }

    private var surfaceWidth: CGFloat {
        return notificationWidth
    }

    private var notificationSurfaceScaleAnchor: UnitPoint {
        if interactiveBubbleVisualProgress != 0 {
            return .center
        }

        return style.anchorsSurfaceStartToBell ? .trailing : .center
    }

    private var contentScaleAnchor: UnitPoint {
        .center
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

    private var footerHeight: CGFloat {
        lerp(
            0,
            style.footerFrame.height,
            softenedSegment(progress, start: style.finalExpansionStartProgress, end: style.finalExpansionEndProgress)
        )
    }

    private var notificationTotalHeight: CGFloat {
        notificationHeight + footerHeight
    }

    private var notificationSurfaceHeight: CGFloat {
        notificationTotalHeight + interactiveStretchAmount
    }

    private var notificationContentMaskHeight: CGFloat {
        notificationHeight + interactiveStretchAmount
    }

    private var contentMaskCenter: CGPoint {
        CGPoint(
            x: seedCenter.x,
            y: seedCenter.y - interactiveStretchAmount / 2
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
        let returningOpacity: CGFloat = isReturningSourceBell ? 1 : 0
        return max(persistedOpacity, max(handoffOpacity, returningOpacity))
    }

    private var contentOpacity: CGFloat {
        if isReturningSourceBell {
            return min(max(progress, 0), 1)
        }

        return showsContent ? 1 : 0
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
        if isReturningSourceBell {
            return style.contentEntryBlurRadius * (1 - min(max(progress, 0), 1))
        }

        return showsContent ? 0 : style.contentEntryBlurRadius
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
        lerp(1, 1.01, bellLandingHandoffProgress) *
            presentationSettleScaleX *
            interactiveBubbleScaleX
    }

    private var notificationSurfaceScaleY: CGFloat {
        lerp(1, 0.99, bellLandingHandoffProgress) *
            presentationSettleScaleY *
            interactiveBubbleScaleY
    }

    private var interactiveBubbleProgress: CGFloat {
        guard progress > 0.98, !isAnimating else { return 0 }

        let pressProgress = interactiveBubblePressProgress

        if allowsInteractiveDismiss {
            let dragProgress = min(
                max(-interactiveDismissOffset / max(style.swipeDismissIslandTopContactDistance, 1), 0),
                1
            )
            return max(pressProgress, dragProgress)
        }

        return max(pressProgress, isBlockedSwipeShaking ? 0.88 : 0)
    }

    private var interactiveBubbleVisualProgress: CGFloat {
        min(max(interactiveBubbleProgress, -0.32), 1.18)
    }

    private var interactiveBubbleScaleX: CGFloat {
        let progress = interactiveBubbleVisualProgress
        let cappedStretchProgress = min(progress, 1)
        let maxHorizontalCompression = 4 / max(surfaceWidth, 1)
        return 1 - maxHorizontalCompression * cappedStretchProgress
    }

    private var interactiveBubbleScaleY: CGFloat {
        let progress = interactiveBubbleVisualProgress
        return 1 - 0.06 * progress
    }

    private var interactiveContentBubbleScale: CGFloat {
        let progress = interactiveBubbleVisualProgress
        return 1 - 0.024 * progress
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

    private func bellRingProgress(at date: Date) -> CGFloat {
        guard
            isBellRinging,
            let bellRingStartDate,
            bellRingDurationState > 0
        else {
            return 0
        }

        let elapsed = date.timeIntervalSince(bellRingStartDate)
        let rawProgress = elapsed / bellRingDurationState
        return min(max(CGFloat(rawProgress), 0), 1)
    }

    private func bellRingAngle(at date: Date) -> CGFloat {
        let progress = bellRingProgress(at: date)
        guard progress < 1 else { return 0 }

        let envelope = pow(1 - progress, 1.35)
        let phase = progress * style.bellRingCycles * .pi * 2
        return sin(phase) * style.bellRingAmplitude * envelope
    }

    private func bellRingOffsetX(at date: Date) -> CGFloat {
        let progress = bellRingProgress(at: date)
        guard progress < 1 else { return 0 }

        let envelope = pow(1 - progress, 1.5)
        let phase = progress * style.bellRingCycles * .pi * 2
        return sin(phase - (.pi / 2)) * style.bellRingWaveTravel * 0.18 * envelope
    }

    private func scheduleAnimation(for presented: Bool) {
        animationTask?.cancel()
        bounceDismissTask?.cancel()
        bellRingTask?.cancel()
        presentationSettleTask?.cancel()

        animationTask = Task { @MainActor in
            isAnimating = false
            isReturningSourceBell = false
            isBellRinging = false
            bellRingStartDate = nil
            bellRingDurationState = 0
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

    private func morphAnimation(durationScale: Double) -> Animation {
        .spring(
            response: style.morphResponse * durationScale,
            dampingFraction: style.morphDampingFraction,
            blendDuration: 0
        )
    }

    private func contentHideAnimation(durationScale: Double) -> Animation {
        .easeInOut(duration: max(style.contentRevealDuration * 0.82 * durationScale, 0.08))
    }

    @MainActor
    private func syncImmediately(with presented: Bool) {
        animationTask?.cancel()
        bounceDismissTask?.cancel()
        bellRingTask?.cancel()
        presentationSettleTask?.cancel()
        interactiveDismissOffset = 0
        isBlockedSwipeShaking = false
        blockedSwipeShakeOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        isReturningSourceBell = false
        isBellRinging = false
        bellRingStartDate = nil
        bellRingDurationState = 0
        presentationSettleProgress = 0
        interactiveBubbleAnchorX = 0.86
        interactiveBubblePressProgress = 0
        dismissAnimationDurationScale = 1
        setUserInteractionActive(false)

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
        isBlockedSwipeShaking = false
        blockedSwipeShakeOffset = 0
        dismissSurfaceLift = 0
        isBounceDismissing = false
        isReturningSourceBell = false
        isBellRinging = false
        bellRingStartDate = nil
        bellRingDurationState = 0
        presentationSettleProgress = 0
        interactiveBubbleAnchorX = 0.86
        interactiveBubblePressProgress = 0
        dismissAnimationDurationScale = 1
        setUserInteractionActive(false)
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
        let durationScale = dismissAnimationDurationScale
        let dismissalDuration = style.animationDuration * durationScale
        let contentHideDelay = min(dismissalDuration * 0.18, 0.08)

        isAnimating = true
        isBellHandedOff = false
        bellRingTask?.cancel()
        isBellRinging = false
        bellRingStartDate = nil
        bellRingDurationState = 0
        presentationSettleTask?.cancel()
        presentationSettleProgress = 0
        isReturningSourceBell = true
        setUserInteractionActive(false)

        Task { @MainActor in
            if contentHideDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(contentHideDelay * 1_000_000_000))
            }

            guard !Task.isCancelled, isReturningSourceBell else { return }
            withAnimation(contentHideAnimation(durationScale: durationScale)) {
                showsContent = false
            }
        }

        showsSourceBell = false
        onDismissMorphStart?()

        withAnimation(morphAnimation(durationScale: durationScale)) {
            progress = 0
            interactiveDismissOffset = 0
            isBlockedSwipeShaking = false
            blockedSwipeShakeOffset = 0
            dismissSurfaceLift = 0
            interactiveBubblePressProgress = 0
        }

        scheduleBellRing(after: max(dismissalDuration - style.bellRingLeadTime * durationScale, 0))

        try? await Task.sleep(nanoseconds: UInt64(dismissalDuration * 1_000_000_000))
        guard !Task.isCancelled else { return }
        isReturningSourceBell = false
        showsSourceBell = true
        isBellHandedOff = false
        isBounceDismissing = false
        dismissAnimationDurationScale = 1
        isAnimating = false
    }

    private func startBounceDismissal(durationScale: Double = 1) {
        bounceDismissTask?.cancel()
        bounceDismissTask = Task { @MainActor in
            isBounceDismissing = true
            dismissAnimationDurationScale = durationScale

            withAnimation(.spring(response: 0.34 * durationScale, dampingFraction: 0.88)) {
                interactiveDismissOffset = 0
                dismissSurfaceLift = -style.bounceLift
            }

            isPresented = false
        }
    }

    private func dismissDurationScale(for value: DragGesture.Value) -> Double {
        let upwardTranslation = max(-value.translation.height, 0)
        let upwardPrediction = max(-value.predictedEndTranslation.height, 0)
        let predictedImpulse = max(upwardPrediction - upwardTranslation, 0)
        let impulseProgress = min(max(Double(predictedImpulse / 260), 0), 1)
        let distanceProgress = min(max(Double(upwardTranslation / 180), 0), 1)
        let speedProgress = max(impulseProgress, distanceProgress * 0.45)
        return 1 - (0.48 * speedProgress)
    }

    private func scheduleBellRing(after delay: Double = 0) {
        bellRingTask?.cancel()
        bellRingTask = Task { @MainActor in
            let startDelay = max(delay, 0)

            if startDelay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(startDelay * 1_000_000_000))
            }

            guard !Task.isCancelled, !isPresented else { return }

            isBellRinging = true
            bellRingStartDate = Date()
            bellRingDurationState = style.bellRingDuration

            try? await Task.sleep(nanoseconds: UInt64(style.bellRingDuration * 1_000_000_000))
            guard !Task.isCancelled, !isPresented else { return }

            isBellRinging = false
            bellRingStartDate = nil
            bellRingDurationState = 0
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
