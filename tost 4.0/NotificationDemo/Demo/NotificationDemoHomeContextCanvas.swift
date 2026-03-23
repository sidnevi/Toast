import SwiftUI

struct NotificationDemoHomeContextCanvas: View {
    let scenario: NotificationScenario
    @ObservedObject var controller: NotificationAnimationController

    private var presentationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: scenario)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            NotificationDemoHomeContextBackground()
                .frame(
                    width: NotificationDemoHomeContextLayout.canvasWidth,
                    height: NotificationDemoHomeContextLayout.canvasHeight
                )

            if controller.showsSourceBell {
                NotificationBellVisual(size: NotificationDemoHomeContextLayout.bellSize)
                    .frame(
                        width: NotificationDemoHomeContextLayout.bellSize,
                        height: NotificationDemoHomeContextLayout.bellSize
                    )
                    .position(NotificationDemoHomeContextLayout.bellCenter)
            }

            NotificationPresenter(
                isPresented: $controller.isPresented,
                showsSourceBell: $controller.showsSourceBell,
                glassStyle: glassStyle,
                liquidConfig: liquidConfig,
                liquidNotificationText: scenario.title,
                liquidOffset: liquidOffset,
                onDismissMorphStart: nil
            ) {
                NotificationContentFactory.makeView(for: scenario)
                    .frame(
                        width: presentationMetrics.contentWidth,
                        height: presentationMetrics.contentHeight
                    )
            }
        }
        .frame(
            width: NotificationDemoHomeContextLayout.canvasWidth,
            height: NotificationDemoHomeContextLayout.canvasHeight
        )
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }

    private var glassStyle: GlassMorphNotificationStyle {
        var style = GlassMorphNotificationStyle()
        style.containerSize = CGSize(
            width: NotificationDemoHomeContextLayout.canvasWidth,
            height: presentationMetrics.containerHeight
        )
        style.notificationFrame = CGRect(
            x: 12,
            y: 0,
            width: presentationMetrics.contentWidth,
            height: presentationMetrics.contentHeight
        )
        style.footerVariant = presentationMetrics.footerVariant
        style.buttonSize = NotificationDemoHomeContextLayout.bellSize
        style.buttonCenter = NotificationDemoHomeContextLayout.bellCenter
        style.glassContainerSpacing = 50
        style.splitStartProgress = 0.95
        style.preTearStartProgress = 0.968
        style.tearProgress = 0.992
        style.animationDuration = 0.92
        style.contentRevealDelay = 0.31
        style.contentRevealDuration = 0.26
        style.contentEntryOffset = 10
        style.contentEntryBlurRadius = 8
        style.contentEntryScale = 0.992
        style.footerEntryOffset = 6
        style.morphResponse = 0.62
        style.morphDampingFraction = 0.82
        style.finalCornerRadius = 32
        return style
    }

    private var liquidConfig: LiquidNotificationConfig {
        LiquidNotificationConfig(
            buttonSize: 64,
            pillSize: CGSize(width: 146, height: 46),
            verticalOffset: 88,
            blurRadius: 16,
            alphaThreshold: 0.5,
            themeColor: Color(red: 0.24, green: 0.26, blue: 0.34)
        )
    }

    private var liquidOffset: CGSize {
        CGSize(
            width: NotificationDemoHomeContextLayout.bellCenter.x - (liquidConfig.containerSize / 2),
            height: NotificationDemoHomeContextLayout.bellCenter.y -
                (liquidConfig.containerSize - (liquidConfig.buttonSize / 2))
        )
    }
}

private enum NotificationDemoHomeContextLayout {
    static let canvasWidth: CGFloat = 375
    static let canvasHeight: CGFloat = 812

    static let bellSize: CGFloat = 40
    static let bellCenter = CGPoint(x: 331, y: 36)

    static let topInset: CGFloat = 24
    static let horizontalInset: CGFloat = 16
    static let placeholderHeight: CGFloat = 72
    static let totalHeight: CGFloat = 141
    static let actionsHeight: CGFloat = 108
    static let operationsHeight: CGFloat = 176
    static let accountsHeight: CGFloat = 372
    static let accountingHeight: CGFloat = AccountingSectionView.Layout.totalHeight
    static let totalSpacing: CGFloat = 16
    static let actionsSpacing: CGFloat = 4
    static let operationsSpacing: CGFloat = 32
    static let accountsSpacing: CGFloat = 16
    static let accountingSpacing: CGFloat = 16

    static let placeholderWidth: CGFloat = 343
    static let totalWidth: CGFloat = 323
    static let cardWidth: CGFloat = 343
    static let actionsItemWidth: CGFloat = 72
    static let actionsItemHeight: CGFloat = 56
}

