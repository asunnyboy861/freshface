import Foundation
import Combine

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var expiringProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sortOption: ProductSortOption = .dateAdded
    @Published var currentFilterCategory: ProductCategory?

    private let repository: ProductRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
        loadProducts()
    }

    func loadProducts() {
        isLoading = true

        Task { @MainActor in
            do {
                products = try await repository.fetchAll()
                applyFilterAndSort()
                expiringProducts = products.filter { $0.riskLevel != .safe && $0.riskLevel != nil }
                isLoading = false
            } catch {
                errorMessage = "Failed to load products: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }

    func searchProducts(query: String) {
        if query.isEmpty {
            filteredProducts = products
        } else {
            filteredProducts = products.filter {
                $0.name.localizedCaseInsensitiveContains(query) ||
                ($0.brand?.localizedCaseInsensitiveContains(query) ?? false)
            }
        }
        applySort()
    }

    func filterByCategory(_ category: ProductCategory?) {
        currentFilterCategory = category
        applyFilterAndSort()
    }

    func sortProducts(by option: ProductSortOption) {
        sortOption = option
        applyFilterAndSort()
    }

    func applyFilterAndSort() {
        var result = products

        if let category = currentFilterCategory {
            result = result.filter { $0.category == category }
        }

        switch sortOption {
        case .name:
            result.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .dateAdded:
            result.sort { $0.createdAt > $1.createdAt }
        case .expiryDate:
            result.sort { ($0.daysRemaining ?? Int.max) < ($1.daysRemaining ?? Int.max) }
        case .riskLevel:
            result.sort { ($0.riskLevel?.sortOrder ?? 99) < ($1.riskLevel?.sortOrder ?? 99) }
        }

        filteredProducts = result
    }

    private func applySort() {
        switch sortOption {
        case .name:
            filteredProducts.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .dateAdded:
            filteredProducts.sort { $0.createdAt > $1.createdAt }
        case .expiryDate:
            filteredProducts.sort { ($0.daysRemaining ?? Int.max) < ($1.daysRemaining ?? Int.max) }
        case .riskLevel:
            filteredProducts.sort { ($0.riskLevel?.sortOrder ?? 99) < ($1.riskLevel?.sortOrder ?? 99) }
        }
    }

    func deleteProduct(_ product: Product) {
        Task { @MainActor in
            do {
                try await repository.delete(product)
                loadProducts()
            } catch {
                errorMessage = "Failed to delete product"
            }
        }
    }
}
