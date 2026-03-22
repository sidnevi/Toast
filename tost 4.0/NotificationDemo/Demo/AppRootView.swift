import SwiftUI

struct AppRootView: View {
    @StateObject private var notificationSelectionStore = NotificationSelectionStore()

    var body: some View {
        TabView {
            ContentView(notificationSelectionStore: notificationSelectionStore)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NotificationDemoView(notificationSelectionStore: notificationSelectionStore)
                .tabItem {
                    Label("Demo", systemImage: "square.grid.2x2.fill")
                }
        }
    }
}
