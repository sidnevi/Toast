import SwiftUI

struct NotificationDemoView: View {
    @StateObject private var viewModel: NotificationDemoViewModel

    init(homeBridge: NotificationDemoHomeBridge) {
        _viewModel = StateObject(
            wrappedValue: NotificationDemoViewModel(homeBridge: homeBridge)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    multipleCandidatesCard
                    if viewModel.state.displayMode == .single {
                        previewCard
                    }
                    controlsCard
                    homeBehaviorCard
                    if viewModel.state.displayMode == .multiple {
                        NotificationMultiplePreviewSection(
                            selectionResult: viewModel.selectionResult
                        )
                    }
                }
                .frame(maxWidth: NotificationDemoLayout.contentMaxWidth)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, NotificationDemoLayout.horizontalPadding)
                .padding(.vertical, NotificationDemoLayout.verticalPadding)
            }
            .background(NotificationDemoBackground().ignoresSafeArea())
            .navigationTitle("Notification Demo")
            .onAppear {
                viewModel.handleDemoAppear()
            }
        }
    }

    private var controlsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            controlSectionTitle("Тип уведомления")

            if viewModel.state.displayMode == .single {
                Picker("Type", selection: Binding(
                    get: { viewModel.state.selectedKind },
                    set: { viewModel.selectKind($0) }
                )) {
                    ForEach(NotificationKind.allCases) { kind in
                        Text(kindTitle(kind)).tag(kind)
                    }
                }
                .pickerStyle(.segmented)

                controlSectionTitle("Вид ЦУ")

                Picker("Notification Center Layout", selection: Binding(
                    get: { viewModel.state.notificationCenterLayoutMode },
                    set: { viewModel.setNotificationCenterLayoutMode($0) }
                )) {
                    ForEach(NotificationCenterLayoutMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                if viewModel.showsScenarioPicker {
                    controlSectionTitle("Сценарий")

                    Picker("Scenario", selection: Binding(
                        get: { viewModel.selectedSingleScenario.id },
                        set: { viewModel.selectScenario(id: $0) }
                    )) {
                        ForEach(viewModel.scenariosForSelectedKind) { scenario in
                            Text(scenario.title).tag(scenario.id)
                        }
                    }
                }
            } else {
                controlSectionTitle("Вид ЦУ")

                Picker("Notification Center Layout", selection: Binding(
                    get: { viewModel.state.notificationCenterLayoutMode },
                    set: { viewModel.setNotificationCenterLayoutMode($0) }
                )) {
                    ForEach(NotificationCenterLayoutMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(18)
        .background(DemoPanelBackground())
    }

    @ViewBuilder
    private var multipleCandidatesCard: some View {
        if viewModel.state.displayMode == .multiple {
            VStack(alignment: .leading, spacing: 16) {
                controlSectionTitle("Кандидаты на показ")

                Picker("Candidate Preset", selection: Binding(
                    get: { viewModel.state.candidatePreset },
                    set: { viewModel.setCandidatePreset($0) }
                )) {
                    ForEach(NotificationCandidatePreset.allCases) { preset in
                        Text(preset.title).tag(preset)
                    }
                }
                .pickerStyle(.menu)

                Text(viewModel.selectedCandidatePresetSubtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.white.opacity(0.56))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(DemoPanelBackground())
        }
    }

    private var homeBehaviorCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            controlSectionTitle("Настройки показа")

            Picker("Display Mode", selection: Binding(
                get: { viewModel.state.displayMode },
                set: { viewModel.setDisplayMode($0) }
            )) {
                ForEach(NotificationDisplayMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Text(
                viewModel.state.displayMode == .single
                    ? "В single-режиме Demo показывает только итоговое уведомление."
                    : "В multiple-режиме Demo показывает всех кандидатов, победителя и объяснение выбора."
            )
            .font(.system(size: 13))
            .foregroundStyle(Color.white.opacity(0.56))
            .fixedSize(horizontal: false, vertical: true)

            Toggle("Autoplay On Home", isOn: Binding(
                get: { viewModel.homeBridge.autoPlayOnHomeSelection },
                set: { viewModel.setAutoPlayOnHomeSelection($0) }
            ))
            .toggleStyle(.switch)
            .tint(.white.opacity(0.8))

            behaviorRow(
                title: "In-App и Push",
                subtitle: "Показываются на главной странице 2 секунды и скрываются автоматически."
            )

            behaviorRow(
                title: "Event",
                subtitle: "Остается на главной и не закрывается вручную, пока не будет открыт связанный экран события. После возврата на Home скрывается стандартной анимацией."
            )
        }
        .padding(18)
        .background(DemoPanelBackground())
    }

    private var previewCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Preview")
                .font(.headline)
                .foregroundStyle(.white)

            Text("На Demo смотрим статичное состояние. Анимацию проверяем на вкладке Home.")
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.56))
                .fixedSize(horizontal: false, vertical: true)

            isolatedPreview
                .environment(\.dynamicTypeSize, viewModel.state.dynamicTypeSize)
                .preferredColorScheme(viewModel.state.preferredColorScheme)
        }
        .padding(18)
        .background(DemoPanelBackground())
    }

    private var isolatedPreview: some View {
        NotificationDemoIsolatedPreview(scenario: viewModel.selectedScenario)
    }

    private func controlSectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.white.opacity(0.7))
    }

    private func kindTitle(_ kind: NotificationKind) -> String {
        switch kind {
        case .inApp:
            return "In-App"
        case .push:
            return "Push"
        case .event:
            return "Event"
        }
    }

    private func behaviorRow(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.56))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private enum NotificationDemoLayout {
    static let contentMaxWidth: CGFloat = 560
    static let horizontalPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
}

