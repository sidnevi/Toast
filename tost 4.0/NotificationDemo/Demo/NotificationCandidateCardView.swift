import SwiftUI

struct NotificationCandidateCardView: View {
    let evaluation: NotificationCandidateEvaluation
    let scenario: NotificationScenario

    private var presentationMetrics: NotificationPresentationMetrics {
        NotificationContentFactory.presentationMetrics(for: scenario)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(evaluation.candidate.sourceLabel)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(evaluation.candidate.source.priorityTitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.56))
                }

                Spacer(minLength: 12)

                statusBadge
            }

            candidateMetadata

            candidatePreview

            Text(evaluation.resolutionReason)
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.62))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundFill, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(borderColor, lineWidth: evaluation.isWinner ? 1.5 : 1)
        }
    }

    private var statusBadge: some View {
        Text(evaluation.isWinner ? "Победитель" : "Не выбран")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(evaluation.isWinner ? Color.black : Color.white.opacity(0.74))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                evaluation.isWinner
                    ? Color(red: 0.96, green: 0.90, blue: 0.72)
                    : Color.white.opacity(0.08),
                in: Capsule()
            )
    }

    private var candidateMetadata: some View {
        VStack(alignment: .leading, spacing: 4) {
            metadataLine(title: "Источник выбора", value: evaluation.candidate.sourceSelectionRule)

            if let productPriority = evaluation.candidate.productPriority {
                metadataLine(title: "Порядок продукта", value: "\(productPriority)")
            }

            if let createdAt = evaluation.candidate.createdAt {
                metadataLine(
                    title: "Создано",
                    value: Self.dateFormatter.string(from: createdAt)
                )
            }

            if evaluation.candidate.source == .criticalPush {
                metadataLine(
                    title: "Статус",
                    value: evaluation.candidate.isUnread ? "Непрочитанное" : "Прочитано"
                )
            }

            if let rtbScore = evaluation.candidate.rtbScore,
               let rtbRank = evaluation.candidate.rtbRank {
                metadataLine(
                    title: "RTB",
                    value: String(format: "score %.2f, rank %d", rtbScore, rtbRank)
                )
            }

            if let note = evaluation.candidate.note {
                metadataLine(title: "Пояснение", value: note)
            }
        }
    }

    private func metadataLine(title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text(title + ":")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.42))

            Text(value)
                .font(.system(size: 12))
                .foregroundStyle(Color.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var candidatePreview: some View {
        let previewWidth = presentationMetrics.contentWidth
        let containerHeight = presentationMetrics.containerHeight

        return GeometryReader { proxy in
            let availableWidth = max(proxy.size.width, 1)
            let scale = min(1, availableWidth / previewWidth)

            NotificationStaticCardView(scenario: scenario)
                .scaleEffect(scale, anchor: .topLeading)
                .frame(
                    width: previewWidth * scale,
                    height: containerHeight * scale,
                    alignment: .topLeading
                )
        }
        .frame(height: min(160, presentationMetrics.containerHeight))
        .clipped()
    }

    private var backgroundFill: Color {
        evaluation.isWinner
            ? Color.white.opacity(0.07)
            : Color.white.opacity(0.035)
    }

    private var borderColor: Color {
        evaluation.isWinner
            ? Color(red: 0.96, green: 0.90, blue: 0.72).opacity(0.52)
            : Color.white.opacity(0.08)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}
