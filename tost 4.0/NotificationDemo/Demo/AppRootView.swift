import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            NotificationDemoView()
                .tabItem {
                    Label("Demo", systemImage: "square.grid.2x2.fill")
                }
        }
    }
}
