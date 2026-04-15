import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ProductListViewModel(repository: LocalProductRepository())
    @State private var showAddProduct = false
    @State private var showProductGuide = false

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("FreshFace")
                .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showAddProduct) {
            AddProductView(repository: LocalProductRepository())
                .onDisappear {
                    viewModel.loadProducts()
                }
        }
        .sheet(isPresented: $showProductGuide) {
            ContextualHelpView(
                title: "Adding Products",
                steps: [
                    "Tap '+' button on Products tab",
                    "Choose 'Scan Barcode' or enter manually",
                    "Fill in product details (name, brand, category)",
                    "Add photo for visual reference",
                    "Set expiration date or PAO period",
                    "Save to start tracking"
                ]
            )
        }
        .onAppear {
            if viewModel.products.isEmpty {
                viewModel.loadProducts()
            }
        }
    }

    private var contentView: some View {
        Group {
            if viewModel.isLoading && viewModel.products.isEmpty {
                LoadingStateView(message: "Loading products...")
            } else if let error = viewModel.errorMessage {
                ErrorStateView(message: error) {
                    viewModel.loadProducts()
                }
            } else if viewModel.products.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection

                        if !viewModel.expiringProducts.isEmpty {
                            expiringSoonSection
                        }

                        quickStatsSection
                        recentProductsSection
                    }
                    .padding()
                }
            }
        }
    }

    private var emptyStateView: some View {
        EnhancedEmptyStateView(
            title: "No Products Yet",
            message: "Start tracking your skincare products by adding your first item.",
            systemImage: "cube.box",
            primaryActionTitle: "Add Your First Product",
            primaryAction: {
                navigateToAddProduct()
            },
            secondaryActionTitle: "Learn How",
            secondaryAction: {
                showProductGuide = true
            },
            showTip: true,
            tipText: "Pro tip: Scan barcodes for quick product entry!"
        )
    }

    private func navigateToAddProduct() {
        showAddProduct = true
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome Back!")
                .font(.title2.bold())
            Text("Track your skincare products and stay safe")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var expiringSoonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                Text("Expiring Soon (\(viewModel.expiringProducts.count))")
                    .font(.headline)
            }

            LazyVGrid(columns: [GridItem(.flexible())], spacing: 10) {
                ForEach(viewModel.expiringProducts.prefix(3)) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ExpiryCardView(product: product)
                    }
                }
            }
        }
    }

    private var quickStatsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                StatCard(
                    title: "Total",
                    value: "\(viewModel.products.count)",
                    icon: "cube.box",
                    color: Color(hex: "7B68EE")
                )

                StatCard(
                    title: "Expiring",
                    value: "\(viewModel.expiringProducts.count)",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                )

                let expiredCount = viewModel.products.filter { $0.riskLevel == .expired }.count
                StatCard(
                    title: "Expired",
                    value: "\(expiredCount)",
                    icon: "xmark.circle.fill",
                    color: .red
                )
            }
        }
    }

    private var recentProductsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Products")
                .font(.headline)

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 15
            ) {
                ForEach(viewModel.products.prefix(4)) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductGridItemView(product: product)
                    }
                }
            }
        }
    }
}
