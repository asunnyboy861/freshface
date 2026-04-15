import Foundation

/// Skincare ingredient entity
/// Follows the existing Product entity design pattern
struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let casNumber: String?           // CAS number for international chemical identification
    let description: String
    let safetyRating: SafetyRating   // Safety rating
    let concerns: [SafetyConcern]    // List of concerns
    let categories: [IngredientCategory] // Ingredient categories
    let aliases: [String]            // Aliases for parsing matching
    
    init(
        id: UUID = UUID(),
        name: String,
        casNumber: String? = nil,
        description: String,
        safetyRating: SafetyRating,
        concerns: [SafetyConcern] = [],
        categories: [IngredientCategory] = [],
        aliases: [String] = []
    ) {
        self.id = id
        self.name = name
        self.casNumber = casNumber
        self.description = description
        self.safetyRating = safetyRating
        self.concerns = concerns
        self.categories = categories
        self.aliases = aliases
    }
}

// MARK: - Safety Rating Enum
enum SafetyRating: Int, Codable, CaseIterable {
    case verySafe = 100      // Green - Very Safe
    case safe = 80           // Light Green - Safe
    case moderate = 60       // Yellow - Moderate Risk
    case concerning = 40     // Orange - Concerning
    case unsafe = 20         // Red - Avoid
    case unknown = 0         // Gray - Unknown
    
    var displayName: String {
        switch self {
        case .verySafe: return "Very Safe"
        case .safe: return "Safe"
        case .moderate: return "Moderate Risk"
        case .concerning: return "Concerning"
        case .unsafe: return "Avoid"
        case .unknown: return "Unknown"
        }
    }
    
    var color: String {
        switch self {
        case .verySafe: return "34C759"    // Green
        case .safe: return "8BC34A"        // Light Green
        case .moderate: return "FFCC00"    // Yellow
        case .concerning: return "FF9500"  // Orange
        case .unsafe: return "FF3B30"      // Red
        case .unknown: return "8E8E93"     // Gray
        }
    }
}

// MARK: - Safety Concern
enum SafetyConcern: String, Codable, CaseIterable {
    case endocrineDisruptor = "Endocrine Disruptor"      // Endocrine disruptor
    case carcinogen = "Potential Carcinogen"            // Potential carcinogen
    case allergen = "Common Allergen"                   // Common allergen
    case skinIrritant = "Skin Irritant"                 // Skin irritant
    case environmental = "Environmental Hazard"         // Environmental hazard
    case bioaccumulative = "Bioaccumulative"            // Bioaccumulative
    case restricted = "Restricted in EU/Canada"          // Restricted in EU/Canada
    
    var icon: String {
        switch self {
        case .endocrineDisruptor: return "exclamationmark.triangle"
        case .carcinogen: return "xmark.circle"
        case .allergen: return "allergens"
        case .skinIrritant: return "hand.tap"
        case .environmental: return "leaf"
        case .bioaccumulative: return "arrow.3.trianglepath"
        case .restricted: return "flag"
        }
    }
}

// MARK: - Ingredient Category
enum IngredientCategory: String, Codable, CaseIterable {
    case preservative = "Preservative"          // Preservative
    case surfactant = "Surfactant"              // Surfactant
    case emollient = "Emollient"                // Emollient
    case humectant = "Humectant"                // Humectant
    case antioxidant = "Antioxidant"            // Antioxidant
    case fragrance = "Fragrance"                // Fragrance
    case colorant = "Colorant"                  // Colorant
    case uvFilter = "UV Filter"                 // UV Filter
    case activeIngredient = "Active Ingredient" // Active Ingredient
    case solvent = "Solvent"                    // Solvent
    case emulsifier = "Emulsifier"              // Emulsifier
    case other = "Other"                        // Other
}

// MARK: - Product Safety Score
struct ProductSafetyScore: Codable {
    let overallScore: Int
    let rating: SafetyRating
    let ingredientBreakdown: [IngredientScoreDetail]
    let topConcerns: [SafetyConcern]
    let recommendation: String
    
    var isClean: Bool {
        overallScore >= 80
    }
}

// MARK: - Ingredient Score Detail
struct IngredientScoreDetail: Codable, Identifiable {
    let id = UUID()
    let name: String
    let rawText: String
    let score: Int
    let rating: SafetyRating
    let concerns: [SafetyConcern]
}

// MARK: - Parsed Ingredient
struct ParsedIngredient: Codable {
    let rawText: String           // Raw text
    let ingredient: Ingredient    // Matched ingredient
    let confidence: MatchConfidence // Match confidence
    
    enum MatchConfidence: String, Codable {
        case high      // Exact match
        case medium    // Fuzzy match
        case low       // Possible match
    }
}

// MARK: - Parse Result
struct IngredientParseResult: Codable {
    let recognizedIngredients: [ParsedIngredient]
    let unrecognizedIngredients: [String]
    let totalCount: Int
    
    var recognizedCount: Int { recognizedIngredients.count }
    var recognitionRate: Double {
        guard totalCount > 0 else { return 0 }
        return Double(recognizedCount) / Double(totalCount)
    }
}

// MARK: - Product Recommendation
struct ProductRecommendation: Identifiable, Codable {
    let id = UUID()
    let product: Product
    let safetyScore: ProductSafetyScore
    let recommendationReason: String?
}
