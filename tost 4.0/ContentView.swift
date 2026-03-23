//
//  ContentView.swift
//  tost 4.0
//
//  Created by i sidnev on 18.03.2026.
//

import SwiftUI
import UIKit
import WebKit

struct ContentView: View {
    @ObservedObject var demoHomeBridge: NotificationDemoHomeBridge
    let activeTab: AppRootTab
    let onOpenNotificationCenter: () -> Void
    @State private var isLoading = true
    @State private var loadingOpacity = 0.0
    @State private var companyHeaderDisplayMode: CompanyHeaderDisplayMode = .regular
    @State private var isHeaderVisible = false
    @State private var isTotalVisible = false
    @State private var isActionsVisible = false
    @State private var isOperationsVisible = false
    @State private var isAccountsVisible = false
    @State private var isAccountingVisible = false
    @State private var toastLayoutProgress: CGFloat = 0
    @State private var toastLayoutTask: Task<Void, Never>?
    @State private var homePlaybackTask: Task<Void, Never>?
    @State private var didStartInitialLoad = false
    @State private var lastHandledHomePlaybackRequestID: UUID?
    @StateObject private var notificationController = NotificationAnimationController()
    @State private var initialContentLoadTracker = InitialHomeContentLoadTracker()
    private let placeholderHeight: CGFloat = 72
    private let placeholderLiftOffset: CGFloat = 8
    private let totalHeight: CGFloat = 141
    private let actionsHeight: CGFloat = 108
    private let totalSpacing: CGFloat = 16
    private let actionsSpacing: CGFloat = 4
    private let operationsSpacing: CGFloat = 32
    private let accountsSpacing: CGFloat = 16
    private let operationsWidth: CGFloat = 411
    private let operationsFrameHeight: CGFloat = 176
    private let operationsTopInset: CGFloat = 28
    private let operationsVisibleHeight: CGFloat = 108
    private let accountsWidth: CGFloat = 411
    private let accountsFrameHeight: CGFloat = 372
    private let accountsTopInset: CGFloat = 28
    private let accountsVisibleHeight: CGFloat = 304
    private let accountingSpacing: CGFloat = 16
    private let accountingFrameHeight: CGFloat = AccountingSectionView.Layout.totalHeight
    private let accountingVisibleHeight: CGFloat = AccountingSectionView.Layout.totalHeight
    private let contentBottomPadding: CGFloat = 32
    private let loadingDuration: UInt64 = 1_200_000_000
    private let sectionRevealOffset: CGFloat = 18
    private let toastAnimationDuration: Double = NotificationGlassMotionPreset.animationDuration
    private let toastDismissLiftLag: Double = 0.06
    private let accountingRevealAnimationDuration: Double = 0.34

    var body: some View {
        ZStack(alignment: .top) {
            BackgroundGlowView()

            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    loadedContent
                        .opacity(isLoading ? 0.001 : 1)
                        .allowsHitTesting(!isLoading)

                    if isLoading {
                        loadingContent
                    }
                }
            }
            .scrollDisabled(notificationController.isPresented)
            .onPreferenceChange(CompanyHeaderMinYPreferenceKey.self) { minY in
                updateCompanyHeaderMode(with: minY)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .onAppear {
            startInitialLoadIfNeeded()
            handlePendingHomePlaybackIfNeeded()
        }
        .onChange(of: notificationController.isPresented) { _, newValue in
            scheduleToastLayoutSync(with: newValue)
        }
        .onChange(of: demoHomeBridge.homePlaybackRequestID) { _, _ in
            handlePendingHomePlaybackIfNeeded()
        }
        .onChange(of: activeTab) { _, newValue in
            handleActiveTabChange(newValue)
        }
        .onChange(of: isLoading) { _, _ in
            handlePendingHomePlaybackIfNeeded()
        }
        .onDisappear {
            toastLayoutTask?.cancel()
            homePlaybackTask?.cancel()
        }
        .overlay(alignment: .top) {
            if !isLoading {
                compactHeaderOverlay
            }
        }
    }

    @ViewBuilder
    private var loadedContent: some View {
        ZStack(alignment: .topLeading) {
            PlaceholderMultipleView(
                showsBellVisual: showsInlineHeaderBellVisual,
                showsBellButton: notificationController.showsSourceBell,
                onBellTap: openNotificationCenter,
                onSVGReady: initialContentLoadTracker.markLoaded
            )
                .opacity(isHeaderVisible ? 1 : 0)
                .offset(y: placeholderTopOffset + revealOffset(for: isHeaderVisible))
                .background {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: CompanyHeaderMinYPreferenceKey.self,
                            value: proxy.frame(in: .global).minY
                        )
                    }
                }

            TotalView(onSVGReady: initialContentLoadTracker.markLoaded)
                .opacity(isTotalVisible ? 1 : 0)
                .offset(y: totalTopOffset + revealOffset(for: isTotalVisible))

            ActionsView(onSVGReady: initialContentLoadTracker.markLoaded)
                .opacity(isActionsVisible ? 1 : 0)
                .offset(y: actionsTopOffset + revealOffset(for: isActionsVisible))

            OperationsView(onSVGReady: initialContentLoadTracker.markLoaded)
                .opacity(isOperationsVisible ? 1 : 0)
                .offset(y: operationsTopOffset + revealOffset(for: isOperationsVisible))

            AccountsView(onSVGReady: initialContentLoadTracker.markLoaded)
                .opacity(isAccountsVisible ? 1 : 0)
                .offset(y: accountsTopOffset + revealOffset(for: isAccountsVisible))

            AccountingSectionView()
                .opacity(isAccountingVisible ? 1 : 0)
                .offset(y: accountingTopOffset + revealOffset(for: isAccountingVisible))

