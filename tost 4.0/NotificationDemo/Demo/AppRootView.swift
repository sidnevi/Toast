import SwiftUI

struct AppRootView: View {
    @StateObject private var demoHomeBridge = NotificationDemoHomeBridge()
    @State private var selectedTab: AppRootTab = .home
    @State private var showsNotificationCenter = false

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                ContentView(
                    demoHomeBridge: demoHomeBridge,
                    activeTab: selectedTab,
                    onOpenNotificationCenter: {
                        withAnimation(.easeInOut(duration: 0.22)) {
                            showsNotificationCenter = true
                        }
                    }
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

            if showsNotificationCenter {
                NotificationCenterView(layoutMode: demoHomeBridge.notificationCenterLayoutMode) {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        showsNotificationCenter = false
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
}
