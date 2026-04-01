import SwiftUI
import UIKit

enum NotificationCenterLayoutMode: CaseIterable, Identifiable {
    case united
    case separated1
    case separated2

    var id: Self { self }

    var title: String {
        switch self {
        case .united:
            return "United"
        case .separated1:
            return "Separated 1"
        case .separated2:
            return "Separated 2"
        }
    }
}

struct NotificationCenterView: View {
    let layoutMode: NotificationCenterLayoutMode
    let onBack: () -> Void

    @State private var isSummaryStackExpanded = true
    @State private var anchorTarget: NotificationCenterAnchorTarget = .useful
    @State private var isAnchorVisible = true
    @State private var usefulSectionContentOffset: CGFloat?
    @State private var lastObservedScrollOffset: CGFloat?
    @State private var anchorVisibilityTask: Task<Void, Never>?
    @State private var separatedEventsProgress: CGFloat = 1

    private let importantSectionID = "notification-center-important"
    private let usefulSectionID = "notification-center-useful"
    private let anchorRevealDelay: UInt64 = 220_000_000
    private let eventsToggleAnimation = Animation.smooth(duration: 0.36, extraBounce: 0)
    private let summaryCards: [NotificationCenterSummaryCardModel] = [
        .init(
            title: "Pay to phone",
            message: "Не можем подключить",
            trailing: .svg(notificationCenterWalletSVG, CGSize(width: 40, height: 40))
        ),
        .init(
            title: "Торговый эквайринг",
            message: "Оформите доставку устройств",
            trailing: .svg(notificationCenterProgressCircleSVG, CGSize(width: 40, height: 40))
        ),
        .init(
            title: "Бизнес-карта: Ilya Sidnev",
            message: "Доставка сегодня, 11:00-11:30",
            trailing: .avatar(notificationCenterBusinessAvatarImage)
        )
    ]
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

    private var usefulCards: [NotificationCenterCardModel] {
        (0..<5).map { _ in makeUsefulMarketplaceCard() }
    }

    private var showsSeparatedEventsToggle: Bool {
        summaryCards.count > 1
    }

    private var usesLeadingSectionHeaders: Bool {
        layoutMode == .separated2
    }

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
                                    .padding(.top, max(62 - proxy.safeAreaInsets.top, 0))
                                    .padding(.horizontal, 16)

                                topContent

