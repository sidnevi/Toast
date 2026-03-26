import SwiftUI

struct NotificationSelectionSummaryView: View {
    let explanation: NotificationSelectionExplanation

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(explanation.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            Text(explanation.summary)
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)

            ForEach(explanation.bullets, id: \.self) { bullet in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.white.opacity(0.38))
                        .frame(width: 4, height: 4)
                        .padding(.top, 6)

                    Text(bullet)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white.opacity(0.62))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
