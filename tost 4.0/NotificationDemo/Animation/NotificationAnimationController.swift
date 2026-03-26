import Combine
import SwiftUI

@MainActor
final class NotificationAnimationController: ObservableObject {
    @Published var isPresented = false
    @Published var showsSourceBell = true
    @Published var isSourceBellFilled = false
    @Published var isSourceBellCritical = false

    func setShowsSourceBell(_ showsSourceBell: Bool) {
        self.showsSourceBell = showsSourceBell
    }

    func setSourceBellFilled(_ isFilled: Bool, isCritical: Bool = false) {
        isSourceBellFilled = isFilled
        isSourceBellCritical = isFilled && isCritical
    }

    func present() {
        guard !isPresented else { return }
        isSourceBellFilled = false
        isSourceBellCritical = false
        isPresented = true
    }

    func dismiss() {
        isPresented = false
    }

    func reset(
        showsSourceBell: Bool = true,
        isSourceBellFilled: Bool = false,
        isSourceBellCritical: Bool = false
    ) {
        isPresented = false
        self.showsSourceBell = showsSourceBell
        self.isSourceBellFilled = isSourceBellFilled
        self.isSourceBellCritical = isSourceBellFilled && isSourceBellCritical
    }
}
