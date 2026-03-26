import SwiftUI
import UIKit

struct NotificationPresentationMetrics {
    let contentWidth: CGFloat
    let contentHeight: CGFloat
    let footerHeight: CGFloat
    let footerVariant: NotificationFooterView.Variant
    let containerHeight: CGFloat
}

enum NotificationContentFactory {
    private enum Layout {
        static let contentWidth: CGFloat = 351
        static let footerHeight: CGFloat = 20
        static let minimumCardHeight: CGFloat = 114
        static let horizontalPadding: CGFloat = 18
        static let pushIconSize: CGFloat = 40
        static let pushLeadingSpacing: CGFloat = 12
        static let pushStackSpacing: CGFloat = 14
        static let pushTextSpacing: CGFloat = 4
        static let eventStackSpacing: CGFloat = 14
        static let eventDetailsSpacing: CGFloat = 8
        static let eventDetailsPadding: CGFloat = 12
    }

    @ViewBuilder
    static func makeView(for scenario: NotificationScenario) -> some View {
        switch scenario.payload {
        case .inApp(let model):
            InAppNotificationView(model: model)
        case .push(let model):
            PushNotificationView(model: model, actions: scenario.actions)
        case .event(let model):
            EventNotificationView(model: model, actions: scenario.actions)
        }
    }

    static func presentationMetrics(for scenario: NotificationScenario) -> NotificationPresentationMetrics {
        let contentHeight: CGFloat
        let footerVariant: NotificationFooterView.Variant

        switch scenario.payload {
        case .inApp:
            contentHeight = Layout.minimumCardHeight
            footerVariant = .inApp
        case .push(let model):
            if let foregroundSVG = model.foregroundSVG, !foregroundSVG.isEmpty {
                contentHeight = model.preferredHeight
            } else {
                contentHeight = pushContentHeight(for: model, actions: scenario.actions)
            }
            footerVariant = .push
        case .event(let model):
            if let foregroundSVG = model.foregroundSVG, !foregroundSVG.isEmpty {
                contentHeight = model.preferredHeight
            } else {
                contentHeight = eventContentHeight(for: model, actions: scenario.actions)
            }
            footerVariant = .event
        }

        return .init(
            contentWidth: Layout.contentWidth,
            contentHeight: contentHeight,
            footerHeight: Layout.footerHeight,
            footerVariant: footerVariant,
            containerHeight: contentHeight + Layout.footerHeight
        )
    }

    private static func pushContentHeight(
        for model: PushNotificationContent,
        actions: [NotificationAction]
    ) -> CGFloat {
        let innerWidth = Layout.contentWidth - (Layout.horizontalPadding * 2)
        let textColumnWidth = innerWidth - Layout.pushIconSize - Layout.pushLeadingSpacing

        let metaRowHeight = singleLineHeight(font: .systemFont(ofSize: 13, weight: .semibold))
        let titleHeight = textHeight(
            model.title,
            font: .systemFont(ofSize: 17, weight: .semibold),
            width: textColumnWidth,
            maximumLines: 2
        )
        let messageHeight = textHeight(
            model.message,
            font: .systemFont(ofSize: 15),
            width: textColumnWidth,
            maximumLines: 3
        )

        let textBlockHeight = metaRowHeight + Layout.pushTextSpacing + titleHeight + Layout.pushTextSpacing + messageHeight
        let headerHeight = max(Layout.pushIconSize, ceil(textBlockHeight))
        let actionsHeight = actions.isEmpty ? 0 : actionRowHeight()
        let stackSpacing = actions.isEmpty ? 0 : Layout.pushStackSpacing

        let totalHeight = (Layout.horizontalPadding * 2) + headerHeight + stackSpacing + actionsHeight
        return max(Layout.minimumCardHeight, ceil(totalHeight))
    }

    private static func eventContentHeight(
        for model: EventNotificationContent,
        actions: [NotificationAction]
    ) -> CGFloat {
        let innerWidth = Layout.contentWidth - (Layout.horizontalPadding * 2)
        var totalHeight: CGFloat = Layout.horizontalPadding * 2
        var blocks: [CGFloat] = []

        if let eyebrow = model.eyebrow, !eyebrow.isEmpty {
            blocks.append(singleLineHeight(font: .systemFont(ofSize: 12, weight: .semibold)))
        }

        blocks.append(
            textHeight(
                model.title,
                font: .systemFont(ofSize: 20, weight: .semibold),
                width: innerWidth,
                maximumLines: 2
            )
        )

        blocks.append(
            textHeight(
                model.message,
                font: .systemFont(ofSize: 15),
                width: innerWidth,
                maximumLines: 4
            )
        )

        if !model.details.isEmpty {
            let detailsContentHeight = CGFloat(model.details.count) * singleLineHeight(font: .systemFont(ofSize: 13, weight: .medium))
            let detailsSpacing = CGFloat(max(model.details.count - 1, 0)) * Layout.eventDetailsSpacing
            blocks.append(detailsContentHeight + detailsSpacing + (Layout.eventDetailsPadding * 2))
        }

        if !actions.isEmpty {
            blocks.append(actionRowHeight())
        }

        if !blocks.isEmpty {
            totalHeight += blocks.reduce(0, +)
            totalHeight += CGFloat(max(blocks.count - 1, 0)) * Layout.eventStackSpacing
        }

        return max(Layout.minimumCardHeight, ceil(totalHeight))
    }

    private static func actionRowHeight() -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return ceil(font.lineHeight + 22)
    }

    private static func singleLineHeight(font: UIFont) -> CGFloat {
        ceil(font.lineHeight)
    }

    private static func textHeight(
        _ text: String,
        font: UIFont,
        width: CGFloat,
        maximumLines: Int
    ) -> CGFloat {
        let rect = NSString(string: text).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        let maximumHeight = font.lineHeight * CGFloat(maximumLines)
        return ceil(min(rect.height, maximumHeight))
    }
}