                                VStack(spacing: 0) {
                                    currentSectionTitle("Важное")
                                        .padding(.top, layoutMode == .united ? 36 : 40)
                                        .padding(.bottom, 24)
                                        .id(importantSectionID)

                                    VStack(spacing: 16) {
                                        ForEach(importantCards) { card in
                                            NotificationCenterCard(model: card)
                                        }
                                    }

                                    currentSectionTitle("Полезное")
                                        .padding(.top, layoutMode == .united ? 36 : 40)
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
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 28)
                    .contentShape(Rectangle())
                    .highPriorityGesture(backSwipeGesture)
            }
        }
        .onAppear {
            separatedEventsProgress = isSummaryStackExpanded ? 1 : 0
        }
        .onChange(of: isSummaryStackExpanded) { _, newValue in
            withAnimation(eventsToggleAnimation) {
                separatedEventsProgress = newValue ? 1 : 0
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

    @ViewBuilder
    private var topContent: some View {
        switch layoutMode {
        case .united:
            NotificationCenterSummaryStack(
                cards: summaryCards,
                isExpanded: $isSummaryStackExpanded
            )
            .padding(.top, 14)
        case .separated1:
            separatedFeaturedEventsSection
                .padding(.top, 28)
                .padding(.horizontal, 16)
        case .separated2:
            separatedCategorizedEventsSection
                .padding(.top, 28)
                .padding(.horizontal, 16)
        }
    }

    private var separatedFeaturedEventsSection: some View {
        Group {
            if let primaryCard = summaryCards.first {
                if showsSeparatedEventsToggle {
                    ZStack(alignment: .top) {
                        Button(action: expandEvents) {
                            NotificationCenterFeaturedEventCard(
                                model: primaryCard,
                                showsExpandIndicator: true
                            )
                            .opacity(1 - separatedEventsProgress)
                            .offset(y: -8 * separatedEventsProgress)
                        }
                        .buttonStyle(.plain)
                        .allowsHitTesting(separatedEventsProgress < 0.1)

                        VStack(spacing: 18 * separatedEventsProgress) {
                            Button(action: collapseEvents) {
                                HStack(spacing: 10) {
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(Color.white.opacity(0.8))

                                    Text("Свернуть события")
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundStyle(Color.white.opacity(0.8))
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .frame(height: 22 * separatedEventsProgress, alignment: .center)
                            .opacity(separatedEventsProgress)
                            .clipped()
                            .allowsHitTesting(separatedEventsProgress > 0.9)

                            NotificationCenterLinearEventsStack(
                                cards: summaryCards,
                                progress: separatedEventsProgress
                            )
                        }
                        .opacity(max(separatedEventsProgress, 0.001))
                    }
                } else {
                    NotificationCenterFeaturedEventCard(
                        model: primaryCard,
                        showsExpandIndicator: false
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var separatedCategorizedEventsSection: some View {
        if !summaryCards.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 12) {
                    Text("События")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)

                    Spacer(minLength: 0)

                    if showsSeparatedEventsToggle {
                        NotificationCenterSectionToggleButton(
                            isExpanded: isSummaryStackExpanded,
                            action: toggleEventsExpansion
                        )
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }

                NotificationCenterLinearEventsStack(
                    cards: summaryCards,
                    progress: separatedEventsProgress
                )
            }
        }
    }

    private func makeUsefulMarketplaceCard() -> NotificationCenterCardModel {
        .init(
            title: "Ответьте покупателям",
            message: "У вас есть непрочитанные отзывы на Wildberries — нейросеть в Селлере поможет ответить в пару кликов.",
            iconSVG: notificationCenterMarketplaceSVG,
            showsIndicator: true,
            action: .text("Подробнее")
        )
    }

    @ViewBuilder
    private func currentSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: usesLeadingSectionHeaders ? .leading : .center)
    }

    private func expandEvents() {
        isSummaryStackExpanded = true
    }

    private func collapseEvents() {
        isSummaryStackExpanded = false
    }

    private func toggleEventsExpansion() {
        isSummaryStackExpanded.toggle()
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

    private var backSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 12, coordinateSpace: .global)
            .onEnded { value in
                let startsFromEdge = value.startLocation.x <= 28
                let isHorizontal = abs(value.translation.width) > abs(value.translation.height)
                let shouldGoBack =
                    value.translation.width > 44 ||
                    value.predictedEndTranslation.width > 88

                guard startsFromEdge, isHorizontal, shouldGoBack else { return }
                onBack()
            }
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
    let cards: [NotificationCenterSummaryCardModel]
    @Binding var isExpanded: Bool

    @State private var animationProgress: CGFloat = 0

    private let animation = Animation.spring(response: 0.46, dampingFraction: 0.88)

    var body: some View {
        if !cards.isEmpty {
            let progress = animationProgress
            let cardsAreaHeight = collapsedCardsHeight + ((expandedCardsHeight - collapsedCardsHeight) * progress)

            VStack(spacing: 8) {
                ZStack(alignment: .top) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        NotificationCenterSummaryCard(model: card)
                            .frame(height: cardHeight)
                            .offset(y: cardOffset(for: index, progress: progress))
                            .scaleEffect(cardScale(for: index, progress: progress), anchor: .top)
                            .opacity(cardOpacity(for: index, progress: progress))
                            .zIndex(Double(cards.count - index))
                    }
                }
                .frame(height: cardsAreaHeight, alignment: .top)
                .clipped()

                if cards.count > 1 {
                    Button(action: toggleExpansion) {
                        HStack(spacing: 12) {
                            Text(isExpanded ? "Свернуть события" : remainingEventsTitle)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.white.opacity(0.72))

                            Image(systemName: "chevron.up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.white.opacity(0.72))
                                .rotationEffect(.degrees(isExpanded ? 0 : 180))
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: footerHeight, alignment: .center)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 12)
            .padding(.bottom, 12)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            .padding(.horizontal, 16)
            .onAppear {
                animationProgress = isExpanded ? 1 : 0
            }
            .onChange(of: isExpanded) { _, newValue in
                withAnimation(animation) {
                    animationProgress = newValue ? 1 : 0
                }
            }
        }
    }

    private let cardHeight: CGFloat = 80
    private let cardSpacing: CGFloat = 8
    private let footerHeight: CGFloat = 34

    private var collapsedCardsHeight: CGFloat {
        cardHeight
    }

    private var expandedCardsHeight: CGFloat {
        (cardHeight * CGFloat(cards.count)) + (cardSpacing * CGFloat(max(cards.count - 1, 0)))
    }

    private var remainingEventsTitle: String {
        let count = max(cards.count - 1, 0)
        return "Еще \(count) \(russianEventsWord(for: count))"
    }

    private func toggleExpansion() {
        withAnimation(animation) {
            isExpanded.toggle()
        }
    }

    private func cardOffset(for index: Int, progress: CGFloat) -> CGFloat {
        let expandedOffset = CGFloat(index) * (cardHeight + cardSpacing)
        let collapsedOffset = CGFloat(index) * 10
        return collapsedOffset + ((expandedOffset - collapsedOffset) * progress)
    }

    private func cardScale(for index: Int, progress: CGFloat) -> CGFloat {
        let collapsedScale = max(1 - (CGFloat(index) * 0.03), 0.9)
        return collapsedScale + ((1 - collapsedScale) * progress)
    }

    private func cardOpacity(for index: Int, progress: CGFloat) -> Double {
        guard index > 0 else { return 1 }

        let startThreshold = CGFloat(index) * 0.16
        let normalizedProgress = max(progress - startThreshold, 0) / max(1 - startThreshold, 0.001)
        return Double(normalizedProgress)
    }

    private func russianEventsWord(for count: Int) -> String {
        let remainder100 = count % 100
        let remainder10 = count % 10

        if (11...14).contains(remainder100) {
            return "событий"
        }

        switch remainder10 {
        case 1:
            return "событие"
        case 2...4:
            return "события"
        default:
            return "событий"
        }
    }
}

private struct NotificationCenterSummaryCard: View {
    let model: NotificationCenterSummaryCardModel
    var contentOpacity: Double = 1

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(model.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(model.message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(red: 0.57, green: 0.60, blue: 0.64))
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            NotificationCenterSummaryCardTrailingContentView(trailing: model.trailing)
        }
        .opacity(contentOpacity)
        .padding(.leading, 20)
        .padding(.trailing, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.13))
        )
    }
}

