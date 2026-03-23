import SwiftUI
import UIKit

struct NotificationCenterView: View {
    let onBack: () -> Void

    @State private var isSummaryStackExpanded = false
    @State private var anchorTarget: NotificationCenterAnchorTarget = .useful
    @State private var isAnchorVisible = true
    @State private var usefulSectionContentOffset: CGFloat?
    @State private var lastObservedScrollOffset: CGFloat?
    @State private var anchorVisibilityTask: Task<Void, Never>?

    private let importantSectionID = "notification-center-important"
    private let usefulSectionID = "notification-center-useful"
    private let anchorRevealDelay: UInt64 = 220_000_000
    private let importantCards: [NotificationCenterCardModel] = [
        .init(
            title: "Штраф за пропуск платежа",
            message: "Списано 3500 рублей. Погасите просроченную задолженность, чтобы штрафы перестали начисляться",
            iconSVG: notificationCenterWalletSVG,
            showsIndicator: true
        ),
        .init(
            title: "Т-Бизнес",
            message: "По запросу АО \"ЭТС\" на вашем счете заблокировали 4483.08 RUB",
            iconSVG: notificationCenterRubleSVG,
            showsIndicator: true
        ),
        .init(
            title: "Информация о встрече",
            message: "Сегодня с 12:00 до 14:00 к вам приедет Евгений. Не забудьте паспорт",
            iconSVG: notificationCenterBoxSVG,
            showsIndicator: false
        ),
        .init(
            title: "Пройдите опрос",
            message: "Оцените работу поддержки — это займет меньше минуты",
            iconSVG: notificationCenterQuestionSVG,
            showsIndicator: true,
            action: .pill("Перейти")
        ),
        .init(
            title: "Рекомендации для вас",
            message: "Рассказали, как избежать проверки в будущем.",
            iconSVG: notificationCenterInfoSVG,
            showsIndicator: true,
            action: .pill("Перейти")
        )
    ]

    private let usefulCards: [NotificationCenterCardModel] = [
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        ),
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        ),
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        ),
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        ),
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        )
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.black
                    .ignoresSafeArea()

                ScrollViewReader { scrollProxy in
                    ZStack(alignment: .bottom) {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                topBar
                                    .padding(.top, proxy.safeAreaInsets.top + 10)
                                    .padding(.horizontal, 16)

                                summaryStack
                                    .padding(.top, 14)

                                VStack(spacing: 0) {
                                    sectionTitle("Важное")
                                        .padding(.top, 36)
                                        .padding(.bottom, 24)
                                        .id(importantSectionID)

                                    VStack(spacing: 16) {
                                        ForEach(importantCards) { card in
                                            NotificationCenterCard(model: card)
                                        }
                                    }

                                    sectionTitle("Полезное")
                                        .padding(.top, 36)
                                        .padding(.bottom, 24)
                                        .id(usefulSectionID)
                                        .background {
                                            GeometryReader { geometry in
                                                Color.clear.preference(
                                                    key: NotificationCenterSectionContentOffsetPreferenceKey.self,
                                                    value: geometry.frame(
                                                        in: .named(NotificationCenterContentSpace.name)
                                                    ).minY
                                                )
                                            }
                                        }

                                    VStack(spacing: 16) {
                                        ForEach(usefulCards) { card in
                                            NotificationCenterCard(model: card)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, max(proxy.safeAreaInsets.bottom, 20) + 88)
                                .coordinateSpace(name: NotificationCenterContentSpace.name)
                            }
                        }
                        .background {
                            NotificationCenterScrollOffsetObserver { offset in
                                let normalizedOffset = max(offset, 0)
                                observeScrollMotion(for: normalizedOffset)
                                updateAnchorTarget(
                                    scrollOffset: normalizedOffset,
                                    viewportHeight: proxy.size.height
                                )
                            }
                        }
                        .onPreferenceChange(NotificationCenterSectionContentOffsetPreferenceKey.self) { value in
                            usefulSectionContentOffset = value
                            updateAnchorTarget(
                                scrollOffset: max(lastObservedScrollOffset ?? .zero, 0),
                                viewportHeight: proxy.size.height
                            )
                        }
                        .compositingGroup()
                        .mask {
                            NotificationCenterScrollViewportMask(
                                safeAreaBottom: proxy.safeAreaInsets.bottom
                            )
                        }

                        if isAnchorVisible {
                            NotificationCenterBottomAnchor(
                                direction: anchorTarget == .useful ? .down : .up,
                                title: anchorTarget == .useful ? "Полезное" : "К важному",
                                showsStatusDot: false,
                                action: {
                                    let nextTarget: NotificationCenterAnchorTarget =
                                        anchorTarget == .useful ? .important : .useful
                                    anchorTarget = nextTarget

                                    withAnimation(.spring(response: 0.38, dampingFraction: 0.88)) {
                                        scrollProxy.scrollTo(
                                            nextTarget == .important ? usefulSectionID : importantSectionID,
                                            anchor: .top
                                        )
                                    }
                                }
                            )
                            .padding(.bottom, max(proxy.safeAreaInsets.bottom, 20) + 6)
                            .transition(.opacity.combined(with: .scale(scale: 0.96)))
                        }
                    }
                }
            }
        }
        .onDisappear {
            anchorVisibilityTask?.cancel()
        }
    }

    private var topBar: some View {
        HStack {
            Button(action: onBack) {
                NotificationCenterBackButtonVisual()
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)
        }
    }

    private var summaryStack: some View {
        NotificationCenterSummaryStack(isExpanded: $isSummaryStackExpanded)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private func observeScrollMotion(for offset: CGFloat) {
        if let lastObservedScrollOffset {
            guard abs(offset - lastObservedScrollOffset) > 0.5 else { return }
        } else {
            lastObservedScrollOffset = offset
            return
        }

        lastObservedScrollOffset = offset

        withAnimation(.easeOut(duration: 0.18)) {
            isAnchorVisible = false
        }

        anchorVisibilityTask?.cancel()
        anchorVisibilityTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: anchorRevealDelay)
            guard !Task.isCancelled else { return }

            withAnimation(.easeOut(duration: 0.22)) {
                isAnchorVisible = true
            }
        }
    }

    private func updateAnchorTarget(scrollOffset: CGFloat, viewportHeight: CGFloat) {
        guard let usefulSectionContentOffset else { return }

        let switchThreshold = max(usefulSectionContentOffset - viewportHeight + 1, 0)
        anchorTarget = scrollOffset >= switchThreshold ? .important : .useful
    }
}

