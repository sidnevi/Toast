import SwiftUI

struct AccountingSectionView: View {
    enum Layout {
        static let sectionWidth: CGFloat = 375
        static let titleHeight: CGFloat = 76
        static let cardWidth: CGFloat = 163.5
        static let cardHeight: CGFloat = 148
        static let totalHeight: CGFloat = titleHeight + cardHeight
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AccountingSectionTitleView(title: "Бухгалтерия")

            AccountingInsightCard(
                title: "Контроль",
                subtitle: "отчетности и платежей",
                value: "12 дней",
                detail: "до ближайшего срока",
                progress: 0.45,
                tint: Color(red: 0.26, green: 0.55, blue: 0.98)
            )
            .padding(.leading, 16)
        }
        .frame(width: Layout.sectionWidth, height: Layout.totalHeight, alignment: .topLeading)
    }
}

struct AccountingSectionTitleView: View {
    let title: String

    private let horizontalInset: CGFloat = 16

    var body: some View {
        Text(title)
            .font(.system(size: 29, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.top, 32)
            .padding(.horizontal, horizontalInset)
            .frame(width: AccountingSectionView.Layout.sectionWidth, height: AccountingSectionView.Layout.titleHeight, alignment: .topLeading)
    }
}

struct AccountingInsightCard: View {
    let title: String
    let subtitle: String
    let value: String
    let detail: String
    let progress: CGFloat
    let tint: Color

    private let shadowColor = Color.black.opacity(0.12)
    private let secondaryText = Color(red: 0.57, green: 0.60, blue: 0.64)
    private let cardBackground = Color.white
    private let progressTrack = Color(red: 0.0, green: 0.06, blue: 0.14).opacity(0.06)
    private let contentWidth: CGFloat = 123.5

    var body: some View {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
            .fill(cardBackground)
            .frame(width: AccountingSectionView.Layout.cardWidth, height: AccountingSectionView.Layout.cardHeight)
            .shadow(color: shadowColor, radius: 17, y: 6)
            .overlay {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))

                        Text(subtitle)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(secondaryText)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(width: contentWidth, height: 48, alignment: .topLeading)

                    Spacer(minLength: 0)

                    Text(value)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color(red: 0.2, green: 0.2, blue: 0.2))

                    Spacer()
                        .frame(height: 4)

                    Text(detail)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(secondaryText)

                    Spacer(minLength: 0)

                    Capsule()
                        .fill(progressTrack)
                        .frame(width: contentWidth, height: 12)
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(tint)
                                .frame(width: contentWidth * min(max(progress, 0), 1), height: 12)
                        }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
    }
}

struct AccountingSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            AccountingSectionView()
        }
    }
}
