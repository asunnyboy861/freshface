import Foundation

enum SkinType: String, Codable, CaseIterable, Identifiable {
    case dry = "Dry"
    case oily = "Oily"
    case combination = "Combination"
    case normal = "Normal"
    case sensitive = "Sensitive"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dry: return "drop.fill"
        case .oily: return "drop.triangle.fill"
        case .combination: return "drop.triangle"
        case .normal: return "checkmark.circle.fill"
        case .sensitive: return "exclamationmark.triangle.fill"
        }
    }

    var description: String {
        switch self {
        case .dry: return "Often feel tight, flaky, or itchy"
        case .oily: return "Excess shine, enlarged pores"
        case .combination: return "Oily T-zone, dry cheeks"
        case .normal: return "Balanced, few issues"
        case .sensitive: return "Easily irritated, reactive"
        }
    }

    var color: String {
        switch self {
        case .dry: return "4A90D9"
        case .oily: return "F5A623"
        case .combination: return "9B59B6"
        case .normal: return "34C759"
        case .sensitive: return "FF6B6B"
        }
    }
}

enum SkinConcern: String, Codable, CaseIterable, Identifiable {
    case acne = "Acne"
    case aging = "Fine Lines & Wrinkles"
    case darkSpots = "Dark Spots & Hyperpigmentation"
    case dryness = "Dryness & Dehydration"
    case oiliness = "Excess Oil"
    case pores = "Large Pores"
    case redness = "Redness & Sensitivity"
    case dullness = "Dullness"
    case unevenTexture = "Uneven Texture"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .acne: return "flame.fill"
        case .aging: return "clock.fill"
        case .darkSpots: return "circle.fill"
        case .dryness: return "drop.fill"
        case .oiliness: return "drop.triangle.fill"
        case .pores: return "circle.grid.2x2.fill"
        case .redness: return "exclamationmark.triangle.fill"
        case .dullness: return "sun.max.fill"
        case .unevenTexture: return "square.stack.3d.down.right.fill"
        }
    }

    var color: String {
        switch self {
        case .acne: return "FF6B6B"
        case .aging: return "9B59B6"
        case .darkSpots: return "8B4513"
        case .dryness: return "4A90D9"
        case .oiliness: return "F5A623"
        case .pores: return "808080"
        case .redness: return "FF9500"
        case .dullness: return "FFD700"
        case .unevenTexture: return "A0A0A0"
        }
    }
}

struct SkinProfile: Codable {
    var skinType: SkinType?
    var primaryConcerns: [SkinConcern]
    var avoidIngredients: [String]
    var createdAt: Date
    var updatedAt: Date

    init(
        skinType: SkinType? = nil,
        primaryConcerns: [SkinConcern] = [],
        avoidIngredients: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.skinType = skinType
        self.primaryConcerns = primaryConcerns
        self.avoidIngredients = avoidIngredients
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
