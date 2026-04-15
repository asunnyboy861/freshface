import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var selectedCategory: HelpCategory?

    enum HelpCategory: String, CaseIterable, Identifiable {
        case gettingStarted = "Getting Started"
        case products = "Products"
        case routines = "Routines"
        case analytics = "Analytics"
        case sync = "Sync & Backup"
        case troubleshooting = "Troubleshooting"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .gettingStarted: return "play.circle.fill"
            case .products: return "cube.box.fill"
            case .routines: return "sunrise.fill"
            case .analytics: return "chart.bar.fill"
            case .sync: return "icloud"
            case .troubleshooting: return "wrench.fill"
            }
        }

        var color: String {
            switch self {
            case .gettingStarted: return "007AFF"
            case .products: return "FF6B9D"
            case .routines: return "FFD60A"
            case .analytics: return "7B68EE"
            case .sync: return "34C759"
            case .troubleshooting: return "FF3B30"
            }
        }

        var topics: [HelpTopic] {
            switch self {
            case .gettingStarted:
                return [
                    HelpTopic(
                        title: "Setting Up Your Account",
                        content: "FreshFace uses iCloud to securely store your data. Make sure you're signed into iCloud on your device to get started.",
                        steps: ["Open Settings app", "Tap your Apple ID", "Sign in to iCloud", "Enable iCloud Drive"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "First Time Setup",
                        content: "When you open FreshFace for the first time, you'll see a quick onboarding guide. This will walk you through the main features.",
                        steps: [],
                        relatedFeatures: ["Adding Products", "Creating Routines"]
                    ),
                    HelpTopic(
                        title: "Understanding the Interface",
                        content: "FreshFace has 5 main tabs: Home, Products, Routine, Analytics, and Settings. Each tab serves a specific purpose in managing your skincare routine.",
                        steps: [],
                        relatedFeatures: ["Home Dashboard", "Product Management"]
                    )
                ]
            case .products:
                return [
                    HelpTopic(
                        title: "Adding Products Manually",
                        content: "You can add products by entering details manually or scanning barcodes for automatic lookup.",
                        steps: ["Tap '+' button", "Enter product name, brand, category", "Add photo (optional)", "Set expiration date or PAO", "Save product"],
                        relatedFeatures: ["Barcode Scanner"]
                    ),
                    HelpTopic(
                        title: "Using Barcode Scanner",
                        content: "Scan product barcodes to automatically fill in product information from our database.",
                        steps: ["Tap 'Add Product'", "Select 'Scan Barcode'", "Point camera at barcode", "Verify auto-filled info", "Edit if needed and save"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Understanding PAO (Period After Opening)",
                        content: "PAO indicates how long a product is safe to use after opening. It's usually shown on packaging as a number inside an open jar icon (e.g., 12M = 12 months).",
                        steps: [],
                        relatedFeatures: ["Expiration Tracking"]
                    ),
                    HelpTopic(
                        title: "Organizing with Categories",
                        content: "Use categories to organize your products: Cleanser, Toner, Serum, Moisturizer, Sunscreen, Mask, Eye Care, Lip Care, Other.",
                        steps: [],
                        relatedFeatures: []
                    )
                ]
            case .routines:
                return [
                    HelpTopic(
                        title: "Creating Morning Routine",
                        content: "Create a step-by-step morning skincare routine to track daily consistency.",
                        steps: ["Go to Routine tab", "Tap '+', select 'Morning'", "Add steps (Cleanser → Toner → Serum → Moisturizer → Sunscreen)", "Assign products to each step", "Save routine"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Creating Evening Routine",
                        content: "Your evening routine may differ from morning - typically includes double cleansing and heavier treatments.",
                        steps: ["Go to Routine tab", "Tap '+', select 'Evening'", "Add evening-specific steps", "Assign appropriate products", "Set optional timing"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Tracking Routine Completion",
                        content: "Mark routines as complete each day to build consistency habits and track your skincare adherence.",
                        steps: [],
                        relatedFeatures: ["Analytics"]
                    )
                ]
            case .analytics:
                return [
                    HelpTopic(
                        title: "Overview Statistics",
                        content: "Get a quick snapshot of your skincare inventory including total products, expiring items, and risk levels.",
                        steps: [],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Category Breakdown",
                        content: "See how your products are distributed across categories to identify gaps in your routine.",
                        steps: [],
                        relatedFeatures: ["Product Categories"]
                    ),
                    HelpTopic(
                        title: "Risk Distribution",
                        content: "Understand which products need immediate attention based on expiration status.",
                        steps: ["Green = Safe (>6 months)", "Yellow = Warning (3-6 months)", "Orange = Urgent (<3 months)", "Red = Expired"],
                        relatedFeatures: ["Expiration Tracking"]
                    ),
                    HelpTopic(
                        title: "Personalized Insights",
                        content: "Receive AI-powered recommendations based on your product data and usage patterns.",
                        steps: [],
                        relatedFeatures: []
                    )
                ]
            case .sync:
                return [
                    HelpTopic(
                        title: "iCloud Sync Setup",
                        content: "Enable iCloud sync to backup your data and access it across all your Apple devices.",
                        steps: ["Ensure iCloud is signed in", "Go to Settings > iCloud", "Toggle iCloud Drive ON", "FreshFace auto-syncs"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Data Backup",
                        content: "Your data is automatically backed up to iCloud. You can also export data manually for extra safety.",
                        steps: ["Go to Settings", "Scroll to Data Management", "Tap 'Export Data'", "Choose format (JSON/CSV)"],
                        relatedFeatures: []
                    ),
                    HelpTopic(
                        title: "Restoring Data",
                        content: "If you lose data or get a new device, iCloud will automatically restore your synced data.",
                        steps: ["Sign into same iCloud account", "Open FreshFace", "Wait for sync to complete"],
                        relatedFeatures: []
                    )
                ]
            case .troubleshooting:
                return [
                    HelpTopic(
                        title: "iCloud Sync Issues",
                        content: "If your data isn't syncing, check these common issues.",
                        steps: ["Check internet connection", "Verify iCloud sign-in", "Ensure iCloud Drive is enabled", "Restart the app", "Check iCloud storage space"],
                        relatedFeatures: ["iCloud Settings"]
                    ),
                    HelpTopic(
                        title: "Barcode Scanner Not Working",
                        content: "Camera permission issues can prevent barcode scanning.",
                        steps: ["Go to Settings > Privacy > Camera", "Find FreshFace in list", "Enable camera access", "Restart app"],
                        relatedFeatures: ["Barcode Scanner"]
                    ),
                    HelpTopic(
                        title: "Notifications Not Showing",
                        content: "If you're not receiving expiry reminders, check notification settings.",
                        steps: ["Go to Settings > Notifications", "Find FreshFace", "Allow notifications", "Configure alert style"],
                        relatedFeatures: ["Notification Settings"]
                    ),
                    HelpTopic(
                        title: "App Performance Issues",
                        content: "If the app feels slow, try these optimizations.",
                        steps: ["Close other apps", "Restart FreshFace", "Check available storage", "Update to latest version", "Reinstall if needed"],
                        relatedFeatures: []
                    )
                ]
            }
        }
    }

    struct HelpTopic: Identifiable {
        let id = UUID()
        let title: String
        let content: String
        let steps: [String]
        let relatedFeatures: [String]
    }

    var body: some View {
        NavigationStack {
            List {
                searchSection

                categoryGrid

                if let selectedCategory {
                    topicsForCategory(selectedCategory)
                } else {
                    quickLinks

                    frequentlyAskedQuestions
                }
            }
            .navigationTitle("Help Center")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .searchable(text: $searchText, prompt: "Search help articles")
        }
    }

    private var searchSection: some View {
        Section {
        } header: {
            Text("How can we help?")
        }
    }

    private var categoryGrid: some View {
        Section(header: Text("Browse by Category")) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(HelpCategory.allCases) { category in
                    Button(action: { withAnimation { selectedCategory = category } }) {
                        VStack(spacing: 8) {
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundColor(Color(hex: category.color))

                            Text(category.rawValue)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func topicsForCategory(_ category: HelpCategory) -> some View {
        Section(header: HStack {
            Image(systemName: category.icon)
            Text(category.rawValue)
            Button(action: { withAnimation { selectedCategory = nil } }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }) {
            ForEach(category.topics) { topic in
                NavigationLink(destination: HelpDetailView(topic: topic)) {
                    HStack(spacing: 12) {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(Color(hex: category.color))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(topic.title)
                                .font(.subheadline)

                            Text(topic.content.prefix(80) + "...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var quickLinks: some View {
        Section(header: Text("Quick Links")) {
            NavigationLink(destination: HelpDetailView(topic: HelpCategory.gettingStarted.topics.first!)) {
                Label("Getting Started Guide", systemImage: "play.circle")
            }

            NavigationLink(destination: HelpDetailView(topic: HelpCategory.products.topics[1])) {
                Label("How to Scan Barcodes", systemImage: "barcode.viewfinder")
            }

            NavigationLink(destination: HelpDetailView(topic: HelpCategory.sync.topics.first!)) {
                Label("Setting Up iCloud Sync", systemImage: "icloud")
            }
        }
    }

    private var frequentlyAskedQuestions: some View {
        Section(header: Text("Frequently Asked Questions")) {
            DisclosureGroup("What is PAO?") {
                Text("PAO (Period After Opening) shows how long a product lasts once opened. Look for the open jar icon on packaging.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            DisclosureGroup("Is my data secure?") {
                Text("Yes! All data is encrypted and stored in your personal iCloud account. We never have access to your information.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            DisclosureGroup("Can I use this offline?") {
                Text("Most features work offline. You just need internet for initial iCloud setup, barcode lookup, and syncing across devices.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            DisclosureGroup("How do I transfer data to new device?") {
                Text("Simply sign into the same iCloud account on your new device. All data will sync automatically.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct HelpDetailView: View {
    let topic: HelpCenterView.HelpTopic
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection

                contentSection

                if !topic.steps.isEmpty {
                    stepsSection
                }

                if !topic.relatedFeatures.isEmpty {
                    relatedFeaturesSection
                }

                feedbackSection
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(topic.title)
                .font(.title2.bold())
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Overview")
                .font(.headline)

            Text(topic.content)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Step-by-Step")
                .font(.headline)

            ForEach(Array(topic.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "FF6B9D"))
                        .clipShape(Circle())

                    Text(step)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var relatedFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related Features")
                .font(.headline)

            ForEach(topic.relatedFeatures, id: \.self) { feature in
                HStack {
                    Image(systemName: "arrow.right.circle")
                        .foregroundColor(Color(hex: "FF6B9D"))
                    Text(feature)
                        .font(.subheadline)
                }
            }
        }
    }

    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Was this helpful?")
                .font(.headline)

            HStack(spacing: 16) {
                Button(action: {}) {
                    Label("Yes", systemImage: "hand.thumbsup")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(hex: "34C759").opacity(0.1))
                        .cornerRadius(8)
                }

                Button(action: {}) {
                    Label("No", systemImage: "hand.thumbsdown")
                        .font(.subheadline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color(hex: "FF3B30").opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct QuickTipsOverlay: View {
    let tip: QuickTip
    @Binding var isShowing: Bool
    @State private var shownTips: Set<String> = []

    struct QuickTip {
        let id: String
        let title: String
        let message: String
        let iconName: String
        let actionTitle: String?
        var action: (() -> Void)?
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { isShowing = false } }

            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: tip.iconName)
                        .font(.system(size: 48))
                        .foregroundColor(Color(hex: "FF6B9D"))

                    VStack(spacing: 8) {
                        Text(tip.title)
                            .font(.headline)

                        Text(tip.message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    if let actionTitle = tip.actionTitle, let action = tip.action {
                        Button(action: action) {
                            Text(actionTitle)
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "FF6B9D"))
                                .cornerRadius(12)
                        }
                    }

                    HStack(spacing: 24) {
                        Button(action: {
                            shownTips.insert(tip.id)
                            withAnimation { isShowing = false }
                        }) {
                            Text("Don't show again")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Button(action: {
                            withAnimation { isShowing = false }
                        }) {
                            Text("Got it!")
                                .font(.subheadline.weight(.semibold))
                                .foregroundColor(Color(hex: "FF6B9D"))
                        }
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 20)

                Spacer()
                    .frame(height: 50)
            }
        }
        .transition(.opacity)
    }
}