private enum NotificationCenterAnchorTarget {
    case important
    case useful
}

private struct NotificationCenterBackButtonVisual: View {
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.08))
            .overlay {
                Circle()
                    .stroke(Color.white.opacity(0.24), lineWidth: 1)
            }
            .overlay {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .offset(x: -1)
            }
        .frame(width: 44, height: 44)
    }
}

private struct NotificationCenterSummaryStack: View {
    @Binding var isExpanded: Bool

    @State private var animationProgress: CGFloat = 0

    private let animation = Animation.spring(response: 0.46, dampingFraction: 0.88)

    var body: some View {
        let progress = animationProgress

        ZStack(alignment: .top) {
            collapsedLayer(width: 319, height: 156, opacity: 0.48 * (1 - progress), yOffset: 22 + (14 * progress))
            collapsedLayer(width: 331, height: 159, opacity: 0.72 * (1 - progress), yOffset: 11 + (10 * progress))

            InlineSVGWebView(svg: notificationCenterStackCollapsedSVG)
                .frame(width: 375, height: 162)
                .allowsHitTesting(false)
                .opacity(Double(1 - (CGFloat(0.94) * progress)))
                .scaleEffect(1 - (CGFloat(0.015) * progress), anchor: .top)
                .offset(y: 16 * progress)

            if isExpanded || progress > 0.001 {
                InlineSVGWebView(svg: notificationCenterStackExpandedSVG)
                    .frame(width: 375, height: 336)
                    .allowsHitTesting(false)
                    .opacity(Double(progress))
                    .scaleEffect(CGFloat(0.985) + (CGFloat(0.015) * progress), anchor: .top)
                    .offset(y: 10 * (1 - progress))
                    .mask(alignment: .top) {
                        Rectangle()
                            .frame(height: 132 + (204 * progress))
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 188 + (148 * progress))
        .clipped()
        .overlay {
            if !isExpanded {
                Button {
                    withAnimation(animation) {
                        isExpanded = true
                    }
                } label: {
                    Color.clear
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .top) {
            if isExpanded {
                Button {
                    withAnimation(animation) {
                        isExpanded = false
                    }
                } label: {
                    Color.clear
                        .frame(width: 170, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .offset(x: 24, y: 22)
            }
        }
        .onAppear {
            animationProgress = isExpanded ? 1 : 0
        }
        .onChange(of: isExpanded) { _, newValue in
            withAnimation(animation) {
                animationProgress = newValue ? 1 : 0
            }
        }
    }

    private func collapsedLayer(width: CGFloat, height: CGFloat, opacity: CGFloat, yOffset: CGFloat) -> some View {
        InlineSVGWebView(svg: notificationCenterStackLayerSVG)
            .frame(width: width, height: height)
            .opacity(Double(opacity))
            .offset(y: yOffset)
            .allowsHitTesting(false)
    }
}

private struct NotificationCenterScrollOffsetObserver: UIViewRepresentable {
    let onChange: (CGFloat) -> Void

    func makeUIView(context: Context) -> NotificationCenterScrollOffsetObserverView {
        let view = NotificationCenterScrollOffsetObserverView()
        view.onChange = onChange
        return view
    }

    func updateUIView(_ uiView: NotificationCenterScrollOffsetObserverView, context: Context) {
        uiView.onChange = onChange
        uiView.attachIfNeeded()
    }
}

private final class NotificationCenterScrollOffsetObserverView: UIView {
    var onChange: ((CGFloat) -> Void)?

    private var observation: NSKeyValueObservation?
    private weak var observedScrollView: UIScrollView?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        attachIfNeeded()
    }

    func attachIfNeeded() {
        guard observedScrollView == nil else { return }

        var candidateView = superview
        while let view = candidateView, !(view is UIScrollView) {
            candidateView = view.superview
        }

        guard let scrollView = candidateView as? UIScrollView else { return }

        observedScrollView = scrollView
        observation = scrollView.observe(\.contentOffset, options: [.initial, .new]) { [weak self] scrollView, _ in
            DispatchQueue.main.async {
                self?.onChange?(scrollView.contentOffset.y)
            }
        }
    }
}

private struct NotificationCenterCard: View {
    let model: NotificationCenterCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        if model.showsIndicator {
                            Circle()
                                .fill(Color(red: 1, green: 0.25, blue: 0.22))
                                .frame(width: 7, height: 7)
                                .padding(.top, 7)
                        }

                        Text(model.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(model.message)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(red: 0.57, green: 0.60, blue: 0.64))
                        .lineSpacing(1.5)
                        .fixedSize(horizontal: false, vertical: true)

                    if let action = model.action {
                        NotificationCenterCardActionView(action: action)
                            .padding(.top, 4)
                    }
                }

                Spacer(minLength: 10)

                InlineSVGWebView(svg: model.iconSVG)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.leading, 14)
        .padding(.top, 18)
        .padding(.trailing, 16)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
        )
    }
}

private struct NotificationCenterCardActionView: View {
    let action: NotificationCenterCardModel.Action

