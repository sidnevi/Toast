import Foundation

enum NotificationKind: String, CaseIterable, Identifiable, Hashable {
    case inApp
    case push
    case event

    var id: String { rawValue }
}
