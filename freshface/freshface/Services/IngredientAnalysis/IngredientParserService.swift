import Foundation

/// Ingredient list parsing service
/// Parses product ingredient strings into structured data
class IngredientParserService {
    static let shared = IngredientParserService()
    
    private let database = IngredientDatabase.shared
    
    private init() {}
    
    // MARK: - Public API
    
    /// Parse ingredient list string
    /// - Parameter ingredientList: Comma-separated ingredient list
    /// - Returns: Parse result containing recognized and unrecognized ingredients
    func parse(ingredientList: String) -> IngredientParseResult {
        let rawIngredients = splitIngredients(ingredientList)
        var recognized: [ParsedIngredient] = []
        var unrecognized: [String] = []
        
        for raw in rawIngredients {
            if let ingredient = database.findIngredient(byName: raw) {
                recognized.append(ParsedIngredient(
                    rawText: raw,
                    ingredient: ingredient,
                    confidence: .high
                ))
            } else {
                // Try fuzzy matching
                let searchResults = database.searchIngredients(query: raw)
                if let bestMatch = searchResults.first {
                    recognized.append(ParsedIngredient(
                        rawText: raw,
                        ingredient: bestMatch,
                        confidence: .medium
                    ))
                } else {
                    unrecognized.append(raw)
                }
            }
        }
        
        return IngredientParseResult(
            recognizedIngredients: recognized,
            unrecognizedIngredients: unrecognized,
            totalCount: rawIngredients.count
        )
    }
    
    /// Parse ingredients from barcode scan result
    func parseFromBarcodeResult(_ result: ProductLookupResult) -> IngredientParseResult? {
        guard let ingredients = result.ingredients else { return nil }
        return parse(ingredientList: ingredients)
    }
    
    /// Parse ingredients from product
    func parseFromProduct(_ product: Product) -> IngredientParseResult? {
        guard let ingredients = product.ingredients else { return nil }
        return parse(ingredientList: ingredients)
    }
    
    // MARK: - Private Methods
    
    private func splitIngredients(_ text: String) -> [String] {
        // Support multiple separators: comma, semicolon, newline
        let separators = CharacterSet(charactersIn: ",;|\n")
        return text
            .components(separatedBy: separators)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
