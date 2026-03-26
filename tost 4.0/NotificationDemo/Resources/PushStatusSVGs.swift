import Foundation

let pushInfoSVG = loadPushStatusSVG(named: "push-info")
let pushCriticalInfoSVG = loadPushStatusSVG(named: "push-critical-info")

private func loadPushStatusSVG(named name: String) -> String {
    normalizePushForegroundStyle(
        loadNotificationSVG(named: name, from: .pushStatus)
    )
}

private func normalizePushForegroundStyle(_ svg: String) -> String {
    svg
        .replacingOccurrences(of: "fill=\"#333333\"", with: "fill=\"#F6F7F8\"")
        .replacingOccurrences(of: "stop-color=\"#333333\"", with: "stop-color=\"#F6F7F8\"")
}
