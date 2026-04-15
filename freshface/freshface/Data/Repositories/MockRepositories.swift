import Foundation

class MockProductRepository: ProductRepositoryProtocol {
    
    func fetchAll() async throws -> [Product] {
        return Product.sampleData
    }
    
    func fetch(byId id: UUID) async throws -> Product? {
        return Product.sampleData.first { $0.id == id }
    }
    
    func create(_ product: Product) async throws -> Product {
        return product
    }
    
    func update(_ product: Product) async throws -> Product {
        return product
    }
    
    func delete(_ product: Product) async throws {
        
    }
    
    func fetchExpiring() async throws -> [Product] {
        return Product.sampleData.filter { $0.riskLevel != .safe && $0.riskLevel != nil }
    }
    
    func search(query: String) async throws -> [Product] {
        if query.isEmpty { return Product.sampleData }
        return Product.sampleData.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            ($0.brand?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }
    
    func filter(by category: ProductCategory?) async throws -> [Product] {
        guard let category else { return Product.sampleData }
        return Product.sampleData.filter { $0.category == category }
    }
}

class MockRoutineRepository: RoutineRepositoryProtocol {
    
    func fetchAll() async throws -> [Routine] {
        return [
            Routine(name: "Morning Skincare", routineType: .morning),
            Routine(name: "Evening Skincare", routineType: .evening),
            Routine(name: "Weekly Mask", routineType: .custom)
        ]
    }
    
    func fetch(byId id: UUID) async throws -> Routine? {
        return nil
    }
    
    func create(_ routine: Routine) async throws -> Routine {
        return routine
    }
    
    func update(_ routine: Routine) async throws -> Routine {
        return routine
    }
    
    func delete(_ routine: Routine) async throws {
        
    }
}

class MockUsageLogRepository: UsageLogRepositoryProtocol {
    
    func fetch(for productId: UUID) async throws -> [UsageLog] {
        return []
    }
    
    func create(_ log: UsageLog) async throws -> UsageLog {
        return log
    }
    
    func delete(_ log: UsageLog) async throws {
        
    }
}
