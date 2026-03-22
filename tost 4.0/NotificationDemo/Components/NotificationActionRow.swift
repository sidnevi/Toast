import SwiftUI

struct NotificationActionRow: View {
    let actions: [NotificationAction]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(actions) { action in
                Text(action.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(actionForegroundColor(for: action))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(actionBackgroundColor(for: action))
                    )
                    .opacity(action.isEnabled ? 1 : 0.45)
            }
        }
    }

    private func actionBackgroundColor(for action: NotificationAction) -> Color {
        switch action.style {
        case .primary:
            return Color.white.opacity(0.18)
        case .secondary:
            return Color.white.opacity(0.08)
        }
    }

    private func actionForegroundColor(for action: NotificationAction) -> Color {
        switch action.style {
        case .primary:
            return .white
        case .secondary:
            return Color.white.opacity(0.82)
        }
    }
}
