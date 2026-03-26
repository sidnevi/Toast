import Foundation
import UIKit

enum NotificationResourceFolder: String {
    case eventStatus = "EventStatus"
    case homeAssets = "HomeAssets"
    case notificationCenterAssets = "NotificationCenterAssets"
    case pushStatus = "PushStatus"
}

func loadNotificationSVG(
    named name: String,
    from folder: NotificationResourceFolder
) -> String {
    guard let svgURL = notificationResourceURL(named: name, ext: "svg", from: folder) else {
        return ""
    }
    return (try? String(contentsOf: svgURL, encoding: .utf8)) ?? ""
}

func loadNotificationImage(
    named name: String,
    from folder: NotificationResourceFolder,
    ext: String = "png"
) -> UIImage? {
    guard let imageURL = notificationResourceURL(named: name, ext: ext, from: folder) else {
        return nil
    }
    return UIImage(contentsOfFile: imageURL.path)
}

private let notificationResourcesSourceBaseURL = resolveNotificationResourcesSourceBaseURL()

private func notificationResourceURL(
    named name: String,
    ext: String,
    from folder: NotificationResourceFolder
) -> URL? {
    let bundleCandidates: [URL?] = [
        Bundle.main.url(
            forResource: name,
            withExtension: ext,
            subdirectory: "Resources/Notifications/\(folder.rawValue)"
        ),
        Bundle.main.url(
            forResource: name,
            withExtension: ext,
            subdirectory: "Notifications/\(folder.rawValue)"
        ),
        Bundle.main.url(forResource: name, withExtension: ext)
    ]

    for candidate in bundleCandidates {
        if let candidate {
            return candidate
        }
    }

    let sourceURL = notificationResourcesSourceBaseURL
        .appendingPathComponent(folder.rawValue, isDirectory: true)
        .appendingPathComponent("\(name).\(ext)")

    return FileManager.default.fileExists(atPath: sourceURL.path) ? sourceURL : nil
}

private func resolveNotificationResourcesSourceBaseURL() -> URL {
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
