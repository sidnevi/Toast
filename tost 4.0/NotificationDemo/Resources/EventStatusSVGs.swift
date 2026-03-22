import Foundation

let eventLongRunningSVG = loadEventStatusSVG(named: "event-long-running")
let eventErrorAlertSVG = loadEventStatusSVG(named: "event-error-alert")
let eventErrorSVG = loadEventStatusSVG(named: "event-error")
let eventSuccessSVG = loadEventStatusSVG(named: "event-success")
let eventActionRequiredSVG = loadEventStatusSVG(named: "event-action-required")
let eventPendingSVG = loadEventStatusSVG(named: "event-pending")

private func loadEventStatusSVG(named name: String) -> String {
    loadNotificationSVG(named: name, from: .eventStatus)
}
