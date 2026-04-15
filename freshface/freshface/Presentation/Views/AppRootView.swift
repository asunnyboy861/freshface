import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showFeatureHighlight = false
    @StateObject private var highlightsManager = FeatureHighlightsManager.shared

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: AppCoordinator.AppTab.home.icon)
                }
                .tag(AppCoordinator.AppTab.home)
                .onChange(of: coordinator.selectedTab) { _, newTab in
                    checkForHighlight(tab: newTab)
                }

            ProductListView()
                .tabItem {
                    Label("Products", systemImage: AppCoordinator.AppTab.products.icon)
                }
                .tag(AppCoordinator.AppTab.products)

            RoutineListView()
                .tabItem {
                    Label("Routine", systemImage: AppCoordinator.AppTab.routine.icon)
                }
                .tag(AppCoordinator.AppTab.routine)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: AppCoordinator.AppTab.analytics.icon)
                }
                .tag(AppCoordinator.AppTab.analytics)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: AppCoordinator.AppTab.settings.icon)
                }
                .tag(AppCoordinator.AppTab.settings)
        }
        .tint(Color(hex: "FF6B9D"))
        .overlay {
            if showFeatureHighlight {
                FeatureHighlightOverlay(
                    tab: coordinator.selectedTab,
                    isShowing: $showFeatureHighlight
                )
            }
        }
    }

    private func checkForHighlight(tab: AppCoordinator.AppTab) {
        if highlightsManager.shouldShowHighlight(for: tab) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showFeatureHighlight = true
                }
            }
        }
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppCoordinator())
}