private struct NotificationDemoHomeContextBackground: View {
    var body: some View {
        ZStack(alignment: .top) {
            NotificationDemoCanvasBackground()

            VStack(spacing: 0) {
                homeHeader

                Spacer()
                    .frame(height: NotificationDemoHomeContextLayout.totalSpacing)

                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .frame(
                        width: NotificationDemoHomeContextLayout.totalWidth,
                        height: NotificationDemoHomeContextLayout.totalHeight
                    )

                Spacer()
                    .frame(height: NotificationDemoHomeContextLayout.actionsSpacing)

                actionsRow

                Spacer()
                    .frame(height: NotificationDemoHomeContextLayout.operationsSpacing)

                largeSectionPlaceholder(height: NotificationDemoHomeContextLayout.operationsHeight)

                Spacer()
                    .frame(height: NotificationDemoHomeContextLayout.accountsSpacing)

                largeSectionPlaceholder(height: NotificationDemoHomeContextLayout.accountsHeight)

                Spacer()
                    .frame(height: NotificationDemoHomeContextLayout.accountingSpacing)

                accountingPlaceholder

                Spacer(minLength: 0)
            }
            .padding(.top, NotificationDemoHomeContextLayout.topInset)
        }
    }

    private var homeHeader: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.white.opacity(0.08))
            .frame(
                width: NotificationDemoHomeContextLayout.placeholderWidth,
                height: NotificationDemoHomeContextLayout.placeholderHeight
            )
            .overlay(alignment: .leading) {
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.white.opacity(0.26))
                        .frame(width: 138, height: 12)

                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.white.opacity(0.14))
                        .frame(width: 72, height: 10)
                }
                .padding(.leading, 16)
            }
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(Color.black)
                    .frame(width: 48, height: 48)
                    .padding(.top, 12)
                    .padding(.trailing, 12)
            }
    }

    private var actionsRow: some View {
        HStack(alignment: .top, spacing: 0) {
            actionItem
            Spacer(minLength: 0)
            actionItem
            Spacer(minLength: 0)
            actionItem
            Spacer(minLength: 0)
            actionItem
        }
        .padding(.horizontal, NotificationDemoHomeContextLayout.horizontalInset)
        .frame(
            width: NotificationDemoHomeContextLayout.canvasWidth,
            height: NotificationDemoHomeContextLayout.actionsHeight,
            alignment: .top
        )
    }

    private var actionItem: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.1))
                .frame(
                    width: NotificationDemoHomeContextLayout.actionsItemWidth,
                    height: NotificationDemoHomeContextLayout.actionsItemHeight
                )

            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 52, height: 8)

                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 44, height: 8)
            }
        }
        .frame(width: NotificationDemoHomeContextLayout.actionsItemWidth, alignment: .top)
    }

    private func largeSectionPlaceholder(height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color.white.opacity(0.08))
            .frame(width: NotificationDemoHomeContextLayout.cardWidth, height: height)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 104, height: 11)

                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.white.opacity(0.11))
                        .frame(width: 156, height: 9)
                }
                .padding(.top, 24)
                .padding(.leading, 20)
            }
    }

    private var accountingPlaceholder: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.white.opacity(0.26))
                .frame(width: 136, height: 14)
                .padding(.top, 32)
                .padding(.leading, 16)

            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color.white.opacity(0.92))
                .frame(width: 163.5, height: 148)
                .padding(.top, 16)
                .padding(.leading, 16)
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.black.opacity(0.72))
                            .frame(width: 76, height: 10)

                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.black.opacity(0.28))
                            .frame(width: 98, height: 8)

                        Spacer()

                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.black.opacity(0.72))
                            .frame(width: 68, height: 10)

                        RoundedRectangle(cornerRadius: 999, style: .continuous)
                            .fill(Color.black.opacity(0.08))
                            .frame(width: 123.5, height: 12)
                            .overlay(alignment: .leading) {
                                Capsule()
                                    .fill(Color(red: 0.26, green: 0.55, blue: 0.98))
                                    .frame(width: 56, height: 12)
                            }
                    }
                    .padding(.top, 32)
                    .padding(.leading, 36)
                }
        }
        .frame(
            width: NotificationDemoHomeContextLayout.canvasWidth,
            height: NotificationDemoHomeContextLayout.accountingHeight,
            alignment: .topLeading
        )
    }
}

private struct NotificationDemoCanvasBackground: View {
    var body: some View {
        ZStack {
            Color.black

            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.97, green: 0.94, blue: 0.86).opacity(0.82),
                            Color(red: 0.96, green: 0.90, blue: 0.72).opacity(0.28),
                            Color(red: 0.85, green: 0.78, blue: 0.60).opacity(0.12),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 260
                    )
                )
                .frame(width: 560, height: 420)
                .blur(radius: 20)
                .offset(x: 128, y: 120)

            Ellipse()
                .stroke(Color.white.opacity(0.08), lineWidth: 10)
                .frame(width: 520, height: 340)
                .blur(radius: 18)
                .offset(x: 92, y: 116)

            Ellipse()
                .stroke(Color(red: 0.95, green: 0.90, blue: 0.74).opacity(0.15), lineWidth: 20)
                .frame(width: 590, height: 380)
                .blur(radius: 22)
                .offset(x: 102, y: 106)
        }
    }
}
