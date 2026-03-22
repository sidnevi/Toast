import SwiftUI

struct CompactCompanyHeaderView: View {
    enum Layout {
        static let width: CGFloat = 375
        static let height: CGFloat = 44
        static let avatarSize: CGFloat = 24
        static let bellSize: CGFloat = 24
        static let horizontalInset: CGFloat = 16
        static let interItemSpacing: CGFloat = 20
        static let contentTopInset: CGFloat = 4
        static let textWidth: CGFloat = 255
        static let revealMinY: CGFloat = 52
    }

    let title: String
    let subtitle: String

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay {
                    Color.black.opacity(0.54)
                }

            HStack(alignment: .center, spacing: Layout.interItemSpacing) {
                CompactAvatarView()
                    .frame(width: Layout.avatarSize, height: Layout.avatarSize)

                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.55))
                        .lineLimit(1)
                }
                .frame(width: Layout.textWidth, alignment: .leading)

                CompactBellView()
                    .frame(width: Layout.bellSize, height: Layout.bellSize)
            }
            .padding(.top, Layout.contentTopInset)
            .padding(.horizontal, Layout.horizontalInset)
            .frame(width: Layout.width, height: Layout.height, alignment: .center)
        }
        .frame(width: Layout.width, height: Layout.height)
    }

    private struct CompactAvatarView: View {
        var body: some View {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.56, blue: 0.22),
                            Color(red: 0.97, green: 0.46, blue: 0.17)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Text("D")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(.white)
                }
        }
    }

    private struct CompactBellView: View {
        var body: some View {
            Image(systemName: "bell")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.9))
                .frame(width: 24, height: 24)
        }
    }
}

struct CompactCompanyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            CompactCompanyHeaderView(
                title: "Додо Франчайзинг",
                subtitle: "Директор"
            )
            .padding(.top, 60)
        }
    }
}
