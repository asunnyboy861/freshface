import Foundation
import Combine

protocol ProductRepositoryProtocol {
    func fetchAll() async throws -> [Product]
    func fetch(byId id: UUID) async throws -> Product?
    func create(_ product: Product) async throws -> Product
    func update(_ product: Product) async throws -> Product
    func delete(_ product: Product) async throws
    func fetchExpiring() async throws -> [Product]
    func search(query: String) async throws -> [Product]
    func filter(by category: ProductCategory?) async throws -> [Product]
}

protocol RoutineRepositoryProtocol {
    func fetchAll() async throws -> [Routine]
    func fetch(byId id: UUID) async throws -> Routine?
    func create(_ routine: Routine) async throws -> Routine
    func update(_ routine: Routine) async throws -> Routine
    func delete(_ routine: Routine) async throws
}

protocol UsageLogRepositoryProtocol {
    func fetch(for productId: UUID) async throws -> [UsageLog]
    func create(_ log: UsageLog) async throws -> UsageLog
    func delete(_ log: UsageLog) async throws
}
