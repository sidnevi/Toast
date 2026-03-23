import SwiftUI

struct AppRootView: View {
    @StateObject private var demoHomeBridge = NotificationDemoHomeBridge()
    @State private var selectedTab: AppRootTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView(
                demoHomeBridge: demoHomeBridge,
                activeTab: selectedTab
            )
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppRootTab.home)

            NotificationDemoView(homeBridge: demoHomeBridge)
                .tabItem {
                    Label("Demo", systemImage: "square.grid.2x2.fill")
                }
                .tag(AppRootTab.demo)
        }
    }
}
