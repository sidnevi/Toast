import SwiftUI

struct NotificationStaticCardView: View {
    let scenario: NotificationScenario

    private var presentationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: scenario)
    }

    var body: some View {
        VStack(spacing: 0) {
            NotificationContentFactory.makeView(for: scenario)
                .frame(
                    width: presentationMetrics.contentWidth,
                    height: presentationMetrics.contentHeight,
                    alignment: .top
                )

            if presentationMetrics.footerHeight > 0 {
                NotificationFooterView(
                    style: .init(
                        size: CGSize(
                            width: presentationMetrics.contentWidth,
                            height: presentationMetrics.footerHeight
                        ),
                        variant: presentationMetrics.footerVariant
                    )
                )
            }
        }
        .frame(width: presentationMetrics.contentWidth, height: presentationMetrics.containerHeight)
        .overlay {
            NotificationUnifiedSurfaceShape(
                cornerRadius: 32,
                footerHeight: presentationMetrics.footerHeight,
                variant: presentationMetrics.footerVariant
            )
            .stroke(Color.white.opacity(0.1), lineWidth: 1.068)
        }
    }
}
