import Foundation

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var brand: String?
    var category: ProductCategory
    var productType: ProductType?
    var purchaseDate: Date?
    var openDate: Date?
    var expiryDate: Date?
    var paoMonths: Int?
    var imageData: Data?
    var barcode: String?
    var notes: String?
    var usageFrequency: Int?
    var estimatedRemaining: Double?
    var isActive: Bool
    var ingredients: String?          // Ingredient list for analysis (comma-separated raw text)
    let createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        brand: String? = nil,
        category: ProductCategory,
        productType: ProductType? = nil,
        purchaseDate: Date? = nil,
        openDate: Date? = nil,
        expiryDate: Date? = nil,
        paoMonths: Int? = nil,
        imageData: Data? = nil,
        barcode: String? = nil,
        notes: String? = nil,
        usageFrequency: Int? = nil,
        estimatedRemaining: Double? = nil,
        isActive: Bool = true,
        ingredients: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.category = category
        self.productType = productType
        self.purchaseDate = purchaseDate
        self.openDate = openDate
        self.expiryDate = expiryDate
        self.paoMonths = paoMonths
        self.imageData = imageData
        self.barcode = barcode
        self.notes = notes
        self.usageFrequency = usageFrequency
        self.estimatedRemaining = estimatedRemaining
        self.isActive = isActive
        self.ingredients = ingredients
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    var daysRemaining: Int? {
        guard let expiryDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: expiryDate)
        return components.day
    }
    
    var riskLevel: RiskLevel? {
        guard let daysRemaining else { return nil }
        
        if daysRemaining <= 0 {
            return .expired
        } else if daysRemaining <= 3 {
            return .critical
        } else if daysRemaining <= 7 {
            return .warning
        } else if daysRemaining <= 30 {
            return .caution
        } else {
            return .safe
        }
    }
}
