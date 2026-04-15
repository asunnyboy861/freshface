import Foundation
import SwiftUI

class AddProductViewModel: ObservableObject {
    @Published var name = ""
    @Published var brand = ""
    @Published var category: ProductCategory = .skincare
    @Published var productType: ProductType?
    @Published var purchaseDate: Date?
    @Published var openDate = Date()
    @Published var paoMonths: Int = 12
    @Published var imageData: Data?
    @Published var barcode: String?
    @Published var notes = ""
    @Published var usageFrequency: Int = 1
    @Published var ingredients: String? = nil
    @Published var isSaving = false
    @Published var showImagePicker = false
    @Published var showScanner = false
    @Published var errorMessage: String?
    @Published var isLookingUp = false

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol) {
        self.repository = repository
    }

    var isValidForm: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !name.isEmpty
    }

    func lookupProduct(barcode: String) async {
        await MainActor.run {
            isLookingUp = true
        }

        let result = await ProductLookupService.shared.lookupProduct(barcode: barcode)

        await MainActor.run {
            applyLookupResult(result)
            isLookingUp = false
        }
    }

    func applyLookupResult(_ result: ProductLookupResult) {
        if let productName = result.name, !productName.isEmpty {
            name = productName
        }
        if let productBrand = result.brand, !productBrand.isEmpty {
            brand = productBrand
        }
        if let productCategory = result.category {
            category = productCategory
        }
        if let productType = result.productType {
            self.productType = productType
        }
        // Auto-fill ingredients from barcode scan
        if let productIngredients = result.ingredients, !productIngredients.isEmpty {
            ingredients = productIngredients
        }
    }

    func saveProduct() -> Product? {
        guard isValidForm else {
            errorMessage = "Please fill in required fields"
            return nil
        }

        isSaving = true

        let expiryDate = ExpiryCalculator.calculateExpiryDate(
            openDate: openDate,
            paoMonths: paoMonths
        )

        let newProduct = Product(
            name: name.trimmingCharacters(in: .whitespaces),
            brand: brand.isEmpty ? nil : brand.trimmingCharacters(in: .whitespaces),
            category: category,
            productType: productType,
            purchaseDate: purchaseDate,
            openDate: openDate,
            expiryDate: expiryDate,
            paoMonths: paoMonths,
            imageData: imageData,
            barcode: barcode,
            notes: notes.isEmpty ? nil : notes,
            usageFrequency: usageFrequency > 0 ? usageFrequency : nil,
            ingredients: ingredients
        )

        Task { @MainActor in
            do {
                _ = try await repository.create(newProduct)
                NotificationManager.shared.scheduleExpiryNotifications(for: newProduct)
                resetForm()
                isSaving = false
            } catch {
                errorMessage = "Failed to save product: \(error.localizedDescription)"
                isSaving = false
            }
        }

        return newProduct
    }

    func resetForm() {
        name = ""
        brand = ""
        category = .skincare
        productType = nil
        purchaseDate = nil
        openDate = Date()
        paoMonths = 12
        imageData = nil
        barcode = nil
        notes = ""
        usageFrequency = 1
        ingredients = nil
        errorMessage = nil
    }

    func setImage(_ image: UIImage) {
        imageData = image.jpegData(compressionQuality: 0.8)
    }
}
