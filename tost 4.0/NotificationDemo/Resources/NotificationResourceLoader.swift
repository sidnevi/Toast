import Foundation
import UIKit

enum NotificationResourceFolder: String {
    case eventStatus = "EventStatus"
    case homeAssets = "HomeAssets"
    case notificationCenterAssets = "NotificationCenterAssets"
}

func loadNotificationSVG(
    named name: String,
    from folder: NotificationResourceFolder
) -> String {
    let svgURL = notificationResourcesBaseURL
        .appendingPathComponent(folder.rawValue, isDirectory: true)
        .appendingPathComponent("\(name).svg")
    return (try? String(contentsOf: svgURL, encoding: .utf8)) ?? ""
}

func loadNotificationImage(
    named name: String,
    from folder: NotificationResourceFolder,
    ext: String = "png"
) -> UIImage? {
    let imageURL = notificationResourcesBaseURL
        .appendingPathComponent(folder.rawValue, isDirectory: true)
        .appendingPathComponent("\(name).\(ext)")
    return UIImage(contentsOfFile: imageURL.path)
}

private let notificationResourcesBaseURL = resolveNotificationResourcesBaseURL()

private func resolveNotificationResourcesBaseURL() -> URL {
    var currentDirectoryURL = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    let fileManager = FileManager.default

    for _ in 0..<6 {
        let candidateURL = currentDirectoryURL
            .appendingPathComponent("Resources/Notifications", isDirectory: true)

        if fileManager.fileExists(atPath: candidateURL.path) {
            return candidateURL
        }

        currentDirectoryURL.deleteLastPathComponent()
    }

    return URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources/Notifications", isDirectory: true)
}