private struct NotificationCenterLinearEventsStack: View {
    let cards: [NotificationCenterSummaryCardModel]
    let progress: CGFloat

    private static let cardHeight: CGFloat = 80
    private static let cardSpacing: CGFloat = 12
    private static let collapsedVisibleBottomInset: CGFloat = 16

    var body: some View {
        if !cards.isEmpty {
            ZStack(alignment: .top) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    NotificationCenterStackLayerCard(
                        model: card,
                        visibleHeight: layerHeight(for: index),
                        contentOpacity: cardContentOpacity(for: index)
                    )
                        .offset(y: cardOffset(for: index))
                        .opacity(cardOpacity(for: index))
                        .zIndex(Double(cards.count - index))
                }
            }
            .frame(height: containerHeight, alignment: .top)
            .clipped()
        }
    }

    private var containerHeight: CGFloat {
        let collapsedHeight = Self.cardHeight + Self.collapsedVisibleBottomInset
        let expandedHeight =
            (Self.cardHeight * CGFloat(cards.count)) +
            (Self.cardSpacing * CGFloat(max(cards.count - 1, 0)))

        return collapsedHeight + ((expandedHeight - collapsedHeight) * progress)
    }

    private func cardOffset(for index: Int) -> CGFloat {
        let expandedOffset = CGFloat(index) * (Self.cardHeight + Self.cardSpacing)
        let collapsedOffset = collapsedOffset(for: index)
        return collapsedOffset + ((expandedOffset - collapsedOffset) * progress)
    }

    private func cardOpacity(for index: Int) -> Double {
        guard index > 0 else { return 1 }

        let collapsedOpacity = max(0.18, 0.42 - (Double(index - 1) * 0.18))
        return collapsedOpacity + ((1 - collapsedOpacity) * Double(progress))
    }

    private func collapsedOffset(for index: Int) -> CGFloat {
        switch index {
        case 0:
            return 0
        case 1:
            return 62
        case 2:
            return 72
        default:
            return 72 + (CGFloat(index - 2) * 8)
        }
    }

    private func cardContentOpacity(for index: Int) -> Double {
        guard index > 0 else { return 1 }

        let revealStart = min(0.62 + (CGFloat(index - 1) * 0.12), 0.92)
        let normalized = max(progress - revealStart, 0) / max(1 - revealStart, 0.001)
        return Double(normalized)
    }

    private func layerHeight(for index: Int) -> CGFloat {
        let collapsedHeight: CGFloat
        switch index {
        case 0:
            collapsedHeight = Self.cardHeight
        case 1:
            collapsedHeight = 22
        case 2:
            collapsedHeight = 14
        default:
            collapsedHeight = 10
        }

        return collapsedHeight + ((Self.cardHeight - collapsedHeight) * progress)
    }
}

