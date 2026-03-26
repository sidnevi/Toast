import SwiftUI

struct LiquidNotificationConfig {
    var buttonSize: CGFloat = 64
    var pillSize: CGSize = CGSize(width: 140, height: 46)
    var verticalOffset: CGFloat = 90
    var blurRadius: CGFloat = 16
    var alphaThreshold: CGFloat = 0.5
    var themeColor: Color = .indigo
    var containerSize: CGFloat = 220
    var contentRevealDelay: Double = 0.25
    var contentRevealDuration: Double = 0.25
    var morphSpring: Animation = .spring(response: 0.55, dampingFraction: 0.65, blendDuration: 0)
    var contentAnimation: Animation = .easeOut(duration: 0.25)
}

struct LiquidNotificationButton: View {
    @Binding var isExpanded: Bool

    let config: LiquidNotificationConfig
    let allowsInteractiveDismiss: Bool
    let notificationText: String

    @State private var isContentVisible = false
    @State private var revealTask: Task<Void, Never>?

    init(
        isExpanded: Binding<Bool>,
        config: LiquidNotificationConfig = .init(),
        allowsInteractiveDismiss: Bool = true,
        notificationText: String = "Новое событие"
    ) {
        _isExpanded = isExpanded
        self.config = config
        self.allowsInteractiveDismiss = allowsInteractiveDismiss
        self.notificationText = notificationText
    }

    var body: some View {
        ZStack {
            LiquidBackgroundView(
                progress: isExpanded ? 1 : 0,
                config: config
            )
            .frame(width: config.containerSize, height: config.containerSize)
            .allowsHitTesting(false)

            HStack(spacing: 8) {
                Circle()
                    .fill(.white)
                    .frame(width: 8, height: 8)

                Text(notificationText)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
            }
            .frame(width: config.pillSize.width, height: config.pillSize.height)
            .opacity(isContentVisible ? 1 : 0)
            .scaleEffect(isContentVisible ? 1 : 0.8)
            .position(
                x: config.containerSize / 2,
                y: config.containerSize - (config.buttonSize / 2) - (isExpanded ? config.verticalOffset : 0)
            )
            .onTapGesture {
                guard allowsInteractiveDismiss else { return }
                toggleState()
            }

            Button(action: toggleState) {
                Image(systemName: isExpanded ? "bell.badge.fill" : "bell.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: config.buttonSize, height: config.buttonSize)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .position(
                x: config.containerSize / 2,
                y: config.containerSize - (config.buttonSize / 2)
            )
        }
        .frame(width: config.containerSize, height: config.containerSize)
        .highPriorityGesture(swipeUpDismissGesture, including: .gesture)
        .onAppear {
            syncImmediately(with: isExpanded)
        }
        .onDisappear {
            revealTask?.cancel()
        }
        .onChange(of: isExpanded) { _, newValue in
            animateContentVisibility(for: newValue)
        }
    }

    private var swipeUpDismissGesture: some Gesture {
        DragGesture(minimumDistance: 12)
            .onEnded { value in
                guard allowsInteractiveDismiss else { return }
                guard isExpanded else { return }

                let shouldDismiss =
                    value.translation.height < -50 ||
                    value.predictedEndTranslation.height < -120

                if shouldDismiss {
                    toggleState(forceExpanded: false)
                }
            }
    }

    private func toggleState() {
        guard allowsInteractiveDismiss else { return }
        toggleState(forceExpanded: !isExpanded)
    }

    private func toggleState(forceExpanded expanded: Bool) {
        revealTask?.cancel()

        if expanded {
            withAnimation(config.morphSpring) {
                isExpanded = true
            }

            revealTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(config.contentRevealDelay * 1_000_000_000))
                guard !Task.isCancelled, isExpanded else { return }
                withAnimation(config.contentAnimation) {
                    isContentVisible = true
                }
            }
        } else {
            withAnimation(config.contentAnimation) {
                isContentVisible = false
            }

            withAnimation(config.morphSpring) {
                isExpanded = false
            }
        }
    }

    private func syncImmediately(with expanded: Bool) {
        revealTask?.cancel()
        isContentVisible = expanded
    }

    private func animateContentVisibility(for expanded: Bool) {
        revealTask?.cancel()

        if expanded {
            revealTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(config.contentRevealDelay * 1_000_000_000))
                guard !Task.isCancelled, isExpanded else { return }
                withAnimation(config.contentAnimation) {
                    isContentVisible = true
                }
            }
        } else {
            withAnimation(config.contentAnimation) {
                isContentVisible = false
            }
        }
    }
}

private struct LiquidBackgroundView: View, Animatable {
    var progress: CGFloat
    let config: LiquidNotificationConfig

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: config.alphaThreshold, color: config.themeColor))
            context.addFilter(.blur(radius: config.blurRadius))

            context.drawLayer { layer in
                let baseX = size.width / 2
                let baseY = size.height - config.buttonSize / 2

                let currentWidth = config.buttonSize + (config.pillSize.width - config.buttonSize) * progress
                let currentHeight = config.buttonSize + (config.pillSize.height - config.buttonSize) * progress
                let currentY = baseY - (config.verticalOffset * progress)
                let currentCornerRadius = (config.buttonSize / 2) +
                    ((config.pillSize.height / 2) - (config.buttonSize / 2)) * progress

                var basePath = Path()
                basePath.addEllipse(
                    in: CGRect(
                        x: baseX - config.buttonSize / 2,
                        y: baseY - config.buttonSize / 2,
                        width: config.buttonSize,
                        height: config.buttonSize
                    )
                )

                var pillPath = Path()
                pillPath.addRoundedRect(
                    in: CGRect(
                        x: baseX - currentWidth / 2,
                        y: currentY - currentHeight / 2,
                        width: currentWidth,
                        height: currentHeight
                    ),
                    cornerSize: CGSize(width: currentCornerRadius, height: currentCornerRadius)
                )

                layer.fill(basePath, with: .color(.black))
                layer.fill(pillPath, with: .color(.black))
            }
        }
    }
}

struct LiquidNotificationButton_Previews: PreviewProvider {
    struct PreviewHost: View {
        @State private var isExpanded = false

        var body: some View {
            ZStack {
                Color(white: 0.08)
                    .ignoresSafeArea()

                LiquidNotificationButton(
                    isExpanded: $isExpanded,
                    config: LiquidNotificationConfig(themeColor: .indigo),
                    notificationText: "Новое сообщение"
                )
            }
        }
    }

    static var previews: some View {
        PreviewHost()
    }
}
