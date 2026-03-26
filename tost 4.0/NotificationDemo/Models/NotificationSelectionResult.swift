import Foundation

struct NotificationCandidateEvaluation: Identifiable, Hashable {
    let id: String
    let candidate: NotificationCandidate
    let isWinner: Bool
    let displayRank: Int
    let resolutionReason: String
}

struct NotificationSelectionResult: Hashable {
    let winner: NotificationCandidate?
    let evaluations: [NotificationCandidateEvaluation]
    let explanation: NotificationSelectionExplanation

    var winnerScenarioID: String? {
        winner?.scenarioID
    }
}
