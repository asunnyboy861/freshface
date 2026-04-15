import SwiftUI

struct EnhancedEmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String
    var primaryActionTitle: String?
    var primaryAction: (() -> Void)?
    var secondaryActionTitle: String?
    var secondaryAction: (() -> Void)?
    var showTip: Bool = false
    var tipText: String?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundColor(.secondary.opacity(0.5))

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2.bold())

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            if let tipText, showTip {
                TipBubbleView(text: tipText)
            }

            Spacer()

            actionButtons
        }
        .padding()
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if let primaryActionTitle, let primaryAction {
                Button(action: primaryAction) {
                    Text(primaryActionTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FF6B9D"))
                        .cornerRadius(12)
                }
            }

            if let secondaryActionTitle, let secondaryAction {
                Button(action: secondaryAction) {
                    Text(secondaryActionTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "FF6B9D"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FF6B9D").opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct TipBubbleView: View {
    let text: String
    @State private var isExpanded = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(Color(hex: "FFD60A"))

            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Button(action: { withAnimation { isExpanded.toggle() } }) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(hex: "FFF9E6"))
        .cornerRadius(12)
    }
}

struct ContextualHelpView: View {
    let title: String
    let steps: [String]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("How it works")) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Color(hex: "FF6B9D"))
                                .clipShape(Circle())

                            Text(step)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section(header: Text("Tips")) {
                    tipsSection
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var tipsSection: some View {
        switch title {
        case "Adding Products":
            return AnyView(productTips)
        case "Creating Routines":
            return AnyView(routineTips)
        case "Understanding Analytics":
            return AnyView(analyticsTips)
        default:
            return AnyView(generalTips)
        }
    }

    private var productTips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Scan barcodes for quick entry", systemImage: "barcode.viewfinder")
            Label("Take photos to track product appearance", systemImage: "camera")
            Label("Set PAO (Period After Opening) for accuracy", systemImage: "clock")
            Label("Categorize products for better organization", systemImage: "folder")
        }
        .font(.subheadline)
    }

    private var routineTips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Create separate morning/evening routines", systemImage: "sunrise")
            Label("Add products in order of application", systemImage: "list.number")
            Label("Include timing for each step", systemImage: "timer")
            Label("Track your daily consistency", systemImage: "chart.line.uptrend.xyaxis")
        }
        .font(.subheadline)
    }

    private var analyticsTips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Check expiration risk regularly", systemImage: "exclamationmark.triangle")
            Label("Monitor category distribution", systemImage: "piechart")
            Label("Review spending patterns", systemImage: "dollarsign.circle")
            Label("Use insights to optimize your routine", systemImage: "lightbulb")
        }
        .font(.subheadline)
    }

    private var generalTips: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Enable iCloud sync for backup (optional)", systemImage: "icloud")
            Label("Set up notifications for reminders", systemImage: "bell")
            Label("Export data regularly for safety", systemImage: "square.and.arrow.up")
            Label("Keep your inventory updated", systemImage: "checkmark.circle")
        }
        .font(.subheadline)
    }
}

struct FeatureDiscoveryBadge: View {
    let featureName: String
    let description: String
    let iconName: String
    var onTap: () -> Void = {}
    @State private var isShowingDetail = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(Color(hex: "FF6B9D"))
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(featureName)
                        .font(.headline)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .sheet(isPresented: $isShowingDetail) {
            ContextualHelpView(
                title: featureName,
                steps: getStepsForFeature(featureName)
            )
        }
    }

    private func getStepsForFeature(_ feature: String) -> [String] {
        switch feature {
        case "Barcode Scanner":
            return [
                "Tap the '+' button on Products tab",
                "Select 'Scan Barcode' option",
                "Point camera at product barcode",
                "Auto-fill product information",
                "Verify and save the product"
            ]
        case "Skincare Routines":
            return [
                "Go to Routine tab",
                "Tap '+' to create new routine",
                "Choose morning or evening routine",
                "Add skincare steps in order",
                "Assign products to each step"
            ]
        case "Expiry Analytics":
            return [
                "Navigate to Analytics tab",
                "View overview statistics",
                "Check risk distribution chart",
                "Read personalized insights",
                "Get recommendations"
            ]
        default:
            return [
                "Explore this feature",
                "Learn how it works",
                "Start using it today"
            ]
        }
    }
}

struct FirstTimeUserGuide: View {
    let features: [GuideFeature]
    @AppStorage("hasCompletedFirstTimeGuide") var hasCompletedGuide = false
    @Environment(\.dismiss) var dismiss

    struct GuideFeature: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        let icon: String
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    LazyVStack(spacing: 16) {
                        ForEach(features) { feature in
                            FeatureDiscoveryBadge(
                                featureName: feature.name,
                                description: feature.description,
                                iconName: feature.icon
                            )
                        }
                    }
                    .padding(.horizontal)

                    completionButton
                }
                .padding(.vertical)
            }
            .navigationTitle("Welcome to FreshFace")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        hasCompletedGuide = true
                        dismiss()
                    }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "FF6B9D"))

            VStack(spacing: 8) {
                Text("Discover Key Features")
                    .font(.title2.bold())

                Text("Learn how to make the most of FreshFace")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    private var completionButton: some View {
        Button(action: {
            hasCompletedGuide = true
            dismiss()
        }) {
            Text("I'm Ready to Start!")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
