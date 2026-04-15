import SwiftUI

@main
struct FreshFaceApp: App {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("useSystemAppearance") private var useSystemAppearance = true
    @StateObject private var appCoordinator = AppCoordinator()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                AppRootView()
                    .environmentObject(appCoordinator)
                    .preferredColorScheme(colorScheme)
            } else {
                OnboardingView(hasCompleted: $hasCompletedOnboarding)
                    .preferredColorScheme(colorScheme)
            }
        }
    }

    private var colorScheme: ColorScheme? {
        if useSystemAppearance {
            return nil
        }
        return darkModeEnabled ? .dark : .light
    }
}
