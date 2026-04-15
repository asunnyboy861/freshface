import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel(repository: LocalProductRepository())
    @State private var searchText = ""
    @State private var showAddProduct = false
    @State private var isGridView = false
    @State private var hasAttemptedLoad = false
    @State private var showBarcodeScanner = false

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Products")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        ProductSortMenu(selectedOption: $viewModel.sortOption)
                            .onChange(of: viewModel.sortOption) { _ in
                                viewModel.applyFilterAndSort()
                            }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 16) {
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isGridView.toggle()
                                }
                            } label: {
                                Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                                    .font(.system(size: 16))
                            }

                            Button(action: { showAddProduct = true }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search products")
                .onChange(of: searchText) { newValue in
                    viewModel.searchProducts(query: newValue)
                }
                .refreshable {
                    viewModel.loadProducts()
                }
                .sheet(isPresented: $showAddProduct) {
                    AddProductView(repository: LocalProductRepository())
                }
        }
        .onAppear {
            if !hasAttemptedLoad {
                viewModel.loadProducts()
                hasAttemptedLoad = true
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var contentView: some View {
        Group {
            if viewModel.isLoading && viewModel.products.isEmpty && !hasAttemptedLoad {
                LoadingStateView(message: "Loading products...")
            } else if let error = viewModel.errorMessage, !hasAttemptedLoad || viewModel.products.isEmpty {
                ErrorStateView(message: error) {
                    viewModel.loadProducts()
                    hasAttemptedLoad = true
                }
            } else if viewModel.filteredProducts.isEmpty && hasAttemptedLoad {
                emptyStateView
            } else if !viewModel.filteredProducts.isEmpty {
                VStack(spacing: 0) {
                    filterSection

                    if isGridView {
                        gridView
                    } else {
                        listView
                    }
                }
            } else if !hasAttemptedLoad {
                LoadingStateView(message: "Loading products...")
            } else {
                emptyStateView
            }
        }
    }

    private var filterSection: some View {
        ProductFilterBar(selectedCategory: $viewModel.currentFilterCategory)
            .onChange(of: viewModel.currentFilterCategory) { _ in
                viewModel.applyFilterAndSort()
            }
            .padding(.vertical, 8)
    }

    private var emptyStateView: some View {
        EnhancedEmptyStateView(
            title: "No Products",
            message: "Add your first skincare or beauty product to start tracking",
            systemImage: "cube.box",
            primaryActionTitle: "Add Product",
            primaryAction: { showAddProduct = true },
            secondaryActionTitle: "Scan Barcode",
            secondaryAction: {
                showBarcodeScanner = true
            },
            showTip: true,
            tipText: "Quick tip: Use barcode scanner for fast entry!"
        )
        .sheet(isPresented: $showBarcodeScanner) {
            BarcodeScannerView { barcode in
                handleScannedBarcode(barcode)
            }
        }
    }

    private func handleScannedBarcode(_ barcode: String) {
        showAddProduct = true
    }

    private var listView: some View {
        List {
            ForEach(viewModel.filteredProducts) { product in
                NavigationLink(destination: ProductDetailView(product: product)) {
                    ProductRowView(product: product)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.deleteProduct(product)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductGridItemView(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ProductListView()
}
