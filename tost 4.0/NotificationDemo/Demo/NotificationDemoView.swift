import SwiftUI

struct NotificationDemoView: View {
    @ObservedObject var notificationSelectionStore: NotificationSelectionStore
    @StateObject private var viewModel: NotificationDemoViewModel

    init(notificationSelectionStore: NotificationSelectionStore) {
        self.notificationSelectionStore = notificationSelectionStore
        _viewModel = StateObject(
            wrappedValue: NotificationDemoViewModel(selectionStore: notificationSelectionStore)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    previewCard
                    controlsCard
                }
                .padding(16)
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
                get: { notificationSelectionStore.selectedKind },
                set: { viewModel.selectKind($0) }
            )) {
                ForEach(NotificationKind.allCases) { kind in
                    Text(kindTitle(kind)).tag(kind)
                }
            }
            .pickerStyle(.segmented)

            controlSectionTitle("Сценарий")

            Picker("Scenario", selection: Binding(
                get: { notificationSelectionStore.selectedScenarioID },
                set: { viewModel.selectScenario(id: $0) }
            )) {
                ForEach(notificationSelectionStore.scenariosForSelectedKind) { scenario in
                    Text(scenario.title).tag(scenario.id)
                }
            }

            controlSectionTitle("Appearance")

            Picker("Text size", selection: Binding(
                get: { viewModel.state.dynamicTypeSize },
                set: { viewModel.setDynamicTypeSize($0) }
            )) {
                ForEach(dynamicTypeOptions, id: \.self) { size in
                    Text(dynamicTypeTitle(size)).tag(size)
                }
            }

            controlSectionTitle("Behavior")

            Toggle(isOn: Binding(
                get: { viewModel.state.showsSourceBell },
                set: { viewModel.setShowsSourceBell($0) }
            )) {
                behaviorRow(
                    title: "Show Source Bell",
                    subtitle: "Показывать исходную кнопку-источник в home context."
                )
            }
            .toggleStyle(.switch)

            Toggle(isOn: Binding(
                get: { viewModel.state.autoPresentOnOpen },
                set: { viewModel.setAutoPresentOnOpen($0) }
            )) {
                behaviorRow(
                    title: "Auto Present On Open",
                    subtitle: "Автоматически проигрывать уведомление при открытии demo."
                )
            }
            .toggleStyle(.switch)

            Toggle(isOn: Binding(
                get: { viewModel.state.autoPresentOnScenarioChange },
                set: { viewModel.setAutoPresentOnScenarioChange($0) }
            )) {
                behaviorRow(
                    title: "Auto Present On Change",
                    subtitle: "Повторно запускать анимацию при смене типа или сценария."
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
        NotificationDemoIsolatedPreview(scenario: notificationSelectionStore.selectedScenario)
    }

    private var homeContextPreview: some View {
        NotificationDemoHomeContextPreviewRepresentable(
            scenario: notificationSelectionStore.selectedScenario,
            controller: viewModel.animationController,
            preferredColorScheme: viewModel.state.preferredColorScheme,
            dynamicTypeSize: viewModel.state.dynamicTypeSize
        )
        .frame(height: 812)
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

    private func dynamicTypeTitle(_ size: DynamicTypeSize) -> String {
        switch size {
        case .small:
            return "S"
        case .medium:
            return "M"
        case .large:
            return "L"
        case .xLarge:
            return "XL"
        case .xxLarge:
            return "XXL"
        default:
            return "AX"
        }
    }

    private var dynamicTypeOptions: [DynamicTypeSize] {
        [.small, .medium, .large, .xLarge, .xxLarge, .accessibility1]
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

private struct NotificationDemoIsolatedPreview: View {
    let scenario: NotificationScenario

    private var presentationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: scenario)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                NotificationContentFactory.makeView(for: scenario)
                    .frame(width: presentationMetrics.contentWidth, alignment: .top)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 180, maxHeight: 360, alignment: .top)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black.opacity(0.26))
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
