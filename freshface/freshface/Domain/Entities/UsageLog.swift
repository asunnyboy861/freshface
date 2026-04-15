import Foundation

struct UsageLog: Identifiable, Codable {
    let id: UUID
    let productId: UUID
    let date: Date
    var notes: String?
    var skinCondition: String?
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        productId: UUID,
        date: Date = Date(),
        notes: String? = nil,
        skinCondition: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.productId = productId
        self.date = date
        self.notes = notes
        self.skinCondition = skinCondition
        self.createdAt = createdAt
    }
}
