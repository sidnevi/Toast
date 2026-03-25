import SwiftUI

struct NotificationBellVisual: View {
    let size: CGFloat

    var body: some View {
        InlineSVGWebView(svg: notificationBellSVG)
            .frame(width: size, height: size)
    }
}

struct NotificationBellGlyphVisual: View {
    let size: CGFloat

    var body: some View {
        InlineSVGWebView(svg: notificationBellGlyphSVG)
            .frame(width: size, height: size)
    }
}

struct NotificationBellBubbleVisual: View {
    let size: CGFloat

    var body: some View {
        InlineSVGWebView(svg: notificationBellBubbleSVG)
            .frame(width: size, height: size)
    }
}

private let notificationBellSVG = loadHomeSVG(named: "bell")

private let notificationBellBubbleSVG = #"""
<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="40" height="40" rx="20" fill="white" fill-opacity="0.1"/>
</svg>
"""#

private let notificationBellGlyphSVG = #"""
<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
<mask id="mask0_2185_63748" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="10" y="10" width="20" height="20">
<path opacity="0.5" d="M16.5 27H23.5C23.5 28.6569 22.1569 30 20.5 30H19.5C17.8431 30 16.5 28.6569 16.5 27Z" fill="black"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M20.5 13.1H19.5C17.0699 13.1 15.1 15.0699 15.1 17.5V22.2181C15.1 22.9656 14.9731 23.7029 14.7289 24.4H25.2711C25.0269 23.7029 24.9 22.9656 24.9 22.2181V17.5C24.9 15.0699 22.9301 13.1 20.5 13.1ZM28.1475 24.4C27.7256 23.7518 27.5 22.994 27.5 22.2181V17.5C27.5 13.634 24.366 10.5 20.5 10.5H19.5C15.634 10.5 12.5 13.634 12.5 17.5V22.2181C12.5 22.994 12.2744 23.7518 11.8525 24.4C11.8211 24.4483 11.7886 24.496 11.7549 24.5431L10 27H30L28.2451 24.5431C28.2114 24.496 28.1789 24.4483 28.1475 24.4Z" fill="url(#paint0_linear_2185_63748)"/>
</mask>
<g mask="url(#mask0_2185_63748)">
<path d="M8 8H32V32H8V8Z" fill="white"/>
</g>
<defs>
<linearGradient id="paint0_linear_2185_63748" x1="23.9583" y1="20.6667" x2="17.6673" y2="5.56058" gradientUnits="userSpaceOnUse">
<stop/>
<stop offset="1" stop-opacity="0.6"/>
</linearGradient>
</defs>
</svg>
"""#
