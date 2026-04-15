import Foundation

/// Product safety score calculator
/// Calculates overall safety score based on ingredient analysis
class SafetyRatingCalculator {
    static let shared = SafetyRatingCalculator()
    
    private init() {}
    
    // MARK: - Public API
    
    /// Calculate overall product safety score
    func calculateOverallScore(from parseResult: IngredientParseResult) -> ProductSafetyScore {
        let ingredients = parseResult.recognizedIngredients
        
        guard !ingredients.isEmpty else {
            return ProductSafetyScore(
                overallScore: 0,
                rating: .unknown,
                ingredientBreakdown: [],
                topConcerns: [],
                recommendation: "Unable to analyze ingredients"
            )
        }
        
        // Calculate weighted average score
        let totalScore = ingredients.reduce(0) { sum, parsed in
            sum + parsed.ingredient.safetyRating.rawValue
        }
        let averageScore = totalScore / ingredients.count
        
        // Determine overall rating
        let overallRating = SafetyRating(
            rawValue: (averageScore / 20) * 20
        ) ?? .unknown
        
        // Extract ingredient score details
        let breakdown = ingredients.map { parsed in
            IngredientScoreDetail(
                name: parsed.ingredient.name,
                rawText: parsed.rawText,
                score: parsed.ingredient.safetyRating.rawValue,
                rating: parsed.ingredient.safetyRating,
                concerns: parsed.ingredient.concerns
            )
        }.sorted { $0.score < $1.score }  // Sort by risk
        
        // Extract top concerns
        let allConcerns = ingredients.flatMap { $0.ingredient.concerns }
        let concernCounts = Dictionary(grouping: allConcerns) { $0 }
            .mapValues { $0.count }
        let topConcerns = concernCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
        
        // Generate recommendation
        let recommendation = generateRecommendation(
            score: averageScore,
            rating: overallRating,
            concerns: topConcerns,
            recognitionRate: parseResult.recognitionRate
        )
        
        return ProductSafetyScore(
            overallScore: averageScore,
            rating: overallRating,
            ingredientBreakdown: breakdown,
            topConcerns: topConcerns,
            recommendation: recommendation
        )
    }
    
    /// Calculate score from product directly
    func calculateScore(for product: Product) -> ProductSafetyScore? {
        guard let parseResult = IngredientParserService.shared.parseFromProduct(product) else {
            return nil
        }
        return calculateOverallScore(from: parseResult)
    }
    
    // MARK: - Private Methods
    
    private func generateRecommendation(
        score: Int,
        rating: SafetyRating,
        concerns: [SafetyConcern],
        recognitionRate: Double
    ) -> String {
        // Handle low recognition rate
        if recognitionRate < 0.5 {
            return "We could only recognize \(Int(recognitionRate * 100))% of ingredients. Consider adding a clearer ingredient list for better analysis."
        }
        
        // Generate recommendation based on rating
        switch rating {
        case .verySafe:
            return "Excellent choice! This product contains safe ingredients with minimal concerns."
        case .safe:
            return "Good choice. This product is generally safe for most users."
        case .moderate:
            var message = "This product has some ingredients of moderate concern."
            if !concerns.isEmpty {
                message += " Watch out for: \(concerns.prefix(2).map { $0.rawValue }.joined(separator: ", "))."
            }
            return message
        case .concerning:
            var message = "This product contains several ingredients of concern."
            if !concerns.isEmpty {
                message += " Consider alternatives without: \(concerns.map { $0.rawValue }.joined(separator: ", "))."
            }
            return message
        case .unsafe:
            return "We recommend avoiding this product due to potentially harmful ingredients."
        case .unknown:
            return "Unable to provide a safety assessment. Please check the ingredient list."
        }
    }
}
