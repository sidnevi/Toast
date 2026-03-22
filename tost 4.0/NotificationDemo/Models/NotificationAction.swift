import Foundation

struct NotificationAction: Identifiable, Hashable {
    enum Style: Hashable {
        case primary
        case secondary
    }

    let id: String
    let title: String
    let style: Style
    var isEnabled = true
}
