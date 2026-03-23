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
                    previewCard
                    controlsCard
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

            Picker("Type", selection: Binding(
                get: { viewModel.state.selectedKind },
                set: { viewModel.selectKind($0) }
            )) {
                ForEach(NotificationKind.allCases) { kind in
                    Text(kindTitle(kind)).tag(kind)
                }
            }
            .pickerStyle(.segmented)

            if viewModel.showsScenarioPicker {
                controlSectionTitle("Сценарий")

                Picker("Scenario", selection: Binding(
                    get: { viewModel.selectedScenario.id },
                    set: { viewModel.selectScenario(id: $0) }
                )) {
                    ForEach(viewModel.scenariosForSelectedKind) { scenario in
                        Text(scenario.title).tag(scenario.id)
                    }
                }
            }

            Toggle(isOn: Binding(
                get: { viewModel.homeBridge.autoPlayOnHomeSelection },
                set: { viewModel.setAutoPlayOnHomeSelection($0) }
            )) {
                behaviorRow(
                    title: "Autoplay On Home",
                    subtitle: "После выбора на Demo автоматически показывать выбранное уведомление на странице Home."
                )
            }
            .toggleStyle(.switch)
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
            let scaledContainerHeight = containerHeight * scale

            ZStack {
                NotificationStaticCardView(scenario: scenario)
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
