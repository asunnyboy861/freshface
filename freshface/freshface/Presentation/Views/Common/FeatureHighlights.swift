import SwiftUI

class FeatureHighlightsManager: ObservableObject {
    static let shared = FeatureHighlightsManager()

    private enum StorageKey: String {
        case home = "ff_highlight_home"
        case products = "ff_highlight_products"
        case routine = "ff_highlight_routine"
        case analytics = "ff_highlight_analytics"
        case settings = "ff_highlight_settings"
    }

    @Published private(set) var hasSeenHomeHighlight: Bool = false
    @Published private(set) var hasSeenProductsHighlight: Bool = false
    @Published private(set) var hasSeenRoutineHighlight: Bool = false
    @Published private(set) var hasSeenAnalyticsHighlight: Bool = false
    @Published private(set) var hasSeenSettingsHighlight: Bool = false

    private init() {
        loadPersistedStates()
    }

    private func loadPersistedStates() {
        hasSeenHomeHighlight = UserDefaults.standard.bool(forKey: StorageKey.home.rawValue)
        hasSeenProductsHighlight = UserDefaults.standard.bool(forKey: StorageKey.products.rawValue)
        hasSeenRoutineHighlight = UserDefaults.standard.bool(forKey: StorageKey.routine.rawValue)
        hasSeenAnalyticsHighlight = UserDefaults.standard.bool(forKey: StorageKey.analytics.rawValue)
        hasSeenSettingsHighlight = UserDefaults.standard.bool(forKey: StorageKey.settings.rawValue)
    }

    private func persistState(_ value: Bool, for key: StorageKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    func shouldShowHighlight(for tab: AppCoordinator.AppTab) -> Bool {
        switch tab {
        case .home:
            return !hasSeenHomeHighlight
        case .products:
            return !hasSeenProductsHighlight
        case .routine:
            return !hasSeenRoutineHighlight
        case .analytics:
            return !hasSeenAnalyticsHighlight
        case .settings:
            return !hasSeenSettingsHighlight
        }
    }

    func markAsSeen(tab: AppCoordinator.AppTab) {
        switch tab {
        case .home:
            hasSeenHomeHighlight = true
            persistState(true, for: .home)
        case .products:
            hasSeenProductsHighlight = true
            persistState(true, for: .products)
        case .routine:
            hasSeenRoutineHighlight = true
            persistState(true, for: .routine)
        case .analytics:
            hasSeenAnalyticsHighlight = true
            persistState(true, for: .analytics)
        case .settings:
            hasSeenSettingsHighlight = true
            persistState(true, for: .settings)
        }
    }

    func resetAll() {
        let allKeys: [StorageKey] = [.home, .products, .routine, .analytics, .settings]

        hasSeenHomeHighlight = false
        hasSeenProductsHighlight = false
        hasSeenRoutineHighlight = false
        hasSeenAnalyticsHighlight = false
        hasSeenSettingsHighlight = false

        allKeys.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}

struct FeatureHighlightOverlay: View {
    let tab: AppCoordinator.AppTab
    @Binding var isShowing: Bool
    @StateObject private var highlightsManager = FeatureHighlightsManager.shared

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { isShowing = false } }

            VStack(spacing: 24) {
                Spacer()

                highlightContent

                actionButtons

                Spacer()
                    .frame(height: 50)
            }
        }
        .transition(.opacity.combined(with: .scale))
        .onAppear {
            if isShowing {
                highlightsManager.markAsSeen(tab: tab)
            }
        }
    }

    private var highlightContent: some View {
        VStack(spacing: 20) {
            Image(systemName: tab.icon)
                .font(.system(size: 64))
                .foregroundColor(Color(hex: "FF6B9D"))

            VStack(spacing: 8) {
                Text(highlightTitle)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(highlightDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            featureTips
        }
        .padding(32)
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(radius: 30)
    }

    private var highlightTitle: String {
        switch tab {
        case .home:
            return "Welcome to Your Dashboard"
        case .products:
            return "Manage Your Products"
        case .routine:
            return "Track Your Routine"
        case .analytics:
            return "Insights & Analytics"
        case .settings:
            return "Customize Your Experience"
        }
    }

    private var highlightDescription: String {
        switch tab {
        case .home:
            return "Your home dashboard gives you a quick overview of expiring products and key statistics at a glance."
        case .products:
            return "Add, organize, and track all your skincare products. Use barcode scanning for quick entry!"
        case .routine:
            return "Create morning and evening skincare routines with step-by-step guidance."
        case .analytics:
            return "Understand your skincare patterns with detailed analytics and personalized insights."
        case .settings:
            return "Customize your experience with optional iCloud sync, notifications, appearance, and data management."
        }
    }

    private var featureTips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Tips")
                .font(.headline)

            ForEach(getTipsForTab(), id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "34C759"))
                        .font(.caption)

                    Text(tip)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private func getTipsForTab() -> [String] {
        switch tab {
        case .home:
            return [
                "Check 'Expiring Soon' section daily",
                "Tap product cards for details",
                "Use quick stats to monitor inventory"
            ]
        case .products:
            return [
                "Scan barcodes for fast entry",
                "Use filters to find products quickly",
                "Switch between grid/list view"
            ]
        case .routine:
            return [
                "Order steps by application sequence",
                "Assign specific products to each step",
                "Track completion daily"
            ]
        case .analytics:
            return [
                "Review risk distribution weekly",
                "Check category balance",
                "Follow personalized insights"
            ]
        case .settings:
            return [
                "Enable iCloud sync for backup",
                "Set up expiry notifications",
                "Export data regularly"
            ]
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation { isShowing = false }
            }) {
                Text("Explore")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "FF6B9D"))
                    .cornerRadius(12)
            }

            Button(action: {
                FeatureHighlightsManager.shared.resetAll()
                withAnimation { isShowing = false }
            }) {
                Text("Reset All Tips")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 32)
    }
}