            notificationMorphView
                .zIndex(1)
        }
        .frame(maxWidth: .infinity, minHeight: contentHeight, alignment: .top)
    }

    private var loadingContent: some View {
        PageLoadingView(
            placeholderHeight: placeholderHeight,
            totalHeight: totalHeight,
            actionsHeight: actionsHeight,
            operationsHeight: operationsVisibleHeight,
            accountsHeight: accountsVisibleHeight,
            accountingHeight: accountingVisibleHeight,
            totalSpacing: totalSpacing,
            actionsSpacing: actionsSpacing,
            operationsSpacing: operationsSpacing,
            accountsSpacing: accountsSpacing,
            accountingSpacing: accountingSpacing,
            contentBottomPadding: contentBottomPadding
        )
        .opacity(loadingOpacity)
        .frame(maxWidth: .infinity, minHeight: loadingContentHeight, alignment: .top)
    }

    private var compactHeaderOverlay: some View {
        GeometryReader { proxy in
            CompactCompanyHeaderView(
                title: "Додо Франчайзинг",
                subtitle: "Директор"
            )
            .padding(.top, proxy.safeAreaInsets.top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .opacity(companyHeaderDisplayMode == .compact && isHeaderVisible ? 1 : 0)
            .offset(y: companyHeaderDisplayMode == .compact ? 0 : -8)
            .animation(.easeOut(duration: 0.22), value: companyHeaderDisplayMode)
        }
        .allowsHitTesting(false)
    }

    private var notificationMorphView: some View {
        NotificationPresenter(
            isPresented: $notificationController.isPresented,
            showsSourceBell: $notificationController.showsSourceBell,
            glassStyle: notificationMorphStyle,
            liquidConfig: liquidNotificationConfig,
            liquidNotificationText: "Новое уведомление",
            liquidOffset: CGSize(width: liquidNotificationOffsetX, height: liquidNotificationOffsetY),
            onDismissMorphStart: scheduleToastCollapseFromDismissMorphStart
        ) {
            currentNotificationContentView
        }
    }

    @ViewBuilder
    private var currentNotificationContentView: some View {
        NotificationContentFactory.makeView(for: currentNotificationScenario)
            .id(currentNotificationScenario.id)
    }

    private var currentNotificationScenario: NotificationScenario {
        demoHomeBridge.selectedScenario
    }

    private var currentNotificationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: currentNotificationScenario)
    }

    private var toastHeight: CGFloat {
        currentNotificationMetrics.containerHeight
    }

    private var toastCardHeight: CGFloat {
        currentNotificationMetrics.contentHeight
    }

    private var toastWidth: CGFloat {
        currentNotificationMetrics.contentWidth
    }

    private var placeholderTopOffset: CGFloat {
        max(animatedToastLayoutHeight - placeholderLiftOffset, 0)
    }

    private var showsInlineHeaderBellVisual: Bool {
        if #available(iOS 26.0, *) {
            return false
        }

        return notificationController.showsSourceBell
    }

    private var currentNotificationBellCenter: CGPoint {
        CGPoint(
            x: PlaceholderMultipleView.Layout.bellCenter.x,
            y: PlaceholderMultipleView.Layout.bellCenter.y +
                placeholderTopOffset +
                revealOffset(for: isHeaderVisible)
        )
    }

    private var totalTopOffset: CGFloat {
        placeholderTopOffset + placeholderHeight + totalSpacing
    }

    private var actionsTopOffset: CGFloat {
        totalTopOffset + totalHeight + actionsSpacing
    }

    private var operationsVisibleTopOffset: CGFloat {
        actionsTopOffset + actionsHeight + operationsSpacing
    }

    private var operationsTopOffset: CGFloat {
        operationsVisibleTopOffset - operationsTopInset
    }

    private var accountsVisibleTopOffset: CGFloat {
        operationsVisibleTopOffset + operationsVisibleHeight + accountsSpacing
    }

    private var accountsTopOffset: CGFloat {
        accountsVisibleTopOffset - accountsTopInset
    }

    private var accountingVisibleTopOffset: CGFloat {
        accountsTopOffset + accountsFrameHeight + accountingSpacing
    }

    private var accountingTopOffset: CGFloat {
        accountingVisibleTopOffset
    }

    private var contentHeight: CGFloat {
        accountingTopOffset + accountingFrameHeight + contentBottomPadding
    }

    private var loadingContentHeight: CGFloat {
        placeholderHeight +
            totalSpacing +
            totalHeight +
            actionsSpacing +
            actionsHeight +
            operationsSpacing +
            operationsVisibleHeight +
            accountsSpacing +
            accountsVisibleHeight +
            accountingSpacing +
            accountingVisibleHeight +
            contentBottomPadding
    }

    private var liquidNotificationConfig: LiquidNotificationConfig {
        LiquidNotificationConfig(
            buttonSize: 64,
            pillSize: CGSize(width: 146, height: 46),
            verticalOffset: 88,
            blurRadius: 16,
            alphaThreshold: 0.5,
            themeColor: Color(red: 0.24, green: 0.26, blue: 0.34)
        )
    }

    private var notificationMorphStyle: GlassMorphNotificationStyle {
        var style = GlassMorphNotificationStyle()
        style.applySharedMotionPreset()
        style.containerSize = CGSize(width: 375, height: toastHeight)
        style.notificationFrame = CGRect(x: 12, y: 0, width: toastWidth, height: toastCardHeight)
        style.footerVariant = currentNotificationMetrics.footerVariant
        style.buttonSize = PlaceholderMultipleView.Layout.bellSize
        style.buttonCenter = currentNotificationBellCenter
        style.glassContainerSpacing = 50
        style.splitStartProgress = 0.95
        style.preTearStartProgress = 0.968
        style.tearProgress = 0.992
        style.finalCornerRadius = 32
        return style
    }

    private var liquidNotificationOffsetX: CGFloat {
        currentNotificationBellCenter.x - (liquidNotificationConfig.containerSize / 2)
    }

    private var liquidNotificationOffsetY: CGFloat {
        currentNotificationBellCenter.y -
            (liquidNotificationConfig.containerSize - (liquidNotificationConfig.buttonSize / 2))
    }

    private var animatedToastLayoutHeight: CGFloat {
        toastHeight * toastLayoutProgress
    }

    private func revealOffset(for isVisible: Bool) -> CGFloat {
        isVisible ? 0 : sectionRevealOffset
    }

    private func startInitialLoadIfNeeded() {
        guard !didStartInitialLoad else { return }
        didStartInitialLoad = true

        Task { @MainActor in
            companyHeaderDisplayMode = .regular
            isHeaderVisible = false
            isTotalVisible = false
            isActionsVisible = false
            isOperationsVisible = false
            isAccountsVisible = false
            isAccountingVisible = false
            notificationController.reset()
            loadingOpacity = 0

            withAnimation(.easeOut(duration: 0.24)) {
                loadingOpacity = 1
            }

            let minimumDelayTask = Task {
                try? await Task.sleep(nanoseconds: loadingDuration)
            }
            let initialContentReadyTask = Task {
                await initialContentLoadTracker.waitUntilReady(timeoutNanoseconds: 5_000_000_000)
            }
            _ = await (minimumDelayTask.value, initialContentReadyTask.value)

            isLoading = false

            try? await revealLoadedContent()
            handlePendingHomePlaybackIfNeeded()
        }
    }

    private func revealLoadedContent() async throws {
        withAnimation(.easeOut(duration: 0.3)) {
            isHeaderVisible = true
        }

        try await Task.sleep(nanoseconds: 70_000_000)

        withAnimation(.easeOut(duration: 0.3)) {
            isTotalVisible = true
        }

        try await Task.sleep(nanoseconds: 60_000_000)

        withAnimation(.easeOut(duration: 0.3)) {
            isActionsVisible = true
        }

        try await Task.sleep(nanoseconds: 60_000_000)

        withAnimation(.easeOut(duration: 0.32)) {
            isOperationsVisible = true
        }

        try await Task.sleep(nanoseconds: 170_000_000)

        withAnimation(.easeOut(duration: 0.34)) {
            isAccountsVisible = true
        }

        try await Task.sleep(nanoseconds: 70_000_000)

        withAnimation(.easeOut(duration: accountingRevealAnimationDuration)) {
            isAccountingVisible = true
        }

        try await Task.sleep(
            nanoseconds: UInt64(accountingRevealAnimationDuration * 1_000_000_000)
        )
    }

    private func handlePendingHomePlaybackIfNeeded() {
        guard activeTab == .home, !isLoading else { return }
        guard let requestID = demoHomeBridge.homePlaybackRequestID else { return }
        guard lastHandledHomePlaybackRequestID != requestID else { return }

        playSelectedScenarioOnHome(for: requestID)
    }

    private func handleActiveTabChange(_ newValue: AppRootTab) {
        if newValue == .home {
            handlePendingHomePlaybackIfNeeded()
        } else {
            resetHomeNotificationState()
        }
    }

    private func playSelectedScenarioOnHome(for requestID: UUID) {
        homePlaybackTask?.cancel()
        resetHomeNotificationState()

        homePlaybackTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 120_000_000)

            guard !Task.isCancelled else { return }
            guard activeTab == .home, !isLoading else { return }
            guard demoHomeBridge.homePlaybackRequestID == requestID else { return }

            lastHandledHomePlaybackRequestID = requestID
            notificationController.present()
        }
    }

    private func resetHomeNotificationState() {
        homePlaybackTask?.cancel()
        notificationController.reset(showsSourceBell: true)
        syncToastLayout(with: false)
    }

    private func scheduleToastLayoutSync(with isVisible: Bool) {
        toastLayoutTask?.cancel()

        toastLayoutTask = Task { @MainActor in
            if isVisible {
                syncToastLayout(with: true)
                return
            }

            if #available(iOS 26.0, *) {
                return
            }

            try? await Task.sleep(
                nanoseconds: UInt64((toastAnimationDuration + 0.04) * 1_000_000_000)
            )

            guard !Task.isCancelled, !notificationController.isPresented else { return }
            syncToastLayout(with: false)
        }
    }

    private func scheduleToastCollapseFromDismissMorphStart() {
        toastLayoutTask?.cancel()

        toastLayoutTask = Task { @MainActor in
            try? await Task.sleep(
                nanoseconds: UInt64(toastDismissLiftLag * 1_000_000_000)
            )

            guard !Task.isCancelled, !notificationController.isPresented else { return }
            syncToastLayout(with: false)
        }
    }

    private func syncToastLayout(with isVisible: Bool) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
            toastLayoutProgress = isVisible ? 1 : 0
        }
    }

    private func openNotificationCenter() {
        if notificationController.isPresented {
            resetHomeNotificationState()
        }

        onOpenNotificationCenter()
    }

    private func updateCompanyHeaderMode(with minY: CGFloat) {
        let nextMode: CompanyHeaderDisplayMode =
            minY <= CompactCompanyHeaderView.Layout.revealMinY ? .compact : .regular
        guard nextMode != companyHeaderDisplayMode else { return }

        withAnimation(.easeOut(duration: 0.22)) {
            companyHeaderDisplayMode = nextMode
        }
    }
}

private struct BackgroundGlowView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

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

private struct PlaceholderMultipleView: View {
    enum Layout {
        static let width: CGFloat = 375
        static let height: CGFloat = 72
        static let bellSize: CGFloat = 40
        static let bellOrigin = CGPoint(x: 319, y: 16)
        static let bellCenter = CGPoint(x: bellOrigin.x + (bellSize / 2), y: bellOrigin.y + (bellSize / 2))
        static let bellMaskSize: CGFloat = 48
        static let bellMaskOrigin = CGPoint(x: 315, y: 12)
        static let bellHitSize: CGFloat = 56
        static let bellHitOrigin = CGPoint(x: bellCenter.x - (bellHitSize / 2), y: bellCenter.y - (bellHitSize / 2))
    }

    let showsBellVisual: Bool
    let showsBellButton: Bool
    let onBellTap: () -> Void
    let onSVGReady: (String) -> Void

    var body: some View {
        InlineSVGWebView(
            svg: placeholderMultipleSVG,
            loadID: InitialHomeContentLoadTracker.LoadID.placeholder.rawValue,
            onLoad: onSVGReady
        )
            .frame(width: Layout.width, height: Layout.height)
            .overlay(alignment: .topLeading) {
                Circle()
                    .fill(Color.black)
                    .frame(width: Layout.bellMaskSize, height: Layout.bellMaskSize)
                    .offset(x: Layout.bellMaskOrigin.x, y: Layout.bellMaskOrigin.y)
            }
            .overlay(alignment: .topLeading) {
                if showsBellVisual {
                    NotificationBellVisual(size: Layout.bellSize)
                        .offset(x: Layout.bellOrigin.x, y: Layout.bellOrigin.y)
                }
            }
            .overlay(alignment: .topLeading) {
                if showsBellButton {
                    NotificationBellButton(action: onBellTap)
                        .offset(x: Layout.bellHitOrigin.x, y: Layout.bellHitOrigin.y)
                }
            }
    }
}

private struct NotificationBellButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Color.clear
                .frame(width: 56, height: 56)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct TotalView: View {
    let onSVGReady: (String) -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            InlineSVGWebView(
                svg: totalSVG,
                loadID: InitialHomeContentLoadTracker.LoadID.total.rawValue,
                onLoad: onSVGReady
            )
                .frame(width: 323, height: 125)
        }
        .padding(.horizontal, 0)
        .padding(.top, 0)
        .padding(.bottom, 16)
        .frame(width: 323, alignment: .top)
        .frame(width: 375, alignment: .center)
    }
}

