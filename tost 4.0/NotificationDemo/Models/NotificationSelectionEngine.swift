import Foundation

enum NotificationSelectionEngine {
    nonisolated static func selectWinner(from candidates: [NotificationCandidate]) -> NotificationSelectionResult {
        let winner = resolveWinner(from: candidates)
        let orderedCandidates = displayOrderedCandidates(from: candidates, winner: winner)
        let evaluations = orderedCandidates.enumerated().map { index, candidate in
            NotificationCandidateEvaluation(
                id: candidate.id,
                candidate: candidate,
                isWinner: candidate.id == winner?.id,
                displayRank: index + 1,
                resolutionReason: resolutionReason(for: candidate, winner: winner)
            )
        }

        return NotificationSelectionResult(
            winner: winner,
            evaluations: evaluations,
            explanation: buildExplanation(candidates: candidates, winner: winner)
        )
    }

    nonisolated private static func resolveWinner(from candidates: [NotificationCandidate]) -> NotificationCandidate? {
        let stackCandidates = candidates
            .filter { $0.source == .stackEvent }
            .sorted(by: stackSort)
        if let winner = stackCandidates.first {
            return winner
        }

        let pushCandidates = candidates
            .filter { $0.source == .criticalPush && $0.isUnread }
            .sorted(by: pushSort)
        if let winner = pushCandidates.first {
            return winner
        }

        let inAppCandidates = candidates
            .filter { $0.source == .inApp }
            .sorted(by: inAppSort)
        return inAppCandidates.first
    }

    nonisolated private static func displayOrderedCandidates(
        from candidates: [NotificationCandidate],
        winner: NotificationCandidate?
    ) -> [NotificationCandidate] {
        candidates.sorted { lhs, rhs in
            if lhs.id == winner?.id { return true }
            if rhs.id == winner?.id { return false }
            if lhs.source.priorityOrder != rhs.source.priorityOrder {
                return lhs.source.priorityOrder < rhs.source.priorityOrder
            }

            switch lhs.source {
            case .stackEvent:
                return stackSort(lhs, rhs)
            case .criticalPush:
                return pushSort(lhs, rhs)
            case .inApp:
                return inAppSort(lhs, rhs)
            }
        }
    }

    nonisolated private static func stackSort(_ lhs: NotificationCandidate, _ rhs: NotificationCandidate) -> Bool {
        let lhsPriority = lhs.productPriority ?? .max
        let rhsPriority = rhs.productPriority ?? .max
        if lhsPriority != rhsPriority {
            return lhsPriority < rhsPriority
        }
        return lhs.sourceLabel < rhs.sourceLabel
    }

    nonisolated private static func pushSort(_ lhs: NotificationCandidate, _ rhs: NotificationCandidate) -> Bool {
        if lhs.isUnread != rhs.isUnread {
            return lhs.isUnread && !rhs.isUnread
        }
        let lhsDate = lhs.createdAt ?? .distantPast
        let rhsDate = rhs.createdAt ?? .distantPast
        if lhsDate != rhsDate {
            return lhsDate > rhsDate
        }
        return lhs.sourceLabel < rhs.sourceLabel
    }

    nonisolated private static func inAppSort(_ lhs: NotificationCandidate, _ rhs: NotificationCandidate) -> Bool {
        let lhsScore = lhs.rtbScore ?? 0
        let rhsScore = rhs.rtbScore ?? 0
        if lhsScore != rhsScore {
            return lhsScore > rhsScore
        }
        let lhsRank = lhs.rtbRank ?? .max
        let rhsRank = rhs.rtbRank ?? .max
        if lhsRank != rhsRank {
            return lhsRank < rhsRank
        }
        return lhs.sourceLabel < rhs.sourceLabel
    }

    nonisolated private static func resolutionReason(
        for candidate: NotificationCandidate,
        winner: NotificationCandidate?
    ) -> String {
        guard let winner else {
            return "Ни один кандидат не подошел под текущие правила выбора."
        }

        if candidate.id == winner.id {
            switch candidate.source {
            case .stackEvent:
                return "Победитель: событие стека с наивысшим приоритетом по mock-порядку продуктов."
            case .criticalPush:
                return "Победитель: самый свежий непрочитанный критичный push."
            case .inApp:
                return "Победитель: лучший mock RTB score среди in-app кандидатов."
            }
        }

        if candidate.source.priorityOrder > winner.source.priorityOrder {
            return "Не выбран: источник ниже по приоритету, чем у победителя."
        }

        switch candidate.source {
        case .stackEvent:
            return "Не выбран: другое событие стека выше по внутреннему приоритету продукта."
        case .criticalPush:
            return candidate.isUnread
                ? "Не выбран: другой непрочитанный критичный push свежее."
                : "Не выбран: прочитанный push проигрывает непрочитанным кандидатам."
        case .inApp:
            return "Не выбран: у другого in-app кандидата лучше RTB score."
        }
    }

    nonisolated private static func buildExplanation(
        candidates: [NotificationCandidate],
        winner: NotificationCandidate?
    ) -> NotificationSelectionExplanation {
        guard let winner else {
            return NotificationSelectionExplanation(
                title: "Результат выбора",
                summary: "Победителя определить не удалось.",
                bullets: [
                    "Добавьте хотя бы одного активного кандидата, чтобы увидеть итоговый результат."
                ]
            )
        }

        var bullets = [
            "Порядок приоритета: событие стека > критичный push > in-app.",
            "На Home уходит только итоговый победитель. Multiple-режим нужен только для demo/debug и показывает ту же логику выбора в развернутом виде."
        ]

        if candidates.contains(where: { $0.source == .stackEvent }) &&
            candidates.contains(where: { $0.source == .criticalPush }) {
            bullets.append("Событие стека выше критичного push, потому что отражает актуальный статус из бэкенда и продолжает обновляться после показа.")
            bullets.append("Push одноразовый и может устареть: пользователь мог уже выполнить целевое действие, а текст push останется прежним.")
            bullets.append("Событие стека является точкой входа на продуктовую страницу, а дублирующий push в In-app 4.0 скорее работает как напоминание.")
        }

        switch winner.source {
        case .stackEvent:
            bullets.append("Внутри стека победитель выбирается по mock-приоритету продуктов.")
        case .criticalPush:
            bullets.append("Внутри критичных push победителем становится самый свежий непрочитанный по дате создания.")
        case .inApp:
            bullets.append("Внутри in-app победитель выбирается по mock RTB score и rank.")
        }

        return NotificationSelectionExplanation(
            title: "Почему выбран именно этот кандидат",
            summary: summary(for: winner),
            bullets: bullets
        )
    }

    nonisolated private static func summary(for winner: NotificationCandidate) -> String {
        switch winner.source {
        case .stackEvent:
            return "Событие стека побеждает, потому что несет самый актуальный продуктовый статус."
        case .criticalPush:
            return "Критичный push побеждает, потому что активного события стека нет, а по приоритету он выше in-app."
        case .inApp:
            return "In-app побеждает, потому что нет активного события стека и нет критичного push более высокого приоритета."
        }
    }
}
