import Foundation

enum NotificationDisplayMode: String, CaseIterable, Identifiable, Hashable {
    case single
    case multiple

    var id: String { rawValue }

    var title: String {
        switch self {
        case .single:
            return "Single"
        case .multiple:
            return "Multiple"
        }
    }
}
