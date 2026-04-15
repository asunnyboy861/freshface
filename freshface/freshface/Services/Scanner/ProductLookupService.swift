import Foundation

struct ProductLookupResult {
    var name: String?
    var brand: String?
    var category: ProductCategory?
    var productType: ProductType?
    var barcode: String
    var ingredients: String?     // Ingredient list from barcode scan
    var isFound: Bool { name != nil }
}

class ProductLookupService: ObservableObject {
    static let shared = ProductLookupService()

    @Published var isLoading = false
    @Published var errorMessage: String?

    private init() {}

    func lookupProduct(barcode: String) async -> ProductLookupResult {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        defer {
            Task { @MainActor in
                isLoading = false
            }
        }

        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcode).json"
        guard let url = URL(string: urlString) else {
            await MainActor.run {
                errorMessage = "Invalid barcode format"
            }
            return ProductLookupResult(barcode: barcode)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                await MainActor.run {
                    errorMessage = "Unable to lookup product"
                }
                return ProductLookupResult(barcode: barcode)
            }

            let openFoodResponse = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)

            guard openFoodResponse.status == 1,
                  let product = openFoodResponse.product else {
                return ProductLookupResult(barcode: barcode)
            }

            return ProductLookupResult(
                name: product.productName ?? product.productNameEnglish,
                brand: product.brands,
                category: inferCategory(from: product.categoriesTags),
                productType: inferProductType(from: product.categoriesTags),
                barcode: barcode,
                ingredients: product.ingredientsText     // Pass ingredient information
            )
        } catch {
            await MainActor.run {
                errorMessage = "Network error: \(error.localizedDescription)"
            }
            return ProductLookupResult(barcode: barcode)
        }
    }

    private func inferCategory(from tags: [String]?) -> ProductCategory {
        guard let tags = tags else { return .other }
        let tagsLower = tags.map { $0.lowercased() }

        if tagsLower.contains(where: { $0.contains("skincare") || $0.contains("face-care") }) {
            return .skincare
        } else if tagsLower.contains(where: { $0.contains("makeup") || $0.contains("cosmetics") || $0.contains("lipstick") }) {
            return .makeup
        } else if tagsLower.contains(where: { $0.contains("hair") || $0.contains("shampoo") || $0.contains("conditioner") }) {
            return .haircare
        } else if tagsLower.contains(where: { $0.contains("fragrance") || $0.contains("perfume") }) {
            return .fragrance
        }
        return .other
    }

    private func inferProductType(from tags: [String]?) -> ProductType? {
        guard let tags = tags else { return nil }
        let tagsLower = tags.map { $0.lowercased() }

        if tagsLower.contains(where: { $0.contains("serum") }) {
            return .serum
        } else if tagsLower.contains(where: { $0.contains("moisturizer") || $0.contains("cream") }) {
            return .moisturizer
        } else if tagsLower.contains(where: { $0.contains("cleanser") || $0.contains("wash") }) {
            return .cleanser
        } else if tagsLower.contains(where: { $0.contains("sunscreen") || $0.contains("spf") }) {
            return .sunscreen
        } else if tagsLower.contains(where: { $0.contains("mask") || $0.contains("pack") }) {
            return .mask
        } else if tagsLower.contains(where: { $0.contains("toner") }) {
            return .toner
        }
        return nil
    }

    func openFoodDatabase(barcode: String) -> URL? {
        let urlString = "https://world.openfoodfacts.org/product/\(barcode)"
        return URL(string: urlString)
    }
}

struct OpenFoodFactsResponse: Codable {
    let status: Int
    let product: OpenFoodFactsProduct?
}

struct OpenFoodFactsProduct: Codable {
    let productName: String?
    let productNameEnglish: String?
    let brands: String?
    let categoriesTags: [String]?
    let ingredientsText: String?     // Ingredient list text
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productNameEnglish = "product_name_en"
        case brands
        case categoriesTags = "categories_tags"
        case ingredientsText = "ingredients_text"   // API field name
    }
}