private struct ActionsView: View {
    let onSVGReady: (String) -> Void

    var body: some View {
        HStack(alignment: .top) {
            ActionItemView(
                label: "Создать платеж",
                icon: {
                    InlineSVGWebView(
                        svg: containerSVG,
                        loadID: InitialHomeContentLoadTracker.LoadID.actionCreate.rawValue,
                        onLoad: onSVGReady
                    )
                        .frame(width: 72, height: 56)
                }
            )

            Spacer()

            ActionItemView(
                label: "Выставить счет",
                icon: {
                    InlineSVGWebView(
                        svg: container1SVG,
                        loadID: InitialHomeContentLoadTracker.LoadID.actionInvoice.rawValue,
                        onLoad: onSVGReady
                    )
                        .frame(width: 72, height: 56)
                }
            )

            Spacer()

            ActionItemView(
                label: "Загрузить счет",
                icon: {
                    InlineSVGWebView(
                        svg: container2SVG,
                        loadID: InitialHomeContentLoadTracker.LoadID.actionUpload.rawValue,
                        onLoad: onSVGReady
                    )
                        .frame(width: 72, height: 56)
                }
            )

            Spacer()

            ActionItemView(
                label: "Все действия",
                icon: {
                    AllActionsIconView(onSVGReady: onSVGReady)
                        .frame(width: 72, height: 56, alignment: .center)
                }
            )
        }
        .padding(.horizontal, 16)
        .frame(width: 375, height: 108, alignment: .top)
    }
}

private struct PageLoadingView: View {
    let placeholderHeight: CGFloat
    let totalHeight: CGFloat
    let actionsHeight: CGFloat
    let operationsHeight: CGFloat
    let accountsHeight: CGFloat
    let accountingHeight: CGFloat
    let totalSpacing: CGFloat
    let actionsSpacing: CGFloat
    let operationsSpacing: CGFloat
    let accountsSpacing: CGFloat
    let accountingSpacing: CGFloat
    let contentBottomPadding: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            ShimmerBlockView(height: placeholderHeight)

            Spacer()
                .frame(height: totalSpacing)

            ShimmerBlockView(height: totalHeight)

            Spacer()
                .frame(height: actionsSpacing)

            ShimmerBlockView(height: actionsHeight)

            Spacer()
                .frame(height: operationsSpacing)

            ShimmerBlockView(height: operationsHeight)

            Spacer()
                .frame(height: accountsSpacing)

            ShimmerBlockView(height: accountsHeight)

            Spacer()
                .frame(height: accountingSpacing)

            ShimmerBlockView(height: accountingHeight)
        }
        .padding(.bottom, contentBottomPadding)
        .frame(width: 375, alignment: .topLeading)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

private enum CompanyHeaderDisplayMode {
    case regular
    case compact
}

private struct CompanyHeaderMinYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct ShimmerBlockView: View {
    let height: CGFloat

    @State private var shimmerOffset: CGFloat = -180
    private let blockWidth: CGFloat = 343

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

        shape
            .fill(Color.white.opacity(0.15))
            .frame(width: blockWidth, height: height)
            .overlay {
                LinearGradient(
                    colors: [
                        .clear,
                        Color.white.opacity(0.16),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 120, height: height * 1.6)
                .rotationEffect(.degrees(18))
                .offset(x: shimmerOffset, y: -height * 0.1)
                .blendMode(.screen)
                .mask {
                    shape
                        .frame(width: blockWidth, height: height)
                }
            }
            .frame(width: 375, height: height, alignment: .center)
            .onAppear {
                shimmerOffset = -180

                withAnimation(.linear(duration: 1.15).repeatForever(autoreverses: false)) {
                    shimmerOffset = 180
                }
            }
    }
}

private struct ActionItemView<Icon: View>: View {
    let label: String
    @ViewBuilder let icon: Icon

    var body: some View {
        VStack(spacing: 10) {
            icon

            Text(label)
                .font(.custom("SF Pro Text", size: 13))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .top)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 72, alignment: .top)
    }
}

private struct AllActionsIconView: View {
    let onSVGReady: (String) -> Void

    var body: some View {
        Group {
            if let backgroundImage = allActionsBackgroundImage {
                Image(uiImage: backgroundImage)
                    .resizable()
                    .interpolation(.high)
                    .frame(width: 56, height: 56)
                    .overlay {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                badgeView(svg: badgeSVG)
                                badgeView(svg: badge1SVG)
                            }

                            HStack(spacing: 8) {
                                badgeView(svg: badge2SVG)
                                badgeView(svg: badge3SVG)
                            }
                        }
                    }
            } else {
                Color.clear
                    .frame(width: 56, height: 56)
            }
        }
    }

    private func badgeView(svg: String) -> some View {
        InlineSVGWebView(
            svg: svg,
            loadID: badgeLoadID(for: svg),
            onLoad: onSVGReady
        )
            .frame(width: 16, height: 16)
    }

    private func badgeLoadID(for svg: String) -> String {
        switch svg {
        case badgeSVG:
            return InitialHomeContentLoadTracker.LoadID.badge0.rawValue
        case badge1SVG:
            return InitialHomeContentLoadTracker.LoadID.badge1.rawValue
        case badge2SVG:
            return InitialHomeContentLoadTracker.LoadID.badge2.rawValue
        default:
            return InitialHomeContentLoadTracker.LoadID.badge3.rawValue
        }
    }
}

private struct OperationsView: View {
    let onSVGReady: (String) -> Void

    var body: some View {
        InlineSVGWebView(
            svg: operationsSVG,
            loadID: InitialHomeContentLoadTracker.LoadID.operations.rawValue,
            onLoad: onSVGReady
        )
            .frame(width: 411, height: 176)
            .frame(width: 375, alignment: .center)
    }
}

private struct AccountsView: View {
    let onSVGReady: (String) -> Void

    var body: some View {
        InlineSVGWebView(
            svg: accountsSVG,
            loadID: InitialHomeContentLoadTracker.LoadID.accounts.rawValue,
            onLoad: onSVGReady
        )
            .frame(width: 411, height: 372)
            .frame(width: 375, alignment: .center)
    }
}

struct InlineSVGWebView: UIViewRepresentable {
    let svg: String
    var loadID: String? = nil
    var onLoad: ((String) -> Void)? = nil

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .clear
        webView.isUserInteractionEnabled = false
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            html, body {
              margin: 0;
              width: 100%;
              height: 100%;
              background: transparent;
              overflow: hidden;
              font-family: "SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif;
            }

            svg {
              display: block;
              width: 100%;
              height: 100%;
            }