private struct NotificationDemoIsolatedPreview: View {
    let scenario: NotificationScenario

    private var presentationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: scenario)
    }

    var body: some View {
        GeometryReader { proxy in
            let availableCanvasWidth = max(
                proxy.size.width - (NotificationDemoIsolatedPreviewLayout.horizontalInset * 2),
                1
            )
            let scale = min(
                1,
                availableCanvasWidth / NotificationDemoIsolatedPreviewLayout.canvasWidth
            )
            let containerHeight = presentationMetrics.containerHeight
            let contentHeight = presentationMetrics.contentHeight
            let scaledContainerHeight = containerHeight * scale

            ZStack {
                ZStack(alignment: .topLeading) {
                    NotificationDemoPreviewStageBackground()
                        .frame(
                            width: presentationMetrics.contentWidth,
                            height: contentHeight
                        )

                    NotificationStaticCardView(scenario: scenario)
                        .frame(
                            width: presentationMetrics.contentWidth,
                            height: containerHeight,
                            alignment: .topLeading
                        )
                }
                .scaleEffect(scale, anchor: .topLeading)
                .frame(
                    width: NotificationDemoIsolatedPreviewLayout.canvasWidth,
                    height: containerHeight,
                    alignment: .topLeading
                )
                .padding(.top, NotificationDemoIsolatedPreviewLayout.topInset)
            }
            .frame(
                width: proxy.size.width,
                height: max(
                    NotificationDemoIsolatedPreviewLayout.minimumHeight,
                    scaledContainerHeight + NotificationDemoIsolatedPreviewLayout.verticalPadding
                ),
                alignment: .topLeading
            )
        }
        .frame(
            minHeight: max(
                NotificationDemoIsolatedPreviewLayout.minimumHeight,
                presentationMetrics.containerHeight + NotificationDemoIsolatedPreviewLayout.verticalPadding
            ),
            alignment: .top
        )
    }
}

private enum NotificationDemoIsolatedPreviewLayout {
    static let canvasWidth: CGFloat = 375
    static let horizontalInset: CGFloat = 8
    static let topInset: CGFloat = 8
    static let verticalPadding: CGFloat = 16
    static let minimumHeight: CGFloat = 144
}

private struct NotificationDemoPreviewStageBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color.black.opacity(0.28))
            .overlay {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.02),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    RadialGradient(
                        colors: [
                            Color(red: 0.97, green: 0.94, blue: 0.86).opacity(0.22),
                            Color(red: 0.96, green: 0.90, blue: 0.72).opacity(0.10),
                            .clear
                        ],
                        center: .bottomTrailing,
                        startRadius: 8,
                        endRadius: 180
                    )
                    .offset(x: 26, y: 24)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            }
    }
}

private struct NotificationDemoBackground: View {
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
        }
    }
}

private struct DemoPanelBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color.white.opacity(0.08))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
    }
}

private struct DemoPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.78 : 0.92))
            )
    }
}

private struct DemoSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.10 : 0.14))
            )
    }
}
