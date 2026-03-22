import Combine
import SwiftUI

@MainActor
final class NotificationAnimationController: ObservableObject {
    @Published var isPresented = false
    @Published var showsSourceBell = true

    func setShowsSourceBell(_ showsSourceBell: Bool) {
        self.showsSourceBell = showsSourceBell
    }

    func present() {
        guard !isPresented else { return }
        isPresented = true
    }

    func dismiss() {
        isPresented = false
    }

    func reset(showsSourceBell: Bool = true) {
        isPresented = false
        self.showsSourceBell = showsSourceBell
    }
}
