import Foundation

enum NotificationPreviewMode: String, CaseIterable, Identifiable, Hashable {
    case isolated
    case homeContext

    var id: String { rawValue }
}
