import SwiftUI

struct NotificationMultiplePreviewSection: View {
    let selectionResult: NotificationSelectionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Кандидаты")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)

            ForEach(selectionResult.evaluations) { evaluation in
                if let scenario = NotificationScenarioCatalog.scenario(id: evaluation.candidate.scenarioID) {
                    NotificationCandidateCardView(
                        evaluation: evaluation,
                        scenario: scenario
                    )
                }
            }

            NotificationSelectionSummaryView(explanation: selectionResult.explanation)
        }
    }
}
