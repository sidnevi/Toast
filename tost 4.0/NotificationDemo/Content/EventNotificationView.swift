import SwiftUI

struct EventNotificationView: View {
    let model: EventNotificationContent
    let actions: [NotificationAction]

    var body: some View {
        if let foregroundSVG = model.foregroundSVG, !foregroundSVG.isEmpty {
            PrewarmedSVGView(
                svg: foregroundSVG,
                size: CGSize(width: EventNotificationLayout.width, height: model.preferredHeight)
            )
        } else {
            VStack(alignment: .leading, spacing: 14) {
                if let eyebrow = model.eyebrow {
                    Text(eyebrow.uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(0.8)
                        .foregroundStyle(Color.white.opacity(0.56))
                }

                Text(model.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(model.message)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white.opacity(0.74))
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                if !model.details.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(model.details) { detail in
                            HStack(spacing: 8) {
                                Text(detail.title)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(Color.white.opacity(0.56))

                                Spacer(minLength: 8)

                                Text(detail.value)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                }

                if !actions.isEmpty {
                    NotificationActionRow(actions: actions)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
}

private enum EventNotificationLayout {
    static let width: CGFloat = 351
}
