import Foundation

class LocalProductRepository: ProductRepositoryProtocol {

    private let productsKey = "freshface_products"

    init() {}

    private var savedProducts: [Product] {
        get {
            guard let data = UserDefaults.standard.data(forKey: productsKey) else {
                return []
            }
            return (try? JSONDecoder().decode([Product].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: productsKey)
            }
        }
    }

    func fetchAll() async throws -> [Product] {
        return savedProducts
    }

    func fetch(byId id: UUID) async throws -> Product? {
        return savedProducts.first { $0.id == id }
    }

    func create(_ product: Product) async throws -> Product {
        var products = savedProducts
        products.append(product)
        savedProducts = products
        return product
    }

    func update(_ product: Product) async throws -> Product {
        var products = savedProducts
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            savedProducts = products
        }
        return product
    }

    func delete(_ product: Product) async throws {
        var products = savedProducts
        products.removeAll { $0.id == product.id }
        savedProducts = products
    }

    func fetchExpiring() async throws -> [Product] {
        let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        return savedProducts.filter { product in
            guard let expiryDate = product.expiryDate else { return false }
            return expiryDate <= thirtyDaysFromNow && expiryDate >= Date()
        }.sorted { ($0.expiryDate ?? .distantFuture) < ($1.expiryDate ?? .distantFuture) }
    }

    func search(query: String) async throws -> [Product] {
        let lowercasedQuery = query.lowercased()
        return savedProducts.filter { product in
            product.name.lowercased().contains(lowercasedQuery) ||
            product.brand?.lowercased().contains(lowercasedQuery) == true ||
            product.category.rawValue.lowercased().contains(lowercasedQuery)
        }
    }

    func filter(by category: ProductCategory?) async throws -> [Product] {
        guard let category else {
            return savedProducts
        }
        return savedProducts.filter { $0.category == category }
    }

    func clearAll() {
        savedProducts = []
    }
}