    var body: some View {
        switch action {
        case .pill(let title):
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .frame(height: 40)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.12))
                )
        case .text(let title):
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(red: 0.57, green: 0.60, blue: 0.64))
        }
    }
}

private struct NotificationCenterBottomAnchor: View {
    enum Direction {
        case up
        case down
    }

    let direction: Direction
    let title: String
    let showsStatusDot: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                InlineSVGWebView(svg: notificationCenterArrowSVG)
                    .frame(width: 24, height: 24)
                    .rotationEffect(.degrees(direction == .down ? 180 : 0))

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                if showsStatusDot {
                    Circle()
                        .fill(Color(red: 0.27, green: 0.58, blue: 1))
                        .frame(width: 7, height: 7)
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 50)
            .background(
                Capsule(style: .continuous)
                    .fill(Color(red: 0.16, green: 0.16, blue: 0.18).opacity(0.96))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct NotificationCenterScrollViewportMask: View {
    let safeAreaBottom: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: max(geometry.size.height - (126 + safeAreaBottom), 0))

                LinearGradient(
                    stops: [
                        .init(color: .white, location: 0),
                        .init(color: .white, location: 0.36),
                        .init(color: Color.white.opacity(0.74), location: 0.68),
                        .init(color: Color.white.opacity(0.18), location: 0.90),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 126 + safeAreaBottom)
            }
        }
        .allowsHitTesting(false)
    }
}

private struct NotificationCenterCardModel: Identifiable {
    enum Action {
        case pill(String)
        case text(String)
    }

    let id = UUID()
    let title: String
    let message: String
    let iconSVG: String
    let showsIndicator: Bool
    var action: Action? = nil
}

private enum NotificationCenterContentSpace {
    static let name = "notification-center-content"
}

private struct NotificationCenterSectionContentOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private let notificationCenterProgressCircleSVG = loadNotificationCenterSVG(
    named: "notification-center-progress-circle"
)
private let notificationCenterWalletSVG = loadNotificationCenterSVG(named: "notification-center-wallet")
private let notificationCenterRubleSVG = loadNotificationCenterSVG(named: "notification-center-ruble")
private let notificationCenterBoxSVG = loadNotificationCenterSVG(named: "notification-center-box")
private let notificationCenterInfoSVG = loadNotificationCenterSVG(named: "notification-center-info")
private let notificationCenterQuestionSVG = loadNotificationCenterSVG(named: "notification-center-question")
private let notificationCenterArrowSVG = loadNotificationCenterSVG(named: "notification-center-arrow")
private let notificationCenterMarketplaceSVG = loadNotificationCenterSVG(
    named: "notification-center-marketplace"
)
private let notificationCenterStackCollapsedSVG = loadNotificationCenterSVG(
    named: "notification-center-stack-collapsed"
)
private let notificationCenterStackLayerSVG = loadNotificationCenterSVG(
    named: "notification-center-stack-layer"
)
private let notificationCenterStackExpandedSVG = loadNotificationCenterSVG(
    named: "notification-center-stack-expanded"
)
