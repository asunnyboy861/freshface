import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = ProductListViewModel(repository: LocalProductRepository())
    @State private var showAddProductFromAnalytics = false
    @State private var showAnalyticsGuide = false

    var body: some View {
        NavigationStack {
            analyticsContent
                .navigationTitle("Analytics")
                .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if viewModel.products.isEmpty && !viewModel.isLoading {
                viewModel.loadProducts()
            }
        }
    }

    private var analyticsContent: some View {
        Group {
            if viewModel.isLoading && viewModel.products.isEmpty {
                LoadingStateView(message: "Loading analytics data...")
            } else if let error = viewModel.errorMessage, viewModel.products.isEmpty {
                ErrorStateView(message: error) {
                    viewModel.loadProducts()
                }
            } else if viewModel.products.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        overviewSection

                        categoryBreakdownSection

                        riskDistributionSection

                        insightsSection
                    }
                    .padding()
                }
            }
        }
    }

    private var emptyStateView: some View {
        EnhancedEmptyStateView(
            title: "No Data Available",
            message: "Add products to see insights and analytics about your skincare routine.",
            systemImage: "chart.bar.fill",
            primaryActionTitle: "Add Products",
            primaryAction: { showAddProductFromAnalytics = true },
            secondaryActionTitle: "View Guide",
            secondaryAction: { showAnalyticsGuide = true },
            showTip: true,
            tipText: "Insight: Track at least 5+ products for better analytics!"
        )
        .sheet(isPresented: $showAddProductFromAnalytics) {
            AddProductView(repository: CloudProductRepository())
        }
        .sheet(isPresented: $showAnalyticsGuide) {
            ContextualHelpView(
                title: "Understanding Analytics",
                steps: [
                    "Add products with expiration dates",
                    "Categorize products correctly",
                    "Wait for data to accumulate (5+ products recommended)",
                    "Check overview stats for quick summary",
                    "Review category breakdown for organization insights",
                    "Monitor risk distribution to prioritize replacements"
                ]
            )
        }
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                AnalyticsStatCard(
                    title: "Total Products",
                    value: "\(viewModel.products.count)",
                    icon: "cube.box.fill",
                    color: Color(hex: "7B68EE")
                )

                let expiringCount = viewModel.products.filter { $0.riskLevel != .safe && $0.riskLevel != nil }.count
                AnalyticsStatCard(
                    title: "Expiring Soon",
                    value: "\(expiringCount)",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                )

                let expiredCount = viewModel.products.filter { $0.riskLevel == .expired }.count
                AnalyticsStatCard(
                    title: "Expired",
                    value: "\(expiredCount)",
                    icon: "xmark.circle.fill",
                    color: .red
                )
            }
        }
    }

    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.headline)

            ForEach(ProductCategory.allCases, id: \.self) { category in
                let count = viewModel.products.filter { $0.category == category }.count
                if count > 0 {
                    CategoryRow(category: category, count: count, total: viewModel.products.count)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private var riskDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Distribution")
                .font(.headline)

            ForEach(RiskLevel.allCases, id: \.self) { risk in
                let count = viewModel.products.filter { $0.riskLevel == risk }.count
                RiskRow(level: risk, count: count, total: viewModel.products.count)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Insights")
                    .font(.headline)
            }

            generateInsights()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func generateInsights() -> some View {
        let products = viewModel.products
        let expiringSoon = products.filter { ($0.daysRemaining ?? 999) <= 30 && ($0.daysRemaining ?? 0) > 0 }
        let expired = products.filter { $0.riskLevel == .expired }
        let safeProducts = products.filter { $0.riskLevel == .safe || $0.riskLevel == nil }

        return VStack(alignment: .leading, spacing: 12) {
            if !expiringSoon.isEmpty {
                insightRow(
                    icon: "clock.badge.exclamationmark",
                    color: .orange,
                    text: "\(expiringSoon.count) product\(expiringSoon.count == 1 ? "" : "s") will expire within 30 days"
                )
            }

            if !expired.isEmpty {
                insightRow(
                    icon: "xmark.circle.fill",
                    color: .red,
                    text: "\(expired.count) product\(expired.count == 1 ? " has" : "s have") expired and should be discarded"
                )
            }

            if !safeProducts.isEmpty {
                insightRow(
                    icon: "checkmark.circle.fill",
                    color: .green,
                    text: "\(safeProducts.count) product\(safeProducts.count == 1 ? " is" : " are") in good condition"
                )
            }

            if products.isEmpty {
                insightRow(
                    icon: "info.circle",
                    color: .secondary,
                    text: "Start adding products to get personalized insights"
                )
            }
        }
    }

    private func insightRow(icon: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 20)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct AnalyticsStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title.bold())

            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct CategoryRow: View {
    let category: ProductCategory
    let count: Int
    let total: Int

    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(Color(hex: "FF6B9D"))

            Text(category.displayName)
                .font(.subheadline)

            Spacer()

            Text("\(count)")
                .font(.subheadline.bold())

            ProgressView(value: Double(count) / Double(total))
                .frame(width: 80)
        }
    }
}

struct RiskRow: View {
    let level: RiskLevel
    let count: Int
    let total: Int

    var body: some View {
        HStack {
            Circle()
                .fill(Color(hex: level.color))
                .frame(width: 10, height: 10)

            Text(level.rawValue)
                .font(.subheadline)

            Spacer()

            Text("\(count)")
                .font(.subheadline.bold())

            ProgressView(value: Double(count) / Double(total))
                .tint(Color(hex: level.color))
                .frame(width: 80)
        }
    }
}

#Preview {
    AnalyticsView()
}
