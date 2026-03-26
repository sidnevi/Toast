import SwiftUI

struct CommunicationPlaceholderView: View {
    let title: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                GeometryReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 20) {
                            header(safeAreaTopInset: proxy.safeAreaInsets.top)

                            VStack(spacing: 16) {
                                CommunicationPlaceholderBlock(height: 156, cornerRadius: 28)

                                HStack(spacing: 12) {
                                    CommunicationPlaceholderBlock(height: 96, cornerRadius: 24)
                                    CommunicationPlaceholderBlock(height: 96, cornerRadius: 24)
                                }

                                CommunicationPlaceholderBlock(height: 128, cornerRadius: 26)
                                CommunicationPlaceholderBlock(height: 196, cornerRadius: 28)
                                CommunicationPlaceholderBlock(height: 116, cornerRadius: 24)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private func header(safeAreaTopInset: CGFloat) -> some View {
        HStack(alignment: .center, spacing: 12) {
            CommunicationBackBubbleButton(action: dismiss.callAsFunction)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.88))
                .lineLimit(1)

            Spacer(minLength: 0)
        }
        .padding(.top, max(safeAreaTopInset, 8))
    }
}

private struct CommunicationPlaceholderBlock: View {
    let height: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.white.opacity(0.08))
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            }
    }
}

private struct CommunicationBackBubbleButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if #available(iOS 26.0, *) {
                    Circle()
                        .fill(.clear)
                        .frame(width: 44, height: 44)
                        .glassEffect(in: Circle())
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .overlay {
                            Circle()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        }
                        .frame(width: 44, height: 44)
                }

                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
    }
}