            svg, text, tspan, div, span, p, foreignObject {
              font-family: "SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif !important;
              -webkit-font-smoothing: antialiased;
              text-rendering: geometricPrecision;
            }
          </style>
        </head>
        <body>
        \(svg)
        </body>
        </html>
        """

        context.coordinator.loadID = loadID
        context.coordinator.onLoad = onLoad

        guard context.coordinator.lastHTML != html else {
            if let loadID, context.coordinator.hasCompletedInitialLoad {
                onLoad?(loadID)
            }
            return
        }

        context.coordinator.lastHTML = html
        context.coordinator.hasCompletedInitialLoad = false
        webView.loadHTMLString(html, baseURL: nil)
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var lastHTML: String?
        var loadID: String?
        var onLoad: ((String) -> Void)?
        var hasCompletedInitialLoad = false

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard !hasCompletedInitialLoad else { return }
            hasCompletedInitialLoad = true
            guard let loadID else { return }
            onLoad?(loadID)
        }
    }
}

@MainActor
private final class InitialHomeContentLoadTracker {
    enum LoadID: String, CaseIterable {
        case placeholder
        case total
        case actionCreate
        case actionInvoice
        case actionUpload
        case badge0
        case badge1
        case badge2
        case badge3
        case operations
        case accounts
    }

    private let expectedIDs = Set(LoadID.allCases.map(\.rawValue))
    private var loadedIDs = Set<String>()

    func markLoaded(_ id: String) {
        loadedIDs.insert(id)
    }

    func waitUntilReady(timeoutNanoseconds: UInt64) async {
        let deadline = Date().timeIntervalSince1970 + (Double(timeoutNanoseconds) / 1_000_000_000)

        while loadedIDs != expectedIDs {
            if Date().timeIntervalSince1970 >= deadline {
                break
            }

            try? await Task.sleep(nanoseconds: 25_000_000)
        }
    }
}

private let toastSVG = #"""
<svg width="351" height="134" viewBox="12 0 351 134" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_2231_120931)">
<rect x="12" width="351" height="114" rx="32" fill="white" fill-opacity="0.1"/>
<rect width="351" height="114" transform="translate(12)" fill="black" fill-opacity="0.01"/>
<g clip-path="url(#clip1_2231_120931)">
<path d="M36.0063 30V21.0205H32.7544V19.4312H41.1553V21.0205H37.896V30H36.0063ZM45.4123 30.1611C43.032 30.1611 41.5891 28.5645 41.5891 26.0156V26.0083C41.5891 23.4888 43.0466 21.8408 45.3245 21.8408C47.6023 21.8408 49.0085 23.4375 49.0085 25.8545V26.4551H43.4128C43.4348 27.8906 44.2112 28.7256 45.449 28.7256C46.4377 28.7256 47.0017 28.2275 47.1775 27.8613L47.1995 27.8101H48.9353L48.9133 27.876C48.657 28.9087 47.5876 30.1611 45.4123 30.1611ZM45.3464 23.269C44.3284 23.269 43.5666 23.9575 43.4275 25.2319H47.2288C47.1042 23.9209 46.3645 23.269 45.3464 23.269ZM52.9653 26.543H52.5552V30H50.7314V21.9946H52.5552V25.21H52.9507L55.5874 21.9946H57.6821L54.4521 25.7007L57.8359 30H55.6313L52.9653 26.543ZM62.2981 30.1611C59.8884 30.1611 58.4675 28.6011 58.4675 25.9863V25.9717C58.4675 23.3862 59.8811 21.8408 62.2907 21.8408C64.3488 21.8408 65.5793 22.9834 65.7844 24.6387V24.668H64.0632L64.0559 24.646C63.8874 23.8696 63.2942 23.313 62.2981 23.313C61.0529 23.313 60.3205 24.2944 60.3205 25.9717V25.9863C60.3205 27.6855 61.0603 28.6816 62.2981 28.6816C63.2429 28.6816 63.8215 28.2495 64.0486 27.4072L64.0632 27.3779L65.7844 27.3706L65.7697 27.4292C65.5061 29.0698 64.3269 30.1611 62.2981 30.1611ZM73.2129 21.9946V23.4082H70.7446V30H68.9209V23.4082H66.4599V21.9946H73.2129ZM80.687 26.543H80.2768V30H78.4531V21.9946H80.2768V25.21H80.6723L83.309 21.9946H85.4038L82.1738 25.7007L85.5576 30H83.353L80.687 26.543ZM90.0417 30.1611C87.6393 30.1611 86.1891 28.5938 86.1891 26.001V25.9863C86.1891 23.4155 87.6613 21.8408 90.0417 21.8408C92.4294 21.8408 93.8942 23.4082 93.8942 25.9863V26.001C93.8942 28.5938 92.4367 30.1611 90.0417 30.1611ZM90.0417 28.6816C91.3088 28.6816 92.0265 27.6929 92.0265 26.0083V25.9937C92.0265 24.3091 91.3014 23.313 90.0417 23.313C88.7746 23.313 88.0495 24.3091 88.0495 25.9937V26.0083C88.0495 27.6929 88.7746 28.6816 90.0417 28.6816ZM97.3676 30H95.6244V21.9946H97.9462L100.312 27.5684H100.444L102.817 21.9946H105.095V30H103.351V24.5361H103.212L101.008 29.6411H99.704L97.5068 24.5361H97.3676V30ZM108.964 30H107.22V21.9946H109.542L111.908 27.5684H112.04L114.413 21.9946H116.691V30H114.947V24.5361H114.808L112.604 29.6411H111.3L109.103 24.5361H108.964V30ZM119.681 32.8125C119.461 32.8125 119.204 32.8052 118.985 32.7832V31.3843C119.131 31.3989 119.336 31.4062 119.527 31.4062C120.274 31.4062 120.721 31.0986 120.918 30.3735L121.014 30.0073L118.15 21.9946H120.142L122.01 28.2495H122.149L124.009 21.9946H125.928L123.057 30.1685C122.369 32.1753 121.453 32.8125 119.681 32.8125ZM132.595 30V26.5796H129.218V30H127.395V21.9946H129.218V25.166H132.595V21.9946H134.419V30H132.595ZM136.544 30V21.9946H138.346V27.356H138.493L141.869 21.9946H143.671V30H141.869V24.6094H141.715L138.346 30H136.544ZM148.03 26.543H147.62V30H145.797V21.9946H147.62V25.21H148.016L150.652 21.9946H152.747L149.517 25.7007L152.901 30H150.696L148.03 26.543ZM156.213 30.1318C154.69 30.1318 153.584 29.1943 153.584 27.7368V27.7222C153.584 26.2939 154.675 25.459 156.623 25.3418L158.682 25.2173V24.5288C158.682 23.7305 158.161 23.291 157.18 23.291C156.345 23.291 155.803 23.5913 155.62 24.1187L155.613 24.1479H153.891L153.899 24.082C154.075 22.7344 155.364 21.8408 157.268 21.8408C159.326 21.8408 160.483 22.8369 160.483 24.5288V30H158.682V28.9014H158.557C158.118 29.6777 157.268 30.1318 156.213 30.1318ZM155.386 27.6489C155.386 28.3301 155.964 28.7329 156.77 28.7329C157.869 28.7329 158.682 28.0151 158.682 27.063V26.4185L156.88 26.5356C155.862 26.6016 155.386 26.9751 155.386 27.6343V27.6489ZM169.062 32.0874V30H162.572V21.9946H164.396V28.5938H167.699V21.9946H169.523V28.5938H170.754V32.0874H169.062ZM172.074 30V21.9946H173.875V27.356H174.022L177.398 21.9946H179.2V30H177.398V24.6094H177.244L173.875 30H172.074ZM181.326 30V21.9946H183.128V27.356H183.274L186.65 21.9946H188.452V30H186.65V24.6094H186.497L183.128 30H181.326ZM35.8232 50.6587C34.3584 48.8203 33.6846 46.5278 33.6846 43.7739C33.6846 41.0127 34.3584 38.7202 35.8232 36.8965H37.4639C36.3799 38.2661 35.5596 41.1812 35.5596 43.7739C35.5596 46.3813 36.3799 49.2744 37.4639 50.6587H35.8232ZM42.5852 48.1611C40.1829 48.1611 38.7327 46.5938 38.7327 44.001V43.9863C38.7327 41.4155 40.2048 39.8408 42.5852 39.8408C44.9729 39.8408 46.4377 41.4082 46.4377 43.9863V44.001C46.4377 46.5938 44.9802 48.1611 42.5852 48.1611ZM42.5852 46.6816C43.8523 46.6816 44.5701 45.6929 44.5701 44.0083V43.9937C44.5701 42.3091 43.845 41.313 42.5852 41.313C41.3181 41.313 40.593 42.3091 40.593 43.9937V44.0083C40.593 45.6929 41.3181 46.6816 42.5852 46.6816ZM53.5659 41.4082H49.9917V48H48.1679V39.9946H53.5659V41.4082ZM55.1716 50.6587V39.9946H56.9953V41.2471H57.1198C57.5593 40.3755 58.4309 39.8628 59.5515 39.8628C61.5583 39.8628 62.8401 41.4595 62.8401 43.9937V44.0083C62.8401 46.5571 61.5803 48.1318 59.5515 48.1318C58.4529 48.1318 57.5373 47.5898 57.1198 46.7256H56.9953V50.6587H55.1716ZM58.9802 46.5938C60.2253 46.5938 60.9797 45.6123 60.9797 44.0083V43.9937C60.9797 42.3823 60.2253 41.4009 58.9802 41.4009C57.7424 41.4009 56.9734 42.3823 56.9734 43.9863V44.001C56.9734 45.605 57.7424 46.5938 58.9802 46.5938ZM66.7675 48.1318C65.2441 48.1318 64.1381 47.1943 64.1381 45.7368V45.7222C64.1381 44.2939 65.2295 43.459 67.1777 43.3418L69.2358 43.2173V42.5288C69.2358 41.7305 68.7158 41.291 67.7343 41.291C66.8994 41.291 66.3574 41.5913 66.1743 42.1187L66.167 42.1479H64.4458L64.4531 42.082C64.6289 40.7344 65.9179 39.8408 67.8222 39.8408C69.8803 39.8408 71.0376 40.8369 71.0376 42.5288V48H69.2358V46.9014H69.1113C68.6718 47.6777 67.8222 48.1318 66.7675 48.1318ZM65.9399 45.6489C65.9399 46.3301 66.5185 46.7329 67.3242 46.7329C68.4228 46.7329 69.2358 46.0151 69.2358 45.063V44.4185L67.434 44.5356C66.416 44.6016 65.9399 44.9751 65.9399 45.6343V45.6489ZM78.3269 48V44.5796H74.9504V48H73.1267V39.9946H74.9504V43.166H78.3269V39.9946H80.1506V48H78.3269ZM82.2763 48V39.9946H84.0781V45.356H84.2246L87.601 39.9946H89.4028V48H87.601V42.6094H87.4472L84.0781 48H82.2763ZM98.1716 48H96.3478V44.7993H96.216C95.7912 45.1216 95.1686 45.3193 94.3483 45.3193C92.444 45.3193 91.3674 44.1694 91.3674 42.3896V39.9946H93.1911V42.2358C93.1911 43.2246 93.6965 43.7812 94.6926 43.7812C95.4909 43.7812 96.0549 43.5688 96.3478 43.2686V39.9946H98.1716V48ZM103.732 48.1611C101.352 48.1611 99.9091 46.5645 99.9091 44.0156V44.0083C99.9091 41.4888 101.367 39.8408 103.644 39.8408C105.922 39.8408 107.329 41.4375 107.329 43.8545V44.4551H101.733C101.755 45.8906 102.531 46.7256 103.769 46.7256C104.758 46.7256 105.322 46.2275 105.497 45.8613L105.519 45.8101H107.255L107.233 45.876C106.977 46.9087 105.908 48.1611 103.732 48.1611ZM103.666 41.269C102.648 41.269 101.887 41.9575 101.747 43.2319H105.549C105.424 41.9209 104.684 41.269 103.666 41.269ZM114.252 48V44.5796H110.875V48H109.051V39.9946H110.875V43.166H114.252V39.9946H116.075V48H114.252ZM118.201 48V39.9946H120.003V45.356H120.149L123.526 39.9946H125.328V48H123.526V42.6094H123.372L120.003 48H118.201ZM130.888 48.1611C128.508 48.1611 127.065 46.5645 127.065 44.0156V44.0083C127.065 41.4888 128.523 39.8408 130.8 39.8408C133.078 39.8408 134.485 41.4375 134.485 43.8545V44.4551H128.889C128.911 45.8906 129.687 46.7256 130.925 46.7256C131.914 46.7256 132.478 46.2275 132.653 45.8613L132.675 45.8101H134.411L134.389 45.876C134.133 46.9087 133.064 48.1611 130.888 48.1611ZM130.822 41.269C129.804 41.269 129.043 41.9575 128.903 43.2319H132.705C132.58 41.9209 131.84 41.269 130.822 41.269ZM139.966 48V39.9946H143.753C145.364 39.9946 146.309 40.8076 146.309 42.0381V42.0527C146.309 42.8877 145.731 43.6274 144.918 43.7666V43.8911C145.972 44.0083 146.668 44.7407 146.668 45.7075V45.7222C146.668 47.0845 145.584 48 143.804 48H139.966ZM141.768 43.3198H143.174C144.075 43.3198 144.515 42.9536 144.515 42.2871V42.2725C144.515 41.6646 144.127 41.2544 143.321 41.2544H141.768V43.3198ZM141.768 46.7402H143.475C144.354 46.7402 144.8 46.3301 144.8 45.6416V45.627C144.8 44.9019 144.302 44.543 143.306 44.543H141.768V46.7402ZM152.143 48V46.7256L155.614 43.1807C157.05 41.7305 157.453 41.1958 157.453 40.3828V40.3608C157.453 39.3867 156.786 38.6836 155.688 38.6836C154.567 38.6836 153.813 39.4233 153.813 40.5146L153.805 40.5439L152.047 40.5366L152.04 40.5146C152.04 38.5444 153.578 37.1675 155.783 37.1675C157.841 37.1675 159.32 38.4199 159.32 40.1997V40.2217C159.32 41.4229 158.742 42.375 156.816 44.228L154.699 46.2788V46.4326H159.482V48H152.143ZM168.611 48.1611C166.201 48.1611 164.78 46.6011 164.78 43.9863V43.9717C164.78 41.3862 166.194 39.8408 168.604 39.8408C170.662 39.8408 171.892 40.9834 172.097 42.6387V42.668H170.376L170.369 42.646C170.2 41.8696 169.607 41.313 168.611 41.313C167.366 41.313 166.633 42.2944 166.633 43.9717V43.9863C166.633 45.6855 167.373 46.6816 168.611 46.6816C169.556 46.6816 170.134 46.2495 170.361 45.4072L170.376 45.3779L172.097 45.3706L172.083 45.4292C171.819 47.0698 170.64 48.1611 168.611 48.1611ZM179.526 39.9946V41.4082H177.057V48H175.234V41.4082H172.773V39.9946H179.526ZM181.014 50.6587V39.9946H182.838V41.2471H182.962C183.402 40.3755 184.273 39.8628 185.394 39.8628C187.401 39.8628 188.683 41.4595 188.683 43.9937V44.0083C188.683 46.5571 187.423 48.1318 185.394 48.1318C184.295 48.1318 183.38 47.5898 182.962 46.7256H182.838V50.6587H181.014ZM184.823 46.5938C186.068 46.5938 186.822 45.6123 186.822 44.0083V43.9937C186.822 42.3823 186.068 41.4009 184.823 41.4009C183.585 41.4009 182.816 42.3823 182.816 43.9863V44.001C182.816 45.605 183.585 46.5938 184.823 46.5938ZM193.885 48.1611C191.482 48.1611 190.032 46.5938 190.032 44.001V43.9863C190.032 41.4155 191.504 39.8408 193.885 39.8408C196.272 39.8408 197.737 41.4082 197.737 43.9863V44.001C197.737 46.5938 196.28 48.1611 193.885 48.1611ZM193.885 46.6816C195.152 46.6816 195.869 45.6929 195.869 44.0083V43.9937C195.869 42.3091 195.144 41.313 193.885 41.313C192.617 41.313 191.892 42.3091 191.892 43.9937V44.0083C191.892 45.6929 192.617 46.6816 193.885 46.6816ZM201.701 44.543H201.291V48H199.467V39.9946H201.291V43.21H201.687L204.323 39.9946H206.418L203.188 43.7007L206.572 48H204.367L201.701 44.543ZM207.958 48V39.9946H209.76V45.356H209.906L213.283 39.9946H215.084V48H213.283V42.6094H213.129L209.76 48H207.958ZM218.382 50.6587H216.741C217.825 49.2744 218.646 46.3813 218.646 43.7739C218.646 41.1812 217.825 38.2661 216.741 36.8965H218.382C219.847 38.7202 220.521 41.0127 220.521 43.7739C220.521 46.5278 219.847 48.8203 218.382 50.6587Z" fill="white"/>
<rect x="32" y="64" width="79" height="30" rx="15" fill="white" fill-opacity="0.15"/>
<path d="M51.9734 84H50.3421V76.2178H45.9558V84H44.3181V74.8403H51.9734V84ZM57.0985 84.1396C56.4087 84.1396 55.8162 83.9937 55.3211 83.7017C54.8302 83.4097 54.4515 82.995 54.1849 82.4575C53.9183 81.9201 53.785 81.2832 53.785 80.5469V80.5405C53.785 79.8127 53.9162 79.1779 54.1786 78.6362C54.4452 78.0946 54.8218 77.6756 55.3084 77.3794C55.7951 77.0789 56.3664 76.9287 57.0223 76.9287C57.6825 76.9287 58.2495 77.0747 58.7235 77.3667C59.2017 77.6545 59.5698 78.0586 59.828 78.5791C60.0861 79.0996 60.2152 79.709 60.2152 80.4072V80.9277H54.5785V79.8677H59.4408L58.6917 80.8579V80.2295C58.6917 79.7682 58.6219 79.3853 58.4823 79.0806C58.3426 78.7759 58.148 78.5474 57.8983 78.395C57.6528 78.2427 57.3672 78.1665 57.0413 78.1665C56.7155 78.1665 56.4256 78.2469 56.1717 78.4077C55.922 78.5643 55.7232 78.797 55.575 79.106C55.4312 79.4106 55.3592 79.7852 55.3592 80.2295V80.8643C55.3592 81.2917 55.4312 81.6577 55.575 81.9624C55.7189 82.2629 55.922 82.4956 56.1844 82.6606C56.451 82.8215 56.7663 82.9019 57.1302 82.9019C57.4137 82.9019 57.6571 82.8617 57.8602 82.7812C58.0676 82.6966 58.2347 82.5972 58.3617 82.4829C58.4886 82.3644 58.5775 82.2523 58.6283 82.1465L58.6473 82.1021H60.1454L60.1327 82.1592C60.0776 82.3835 59.9761 82.612 59.828 82.8447C59.6841 83.0732 59.4873 83.2869 59.2376 83.4858C58.9922 83.6805 58.6917 83.8392 58.3363 83.9619C57.9808 84.0804 57.5682 84.1396 57.0985 84.1396ZM61.8427 86.3042V77.062H63.4233V78.1475H63.5312C63.6581 77.8978 63.8232 77.6841 64.0263 77.5063C64.2336 77.3286 64.4727 77.1911 64.7436 77.0938C65.0144 76.9964 65.3127 76.9478 65.6386 76.9478C66.2183 76.9478 66.7198 77.0938 67.143 77.3857C67.5704 77.6777 67.9005 78.0924 68.1332 78.6299C68.3702 79.1631 68.4887 79.7957 68.4887 80.5278V80.5405C68.4887 81.2769 68.3723 81.9116 68.1396 82.4448C67.9068 82.978 67.5767 83.3906 67.1493 83.6826C66.7262 83.9704 66.2226 84.1143 65.6386 84.1143C65.3212 84.1143 65.025 84.0656 64.7499 83.9683C64.4749 83.8667 64.2336 83.7249 64.0263 83.543C63.8189 83.361 63.6539 83.1452 63.5312 82.8955H63.4233V86.3042H61.8427ZM65.1435 82.7812C65.5032 82.7812 65.8121 82.6924 66.0702 82.5146C66.3284 82.3327 66.5273 82.0745 66.6669 81.7402C66.8066 81.4017 66.8764 81.0018 66.8764 80.5405V80.5278C66.8764 80.0581 66.8066 79.6561 66.6669 79.3218C66.5273 78.9875 66.3284 78.7314 66.0702 78.5537C65.8121 78.3717 65.5032 78.2808 65.1435 78.2808C64.7838 78.2808 64.4727 78.3717 64.2104 78.5537C63.9522 78.7314 63.7512 78.9875 63.6073 79.3218C63.4677 79.6561 63.3979 80.056 63.3979 80.5215V80.5342C63.3979 80.9997 63.4677 81.4017 63.6073 81.7402C63.7512 82.0745 63.9543 82.3327 64.2167 82.5146C64.4791 82.6924 64.788 82.7812 65.1435 82.7812ZM73.0996 84.1396C72.4098 84.1396 71.8174 83.9937 71.3223 83.7017C70.8314 83.4097 70.4526 82.995 70.186 82.4575C69.9194 81.9201 69.7861 81.2832 69.7861 80.5469V80.5405C69.7861 79.8127 69.9173 79.1779 70.1797 78.6362C70.4463 78.0946 70.8229 77.6756 71.3096 77.3794C71.7962 77.0789 72.3675 76.9287 73.0234 76.9287C73.6836 76.9287 74.2507 77.0747 74.7246 77.3667C75.2028 77.6545 75.571 78.0586 75.8291 78.5791C76.0872 79.0996 76.2163 79.709 76.2163 80.4072V80.9277H70.5796V79.8677H75.4419L74.6929 80.8579V80.2295C74.6929 79.7682 74.623 79.3853 74.4834 79.0806C74.3438 78.7759 74.1491 78.5474 73.8994 78.395C73.654 78.2427 73.3683 78.1665 73.0425 78.1665C72.7166 78.1665 72.4268 78.2469 72.1729 78.4077C71.9232 78.5643 71.7243 78.797 71.5762 79.106C71.4323 79.4106 71.3604 79.7852 71.3604 80.2295V80.8643C71.3604 81.2917 71.4323 81.6577 71.5762 81.9624C71.7201 82.2629 71.9232 82.4956 72.1855 82.6606C72.4521 82.8215 72.7674 82.9019 73.1313 82.9019C73.4149 82.9019 73.6582 82.8617 73.8613 82.7812C74.0687 82.6966 74.2358 82.5972 74.3628 82.4829C74.4897 82.3644 74.5786 82.2523 74.6294 82.1465L74.6484 82.1021H76.1465L76.1338 82.1592C76.0788 82.3835 75.9772 82.612 75.8291 82.8447C75.6852 83.0732 75.4884 83.2869 75.2388 83.4858C74.9933 83.6805 74.6929 83.8392 74.3374 83.9619C73.9819 84.0804 73.5693 84.1396 73.0996 84.1396ZM77.8375 84V77.062H79.399V81.7085H80.2178L79.1387 82.3179L82.4522 77.062H84.0074V84H82.4522V79.3281H81.6334L82.6998 78.7124L79.399 84H77.8375ZM80.9288 76.1162C80.4633 76.1162 80.0549 76.0231 79.7037 75.8369C79.3567 75.6507 79.0859 75.3947 78.8912 75.0688C78.6965 74.743 78.5992 74.3706 78.5992 73.9517H79.8433C79.8476 74.2944 79.947 74.5885 80.1417 74.834C80.3363 75.0752 80.5987 75.1958 80.9288 75.1958C81.2673 75.1958 81.5318 75.0752 81.7222 74.834C81.9127 74.5885 82.01 74.2944 82.0142 73.9517H83.2584C83.2584 74.3706 83.161 74.743 82.9664 75.0688C82.7717 75.3947 82.4988 75.6507 82.1475 75.8369C81.8005 76.0231 81.3943 76.1162 80.9288 76.1162ZM91.2716 77.062V78.2871H89.1325V84H87.5519V78.2871H85.4191V77.062H91.2716ZM92.6833 84V77.062H94.2449V81.7085H95.0637L93.9846 82.3179L97.2981 77.062H98.8533V84H97.2981V79.3281H96.4792L97.5456 78.7124L94.2449 84H92.6833Z" fill="white"/>
</g>
<rect x="307" y="16" width="40" height="40" rx="20" fill="white" fill-opacity="0.15"/>
<mask id="mask0_2231_120931" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="316" y="29" width="22" height="15">
<path d="M316 34H338L327 44L316 34Z" fill="black"/>
<path opacity="0.4" d="M316 34L320 29H327L323 34H316Z" fill="black"/>
<path opacity="0.7" d="M331 34L327 29H334L338 34H331Z" fill="black"/>
<path opacity="0.1" d="M323 34L327 29L331 34H323Z" fill="black"/>
</mask>
<g mask="url(#mask0_2231_120931)">
<path d="M315 24H339V48H315V24Z" fill="#F6F7F8"/>
</g>
</g>
<rect x="12.5" y="0.5" width="350" height="113" rx="31.5" stroke="white" stroke-opacity="0.1"/>
<circle cx="331" cy="124" r="6" fill="#212122"/>
<defs>
<clipPath id="clip0_2231_120931">
<rect x="12" width="351" height="114" rx="32" fill="white"/>
</clipPath>
<clipPath id="clip1_2231_120931">
<rect width="259" height="82" fill="white" transform="translate(32 16)"/>
</clipPath>
</defs>
</svg>
"""#

let toastForegroundSVG = #"""
<svg width="351" height="114" viewBox="12 0 351 114" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_2231_120931)">
<g clip-path="url(#clip1_2231_120931)">
<path d="M36.0063 30V21.0205H32.7544V19.4312H41.1553V21.0205H37.896V30H36.0063ZM45.4123 30.1611C43.032 30.1611 41.5891 28.5645 41.5891 26.0156V26.0083C41.5891 23.4888 43.0466 21.8408 45.3245 21.8408C47.6023 21.8408 49.0085 23.4375 49.0085 25.8545V26.4551H43.4128C43.4348 27.8906 44.2112 28.7256 45.449 28.7256C46.4377 28.7256 47.0017 28.2275 47.1775 27.8613L47.1995 27.8101H48.9353L48.9133 27.876C48.657 28.9087 47.5876 30.1611 45.4123 30.1611ZM45.3464 23.269C44.3284 23.269 43.5666 23.9575 43.4275 25.2319H47.2288C47.1042 23.9209 46.3645 23.269 45.3464 23.269ZM52.9653 26.543H52.5552V30H50.7314V21.9946H52.5552V25.21H52.9507L55.5874 21.9946H57.6821L54.4521 25.7007L57.8359 30H55.6313L52.9653 26.543ZM62.2981 30.1611C59.8884 30.1611 58.4675 28.6011 58.4675 25.9863V25.9717C58.4675 23.3862 59.8811 21.8408 62.2907 21.8408C64.3488 21.8408 65.5793 22.9834 65.7844 24.6387V24.668H64.0632L64.0559 24.646C63.8874 23.8696 63.2942 23.313 62.2981 23.313C61.0529 23.313 60.3205 24.2944 60.3205 25.9717V25.9863C60.3205 27.6855 61.0603 28.6816 62.2981 28.6816C63.2429 28.6816 63.8215 28.2495 64.0486 27.4072L64.0632 27.3779L65.7844 27.3706L65.7697 27.4292C65.5061 29.0698 64.3269 30.1611 62.2981 30.1611ZM73.2129 21.9946V23.4082H70.7446V30H68.9209V23.4082H66.4599V21.9946H73.2129ZM80.687 26.543H80.2768V30H78.4531V21.9946H80.2768V25.21H80.6723L83.309 21.9946H85.4038L82.1738 25.7007L85.5576 30H83.353L80.687 26.543ZM90.0417 30.1611C87.6393 30.1611 86.1891 28.5938 86.1891 26.001V25.9863C86.1891 23.4155 87.6613 21.8408 90.0417 21.8408C92.4294 21.8408 93.8942 23.4082 93.8942 25.9863V26.001C93.8942 28.5938 92.4367 30.1611 90.0417 30.1611ZM90.0417 28.6816C91.3088 28.6816 92.0265 27.6929 92.0265 26.0083V25.9937C92.0265 24.3091 91.3014 23.313 90.0417 23.313C88.7746 23.313 88.0495 24.3091 88.0495 25.9937V26.0083C88.0495 27.6929 88.7746 28.6816 90.0417 28.6816ZM97.3676 30H95.6244V21.9946H97.9462L100.312 27.5684H100.444L102.817 21.9946H105.095V30H103.351V24.5361H103.212L101.008 29.6411H99.704L97.5068 24.5361H97.3676V30ZM108.964 30H107.22V21.9946H109.542L111.908 27.5684H112.04L114.413 21.9946H116.691V30H114.947V24.5361H114.808L112.604 29.6411H111.3L109.103 24.5361H108.964V30ZM119.681 32.8125C119.461 32.8125 119.204 32.8052 118.985 32.7832V31.3843C119.131 31.3989 119.336 31.4062 119.527 31.4062C120.274 31.4062 120.721 31.0986 120.918 30.3735L121.014 30.0073L118.15 21.9946H120.142L122.01 28.2495H122.149L124.009 21.9946H125.928L123.057 30.1685C122.369 32.1753 121.453 32.8125 119.681 32.8125ZM132.595 30V26.5796H129.218V30H127.395V21.9946H129.218V25.166H132.595V21.9946H134.419V30H132.595ZM136.544 30V21.9946H138.346V27.356H138.493L141.869 21.9946H143.671V30H141.869V24.6094H141.715L138.346 30H136.544ZM148.03 26.543H147.62V30H145.797V21.9946H147.62V25.21H148.016L150.652 21.9946H152.747L149.517 25.7007L152.901 30H150.696L148.03 26.543ZM156.213 30.1318C154.69 30.1318 153.584 29.1943 153.584 27.7368V27.7222C153.584 26.2939 154.675 25.459 156.623 25.3418L158.682 25.2173V24.5288C158.682 23.7305 158.161 23.291 157.18 23.291C156.345 23.291 155.803 23.5913 155.62 24.1187L155.613 24.1479H153.891L153.899 24.082C154.075 22.7344 155.364 21.8408 157.268 21.8408C159.326 21.8408 160.483 22.8369 160.483 24.5288V30H158.682V28.9014H158.557C158.118 29.6777 157.268 30.1318 156.213 30.1318ZM155.386 27.6489C155.386 28.3301 155.964 28.7329 156.77 28.7329C157.869 28.7329 158.682 28.0151 158.682 27.063V26.4185L156.88 26.5356C155.862 26.6016 155.386 26.9751 155.386 27.6343V27.6489ZM169.062 32.0874V30H162.572V21.9946H164.396V28.5938H167.699V21.9946H169.523V28.5938H170.754V32.0874H169.062ZM172.074 30V21.9946H173.875V27.356H174.022L177.398 21.9946H179.2V30H177.398V24.6094H177.244L173.875 30H172.074ZM181.326 30V21.9946H183.128V27.356H183.274L186.65 21.9946H188.452V30H186.65V24.6094H186.497L183.128 30H181.326ZM35.8232 50.6587C34.3584 48.8203 33.6846 46.5278 33.6846 43.7739C33.6846 41.0127 34.3584 38.7202 35.8232 36.8965H37.4639C36.3799 38.2661 35.5596 41.1812 35.5596 43.7739C35.5596 46.3813 36.3799 49.2744 37.4639 50.6587H35.8232ZM42.5852 48.1611C40.1829 48.1611 38.7327 46.5938 38.7327 44.001V43.9863C38.7327 41.4155 40.2048 39.8408 42.5852 39.8408C44.9729 39.8408 46.4377 41.4082 46.4377 43.9863V44.001C46.4377 46.5938 44.9802 48.1611 42.5852 48.1611ZM42.5852 46.6816C43.8523 46.6816 44.5701 45.6929 44.5701 44.0083V43.9937C44.5701 42.3091 43.845 41.313 42.5852 41.313C41.3181 41.313 40.593 42.3091 40.593 43.9937V44.0083C40.593 45.6929 41.3181 46.6816 42.5852 46.6816ZM53.5659 41.4082H49.9917V48H48.1679V39.9946H53.5659V41.4082ZM55.1716 50.6587V39.9946H56.9953V41.2471H57.1198C57.5593 40.3755 58.4309 39.8628 59.5515 39.8628C61.5583 39.8628 62.8401 41.4595 62.8401 43.9937V44.0083C62.8401 46.5571 61.5803 48.1318 59.5515 48.1318C58.4529 48.1318 57.5373 47.5898 57.1198 46.7256H56.9953V50.6587H55.1716ZM58.9802 46.5938C60.2253 46.5938 60.9797 45.6123 60.9797 44.0083V43.9937C60.9797 42.3823 60.2253 41.4009 58.9802 41.4009C57.7424 41.4009 56.9734 42.3823 56.9734 43.9863V44.001C56.9734 45.605 57.7424 46.5938 58.9802 46.5938ZM66.7675 48.1318C65.2441 48.1318 64.1381 47.1943 64.1381 45.7368V45.7222C64.1381 44.2939 65.2295 43.459 67.1777 43.3418L69.2358 43.2173V42.5288C69.2358 41.7305 68.7158 41.291 67.7343 41.291C66.8994 41.291 66.3574 41.5913 66.1743 42.1187L66.167 42.1479H64.4458L64.4531 42.082C64.6289 40.7344 65.9179 39.8408 67.8222 39.8408C69.8803 39.8408 71.0376 40.8369 71.0376 42.5288V48H69.2358V46.9014H69.1113C68.6718 47.6777 67.8222 48.1318 66.7675 48.1318ZM65.9399 45.6489C65.9399 46.3301 66.5185 46.7329 67.3242 46.7329C68.4228 46.7329 69.2358 46.0151 69.2358 45.063V44.4185L67.434 44.5356C66.416 44.6016 65.9399 44.9751 65.9399 45.6343V45.6489ZM78.3269 48V44.5796H74.9504V48H73.1267V39.9946H74.9504V43.166H78.3269V39.9946H80.1506V48H78.3269ZM82.2763 48V39.9946H84.0781V45.356H84.2246L87.601 39.9946H89.4028V48H87.601V42.6094H87.4472L84.0781 48H82.2763ZM98.1716 48H96.3478V44.7993H96.216C95.7912 45.1216 95.1686 45.3193 94.3483 45.3193C92.444 45.3193 91.3674 44.1694 91.3674 42.3896V39.9946H93.1911V42.2358C93.1911 43.2246 93.6965 43.7812 94.6926 43.7812C95.4909 43.7812 96.0549 43.5688 96.3478 43.2686V39.9946H98.1716V48ZM103.732 48.1611C101.352 48.1611 99.9091 46.5645 99.9091 44.0156V44.0083C99.9091 41.4888 101.367 39.8408 103.644 39.8408C105.922 39.8408 107.329 41.4375 107.329 43.8545V44.4551H101.733C101.755 45.8906 102.531 46.7256 103.769 46.7256C104.758 46.7256 105.322 46.2275 105.497 45.8613L105.519 45.8101H107.255L107.233 45.876C106.977 46.9087 105.908 48.1611 103.732 48.1611ZM103.666 41.269C102.648 41.269 101.887 41.9575 101.747 43.2319H105.549C105.424 41.9209 104.684 41.269 103.666 41.269ZM114.252 48V44.5796H110.875V48H109.051V39.9946H110.875V43.166H114.252V39.9946H116.075V48H114.252ZM118.201 48V39.9946H120.003V45.356H120.149L123.526 39.9946H125.328V48H123.526V42.6094H123.372L120.003 48H118.201ZM130.888 48.1611C128.508 48.1611 127.065 46.5645 127.065 44.0156V44.0083C127.065 41.4888 128.523 39.8408 130.8 39.8408C133.078 39.8408 134.485 41.4375 134.485 43.8545V44.4551H128.889C128.911 45.8906 129.687 46.7256 130.925 46.7256C131.914 46.7256 132.478 46.2275 132.653 45.8613L132.675 45.8101H134.411L134.389 45.876C134.133 46.9087 133.064 48.1611 130.888 48.1611ZM130.822 41.269C129.804 41.269 129.043 41.9575 128.903 43.2319H132.705C132.58 41.9209 131.84 41.269 130.822 41.269ZM139.966 48V39.9946H143.753C145.364 39.9946 146.309 40.8076 146.309 42.0381V42.0527C146.309 42.8877 145.731 43.6274 144.918 43.7666V43.8911C145.972 44.0083 146.668 44.7407 146.668 45.7075V45.7222C146.668 47.0845 145.584 48 143.804 48H139.966ZM141.768 43.3198H143.174C144.075 43.3198 144.515 42.9536 144.515 42.2871V42.2725C144.515 41.6646 144.127 41.2544 143.321 41.2544H141.768V43.3198ZM141.768 46.7402H143.475C144.354 46.7402 144.8 46.3301 144.8 45.6416V45.627C144.8 44.9019 144.302 44.543 143.306 44.543H141.768V46.7402ZM152.143 48V46.7256L155.614 43.1807C157.05 41.7305 157.453 41.1958 157.453 40.3828V40.3608C157.453 39.3867 156.786 38.6836 155.688 38.6836C154.567 38.6836 153.813 39.4233 153.813 40.5146L153.805 40.5439L152.047 40.5366L152.04 40.5146C152.04 38.5444 153.578 37.1675 155.783 37.1675C157.841 37.1675 159.32 38.4199 159.32 40.1997V40.2217C159.32 41.4229 158.742 42.375 156.816 44.228L154.699 46.2788V46.4326H159.482V48H152.143ZM168.611 48.1611C166.201 48.1611 164.78 46.6011 164.78 43.9863V43.9717C164.78 41.3862 166.194 39.8408 168.604 39.8408C170.662 39.8408 171.892 40.9834 172.097 42.6387V42.668H170.376L170.369 42.646C170.2 41.8696 169.607 41.313 168.611 41.313C167.366 41.313 166.633 42.2944 166.633 43.9717V43.9863C166.633 45.6855 167.373 46.6816 168.611 46.6816C169.556 46.6816 170.134 46.2495 170.361 45.4072L170.376 45.3779L172.097 45.3706L172.083 45.4292C171.819 47.0698 170.64 48.1611 168.611 48.1611ZM179.526 39.9946V41.4082H177.057V48H175.234V41.4082H172.773V39.9946H179.526ZM181.014 50.6587V39.9946H182.838V41.2471H182.962C183.402 40.3755 184.273 39.8628 185.394 39.8628C187.401 39.8628 188.683 41.4595 188.683 43.9937V44.0083C188.683 46.5571 187.423 48.1318 185.394 48.1318C184.295 48.1318 183.38 47.5898 182.962 46.7256H182.838V50.6587H181.014ZM184.823 46.5938C186.068 46.5938 186.822 45.6123 186.822 44.0083V43.9937C186.822 42.3823 186.068 41.4009 184.823 41.4009C183.585 41.4009 182.816 42.3823 182.816 43.9863V44.001C182.816 45.605 183.585 46.5938 184.823 46.5938ZM193.885 48.1611C191.482 48.1611 190.032 46.5938 190.032 44.001V43.9863C190.032 41.4155 191.504 39.8408 193.885 39.8408C196.272 39.8408 197.737 41.4082 197.737 43.9863V44.001C197.737 46.5938 196.28 48.1611 193.885 48.1611ZM193.885 46.6816C195.152 46.6816 195.869 45.6929 195.869 44.0083V43.9937C195.869 42.3091 195.144 41.313 193.885 41.313C192.617 41.313 191.892 42.3091 191.892 43.9937V44.0083C191.892 45.6929 192.617 46.6816 193.885 46.6816ZM201.701 44.543H201.291V48H199.467V39.9946H201.291V43.21H201.687L204.323 39.9946H206.418L203.188 43.7007L206.572 48H204.367L201.701 44.543ZM207.958 48V39.9946H209.76V45.356H209.906L213.283 39.9946H215.084V48H213.283V42.6094H213.129L209.76 48H207.958ZM218.382 50.6587H216.741C217.825 49.2744 218.646 46.3813 218.646 43.7739C218.646 41.1812 217.825 38.2661 216.741 36.8965H218.382C219.847 38.7202 220.521 41.0127 220.521 43.7739C220.521 46.5278 219.847 48.8203 218.382 50.6587Z" fill="white"/>
<rect x="32" y="64" width="79" height="30" rx="15" fill="white" fill-opacity="0.15"/>
<path d="M51.9734 84H50.3421V76.2178H45.9558V84H44.3181V74.8403H51.9734V84ZM57.0985 84.1396C56.4087 84.1396 55.8162 83.9937 55.3211 83.7017C54.8302 83.4097 54.4515 82.995 54.1849 82.4575C53.9183 81.9201 53.785 81.2832 53.785 80.5469V80.5405C53.785 79.8127 53.9162 79.1779 54.1786 78.6362C54.4452 78.0946 54.8218 77.6756 55.3084 77.3794C55.7951 77.0789 56.3664 76.9287 57.0223 76.9287C57.6825 76.9287 58.2495 77.0747 58.7235 77.3667C59.2017 77.6545 59.5698 78.0586 59.828 78.5791C60.0861 79.0996 60.2152 79.709 60.2152 80.4072V80.9277H54.5785V79.8677H59.4408L58.6917 80.8579V80.2295C58.6917 79.7682 58.6219 79.3853 58.4823 79.0806C58.3426 78.7759 58.148 78.5474 57.8983 78.395C57.6528 78.2427 57.3672 78.1665 57.0413 78.1665C56.7155 78.1665 56.4256 78.2469 56.1717 78.4077C55.922 78.5643 55.7232 78.797 55.575 79.106C55.4312 79.4106 55.3592 79.7852 55.3592 80.2295V80.8643C55.3592 81.2917 55.4312 81.6577 55.575 81.9624C55.7189 82.2629 55.922 82.4956 56.1844 82.6606C56.451 82.8215 56.7663 82.9019 57.1302 82.9019C57.4137 82.9019 57.6571 82.8617 57.8602 82.7812C58.0676 82.6966 58.2347 82.5972 58.3617 82.4829C58.4886 82.3644 58.5775 82.2523 58.6283 82.1465L58.6473 82.1021H60.1454L60.1327 82.1592C60.0776 82.3835 59.9761 82.612 59.828 82.8447C59.6841 83.0732 59.4873 83.2869 59.2376 83.4858C58.9922 83.6805 58.6917 83.8392 58.3363 83.9619C57.9808 84.0804 57.5682 84.1396 57.0985 84.1396ZM61.8427 86.3042V77.062H63.4233V78.1475H63.5312C63.6581 77.8978 63.8232 77.6841 64.0263 77.5063C64.2336 77.3286 64.4727 77.1911 64.7436 77.0938C65.0144 76.9964 65.3127 76.9478 65.6386 76.9478C66.2183 76.9478 66.7198 77.0938 67.143 77.3857C67.5704 77.6777 67.9005 78.0924 68.1332 78.6299C68.3702 79.1631 68.4887 79.7957 68.4887 80.5278V80.5405C68.4887 81.2769 68.3723 81.9116 68.1396 82.4448C67.9068 82.978 67.5767 83.3906 67.1493 83.6826C66.7262 83.9704 66.2226 84.1143 65.6386 84.1143C65.3212 84.1143 65.025 84.0656 64.7499 83.9683C64.4749 83.8667 64.2336 83.7249 64.0263 83.543C63.8189 83.361 63.6539 83.1452 63.5312 82.8955H63.4233V86.3042H61.8427ZM65.1435 82.7812C65.5032 82.7812 65.8121 82.6924 66.0702 82.5146C66.3284 82.3327 66.5273 82.0745 66.6669 81.7402C66.8066 81.4017 66.8764 81.0018 66.8764 80.5405V80.5278C66.8764 80.0581 66.8066 79.6561 66.6669 79.3218C66.5273 78.9875 66.3284 78.7314 66.0702 78.5537C65.8121 78.3717 65.5032 78.2808 65.1435 78.2808C64.7838 78.2808 64.4727 78.3717 64.2104 78.5537C63.9522 78.7314 63.7512 78.9875 63.6073 79.3218C63.4677 79.6561 63.3979 80.056 63.3979 80.5215V80.5342C63.3979 80.9997 63.4677 81.4017 63.6073 81.7402C63.7512 82.0745 63.9543 82.3327 64.2167 82.5146C64.4791 82.6924 64.788 82.7812 65.1435 82.7812ZM73.0996 84.1396C72.4098 84.1396 71.8174 83.9937 71.3223 83.7017C70.8314 83.4097 70.4526 82.995 70.186 82.4575C69.9194 81.9201 69.7861 81.2832 69.7861 80.5469V80.5405C69.7861 79.8127 69.9173 79.1779 70.1797 78.6362C70.4463 78.0946 70.8229 77.6756 71.3096 77.3794C71.7962 77.0789 72.3675 76.9287 73.0234 76.9287C73.6836 76.9287 74.2507 77.0747 74.7246 77.3667C75.2028 77.6545 75.571 78.0586 75.8291 78.5791C76.0872 79.0996 76.2163 79.709 76.2163 80.4072V80.9277H70.5796V79.8677H75.4419L74.6929 80.8579V80.2295C74.6929 79.7682 74.623 79.3853 74.4834 79.0806C74.3438 78.7759 74.1491 78.5474 73.8994 78.395C73.654 78.2427 73.3683 78.1665 73.0425 78.1665C72.7166 78.1665 72.4268 78.2469 72.1729 78.4077C71.9232 78.5643 71.7243 78.797 71.5762 79.106C71.4323 79.4106 71.3604 79.7852 71.3604 80.2295V80.8643C71.3604 81.2917 71.4323 81.6577 71.5762 81.9624C71.7201 82.2629 71.9232 82.4956 72.1855 82.6606C72.4521 82.8215 72.7674 82.9019 73.1313 82.9019C73.4149 82.9019 73.6582 82.8617 73.8613 82.7812C74.0687 82.6966 74.2358 82.5972 74.3628 82.4829C74.4897 82.3644 74.5786 82.2523 74.6294 82.1465L74.6484 82.1021H76.1465L76.1338 82.1592C76.0788 82.3835 75.9772 82.612 75.8291 82.8447C75.6852 83.0732 75.4884 83.2869 75.2388 83.4858C74.9933 83.6805 74.6929 83.8392 74.3374 83.9619C73.9819 84.0804 73.5693 84.1396 73.0996 84.1396ZM77.8375 84V77.062H79.399V81.7085H80.2178L79.1387 82.3179L82.4522 77.062H84.0074V84H82.4522V79.3281H81.6334L82.6998 78.7124L79.399 84H77.8375ZM80.9288 76.1162C80.4633 76.1162 80.0549 76.0231 79.7037 75.8369C79.3567 75.6507 79.0859 75.3947 78.8912 75.0688C78.6965 74.743 78.5992 74.3706 78.5992 73.9517H79.8433C79.8476 74.2944 79.947 74.5885 80.1417 74.834C80.3363 75.0752 80.5987 75.1958 80.9288 75.1958C81.2673 75.1958 81.5318 75.0752 81.7222 74.834C81.9127 74.5885 82.01 74.2944 82.0142 73.9517H83.2584C83.2584 74.3706 83.161 74.743 82.9664 75.0688C82.7717 75.3947 82.4988 75.6507 82.1475 75.8369C81.8005 76.0231 81.3943 76.1162 80.9288 76.1162ZM91.2716 77.062V78.2871H89.1325V84H87.5519V78.2871H85.4191V77.062H91.2716ZM92.6833 84V77.062H94.2449V81.7085H95.0637L93.9846 82.3179L97.2981 77.062H98.8533V84H97.2981V79.3281H96.4792L97.5456 78.7124L94.2449 84H92.6833Z" fill="white"/>
</g>
<rect x="307" y="16" width="40" height="40" rx="20" fill="white" fill-opacity="0.15"/>
<mask id="mask0_2231_120931" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="316" y="29" width="22" height="15">
<path d="M316 34H338L327 44L316 34Z" fill="black"/>
<path opacity="0.4" d="M316 34L320 29H327L323 34H316Z" fill="black"/>
<path opacity="0.7" d="M331 34L327 29H334L338 34H331Z" fill="black"/>
<path opacity="0.1" d="M323 34L327 29L331 34H323Z" fill="black"/>
</mask>
<g mask="url(#mask0_2231_120931)">
<path d="M315 24H339V48H315V24Z" fill="#F6F7F8"/>
</g>
</g>
<defs>
<clipPath id="clip0_2231_120931">
<rect x="12" width="351" height="114" rx="32" fill="white"/>
</clipPath>
<clipPath id="clip1_2231_120931">
<rect width="259" height="82" fill="white" transform="translate(32 16)"/>
</clipPath>
</defs>
</svg>
"""#

private let placeholderMultipleSVG = loadHomeSVG(named: "placeholder-multiple")

private let totalSVG = loadHomeSVG(named: "total")

private let containerSVG = loadHomeSVG(named: "container")

private let container1SVG = loadHomeSVG(named: "container-1")

private let container2SVG = loadHomeSVG(named: "container-2")

private let badgeSVG = loadHomeSVG(named: "tui-badge")

private let badge1SVG = loadHomeSVG(named: "tui-badge-1")

private let badge2SVG = loadHomeSVG(named: "tui-badge-2")

private let badge3SVG = loadHomeSVG(named: "tui-badge-3")

private let allActionsBackgroundImage = loadHomeImage(named: "background")

private let operationsSVG = loadHomeSVG(named: "operations")

private let accountsSVG = loadHomeSVG(named: "accounts")

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            demoHomeBridge: NotificationDemoHomeBridge(),
            activeTab: .home,
            onOpenNotificationCenter: {}
        )
    }
}