private struct NotificationCenterStackLayerCard: View {
    let model: NotificationCenterSummaryCardModel
    let visibleHeight: CGFloat
    let contentOpacity: Double
    private let fullHeight: CGFloat = 80

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.13))

            NotificationCenterSummaryCard(
                model: model,
                contentOpacity: contentOpacity
            )
        }
        .frame(height: fullHeight, alignment: .bottom)
        .frame(height: visibleHeight, alignment: .bottom)
        .clipped()
    }
}

private struct NotificationCenterSummaryCardTrailingContentView: View {
    let trailing: NotificationCenterSummaryCardModel.Trailing
    var preferredSize: CGSize? = nil

    var body: some View {
        switch trailing {
        case .svg(let svg, let size):
            let resolvedSize = preferredSize ?? size
            PrewarmedSVGView(svg: svg, size: resolvedSize)
                .frame(width: resolvedSize.width, height: resolvedSize.height)
        case .avatar(let image):
            let side = preferredSize?.width ?? 40
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: side, height: side)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.16))

                    Text("IS")
                        .font(.system(size: side * 0.45, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: side, height: side)
            }
        }
    }
}

private struct NotificationCenterFeaturedEventCard: View {
    let model: NotificationCenterSummaryCardModel
    let showsExpandIndicator: Bool

    var body: some View {
        content
    }

    private var content: some View {
        VStack(spacing: 18) {
            NotificationCenterSummaryCardTrailingContentView(
                trailing: model.trailing,
                preferredSize: CGSize(width: 64, height: 64)
            )
            .frame(width: 64, height: 64)

            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text(model.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if showsExpandIndicator {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.54))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Text(model.message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(red: 0.57, green: 0.60, blue: 0.64))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.13))
        )
    }
}

private struct NotificationCenterSectionToggleButton: View {
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(
                        .spring(response: 0.28, dampingFraction: 0.88),
                        value: isExpanded
                    )

                Text(isExpanded ? "Свернуть" : "Развернуть")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
            }
            .padding(.horizontal, 12)
            .frame(height: 32)
            .fixedSize(horizontal: true, vertical: false)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.10))
            )
        }
        .buttonStyle(.plain)
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

private struct NotificationCenterSummaryCardModel: Identifiable {
    enum Trailing {
        case svg(String, CGSize)
        case avatar(UIImage?)
    }

    let id = UUID()
    let title: String
    let message: String
    let trailing: Trailing
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
private let notificationCenterStackExpandedSVG = loadNotificationCenterSVG(
    named: "notification-center-stack-expanded"
)
private let notificationCenterBusinessAvatarImage = extractEmbeddedNotificationCenterImage(
    from: notificationCenterStackExpandedSVG
)

private func extractEmbeddedNotificationCenterImage(from svg: String) -> UIImage? {
    guard let base64PrefixRange = svg.range(of: "data:image/jpeg;base64,") else { return nil }
    let imageDataStartIndex = base64PrefixRange.upperBound
    guard let imageDataEndIndex = svg[imageDataStartIndex...].firstIndex(of: "\"") else { return nil }

    let encodedImage = String(svg[imageDataStartIndex..<imageDataEndIndex])
    guard let imageData = Data(base64Encoded: encodedImage) else { return nil }

    return UIImage(data: imageData)
}
