import Foundation

let eventLongRunningSVG = loadEventStatusSVG(named: "event-long-running")
let eventErrorAlertSVG = loadEventStatusSVG(named: "event-error-alert")
let eventErrorSVG = loadEventStatusSVG(named: "event-error")
let eventSuccessSVG = loadEventStatusSVG(named: "event-success")
let eventActionRequiredSVG = loadEventStatusSVG(named: "event-action-required")
let eventPendingSVG = loadEventStatusSVG(named: "event-pending")

private func loadEventStatusSVG(named name: String) -> String {
    removeEventGlassEffects(
        loadNotificationSVG(named: name, from: .eventStatus)
    )
}

private func removeEventGlassEffects(_ svg: String) -> String {
    svg
        .replacingOccurrences(
            of: #"<rect width="351" height="74" rx="32" fill="[^"]+" fill-opacity="[^"]+"/>[\s\n]*"#,
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: #"<circle cx="251" cy="38" r="176" fill="url\(#paint0_radial_[^)]*\)" fill-opacity="[^"]+"/>[\s\n]*"#,
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: #"<rect x="0\.5" y="0\.5" width="350" height="73" rx="31\.5" stroke="white" stroke-opacity="0\.1"/>"#,
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: #"<rect width="351" height="74" fill="black" fill-opacity="0.01"/>"#,
            with: ""
        )
        .replacingOccurrences(
            of: #"<foreignObject[^>]*>.*?</foreignObject>"#,
            with: "",
            options: .regularExpression
        )
        .replacingOccurrences(
            of: #" data-figma-bg-blur-radius="10""#,
            with: ""
        )
        .replacingOccurrences(
            of: #"<clipPath id="bgblur_[^"]+"[^>]*>[\s\S]*?</clipPath>"#,
            with: "",
            options: .regularExpression
        )
}