struct ContextualTooltip: View {
    let text: String
    let position: TooltipPosition
    @Binding var isShowing: Bool

    enum TooltipPosition {
        case top
        case bottom
        case leading
        case trailing
    }

    var body: some View {
        ZStack {
            if position == .top || position == .bottom {
                VStack(spacing: 0) {
                    if position == .top { arrowDown }
                    tooltipContent
                    if position == .bottom { arrowUp }
                }
            } else {
                HStack(spacing: 0) {
                    if position == .leading { arrowRight }
                    tooltipContent
                    if position == .trailing { arrowLeft }
                }
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8, anchor: position == .top ? .bottom : .top)))
    }

    private var tooltipContent: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(hex: "2C2C2E"))
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
    }

    private var arrowDown: some View {
        Triangle()
            .fill(Color(hex: "2C2C2E"))
            .frame(width: 12, height: 6)
            .rotationEffect(.degrees(180))
    }

    private var arrowUp: some View {
        Triangle()
            .fill(Color(hex: "2C2C2E"))
            .frame(width: 12, height: 6)
    }

    private var arrowRight: some View {
        Triangle()
            .fill(Color(hex: "2C2C2E"))
            .frame(width: 6, height: 12)
            .rotationEffect(.degrees(-90))
    }

    private var arrowLeft: some View {
        Triangle()
            .fill(Color(hex: "2C2C2E"))
            .frame(width: 6, height: 12)
            .rotationEffect(.degrees(90))
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct InteractiveTutorialView: View {
    let tutorialSteps: [TutorialStep]
    @Binding var currentStep: Int
    @Binding var isShowing: Bool
    var onComplete: () -> Void = {}

    struct TutorialStep: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let iconName: String
        let targetViewId: String?
        let actionTitle: String?
        var action: (() -> Void)?
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if currentStep < tutorialSteps.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        } else {
                            onComplete()
                            withAnimation { isShowing = false }
                        }
                    }

                if currentStep < tutorialSteps.count {
                    let step = tutorialSteps[currentStep]
                    let position = calculatePosition(for: step, in: geometry)

                    VStack(spacing: 16) {
                        Image(systemName: step.iconName)
                            .font(.system(size: 48))
                            .foregroundColor(Color(hex: "FF6B9D"))

                        VStack(spacing: 8) {
                            Text(step.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)

                            Text(step.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        if let actionTitle = step.actionTitle, let action = step.action {
                            Button(action: action) {
                                Text(actionTitle)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(Color(hex: "FF6B9D"))
                                    .cornerRadius(8)
                            }
                        }

                        stepIndicator

                        navigationButtons
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .position(position)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
        }
    }

    private func calculatePosition(for step: TutorialStep, in geometry: GeometryProxy) -> CGPoint {
        CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
    }

    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<tutorialSteps.count, id: \.self) { index in
                Circle()
                    .fill(index == currentStep ? Color(hex: "FF6B9D") : Color.gray.opacity(0.3))
                    .frame(width: index == currentStep ? 10 : 8,
                           height: index == currentStep ? 10 : 8)
                    .animation(.easeInOut(duration: 0.2), value: currentStep)
            }
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentStep > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep -= 1
                    }
                }) {
                    Text("Back")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("\(currentStep + 1) of \(tutorialSteps.count)")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            if currentStep < tutorialSteps.count - 1 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentStep += 1
                    }
                }) {
                    Text("Next")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color(hex: "FF6B9D"))
                }
            } else {
                Button(action: {
                    onComplete()
                    withAnimation { isShowing = false }
                }) {
                    Text("Get Started!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color(hex: "FF6B9D"))
                }
            }
        }
        .padding(.horizontal)
    }
}
