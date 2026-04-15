import Foundation

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case haircare = "Haircare"
    case fragrance = "Fragrance"
    case other = "Other"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .skincare: return "drop.fill"
        case .makeup: return "paintbrush"
        case .haircare: return "scissors"
        case .fragrance: return "flame"
        case .other: return "cube.box"
        }
    }
}

enum ProductType: String, CaseIterable, Codable {
    case cleanser = "Cleanser"
    case toner = "Toner"
    case serum = "Serum"
    case moisturizer = "Moisturizer"
    case eyeCream = "Eye Cream"
    case sunscreen = "Sunscreen"
    case mask = "Mask"
    case foundation = "Foundation"
    case concealer = "Concealer"
    case mascara = "Mascara"
    case lipstick = "Lipstick"
    case blush = "Blush"
    case shampoo = "Shampoo"
    case conditioner = "Conditioner"
    case perfume = "Perfume"
    case other = "Other"
    
    var displayName: String { rawValue }
}

enum RiskLevel: String, CaseIterable, Codable {
    case safe = "Safe"
    case caution = "Caution"
    case warning = "Warning"
    case critical = "Critical"
    case expired = "Expired"

    var color: String {
        switch self {
        case .safe: return "#4CAF50"
        case .caution: return "#FFC107"
        case .warning: return "#FF9800"
        case .critical: return "#F44336"
        case .expired: return "#B71C1C"
        }
    }

    var icon: String {
        switch self {
        case .safe: return "checkmark.circle.fill"
        case .caution: return "exclamationmark.triangle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .critical: return "xmark.octagon.fill"
        case .expired: return "xmark.circle.fill"
        }
    }

    var sortOrder: Int {
        switch self {
        case .expired: return 0
        case .critical: return 1
        case .warning: return 2
        case .caution: return 3
        case .safe: return 4
        }
    }
}

enum ProductSortOption: String, CaseIterable {
    case name = "Name"
    case dateAdded = "Date Added"
    case expiryDate = "Expiry Date"
    case riskLevel = "Risk Level"

    var icon: String {
        switch self {
        case .name: return "textformat.abc"
        case .dateAdded: return "calendar"
        case .expiryDate: return "clock"
        case .riskLevel: return "exclamationmark.triangle"
        }
    }
}
