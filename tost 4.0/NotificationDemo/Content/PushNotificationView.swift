import SwiftUI

struct PushNotificationView: View {
    let model: PushNotificationContent
    let actions: [NotificationAction]

    var body: some View {
        if let foregroundSVG = model.foregroundSVG, !foregroundSVG.isEmpty {
            InlineSVGWebView(svg: foregroundSVG)
                .frame(width: PushNotificationLayout.width, height: model.preferredHeight)
        } else {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.16))
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "app.badge.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(model.appName)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.white.opacity(0.78))

                            if let accessoryText = model.accessoryText {
                                Text(accessoryText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color.white.opacity(0.48))
                            }
                        }

                        Text(model.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(model.message)
                            .font(.system(size: 15))
                            .foregroundStyle(Color.white.opacity(0.74))
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
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

private enum PushNotificationLayout {
    static let width: CGFloat = 351
}
