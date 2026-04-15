import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    @Published var product: Product
    @Published var riskLevel: RiskLevel?
    @Published var daysRemaining: Int?
    @Published var completionPrediction: CompletionPrediction?
    @Published var isSaving = false
    @Published var errorMessage: String?
    
    private let repository: ProductRepositoryProtocol
    
    init(product: Product, repository: ProductRepositoryProtocol) {
        self.product = product
        self.repository = repository
        updateCalculatedValues()
    }
    
    private func updateCalculatedValues() {
        daysRemaining = product.daysRemaining
        riskLevel = product.riskLevel
        completionPrediction = CompletionPrediction.predict(
            usageFrequency: product.usageFrequency,
            estimatedRemaining: product.estimatedRemaining,
            daysRemaining: product.daysRemaining
        )
    }
    
    func updateExpiryDate(openDate: Date, paoMonths: Int) {
        let newExpiryDate = ExpiryCalculator.calculateExpiryDate(
            openDate: openDate,
            paoMonths: paoMonths
        )
        
        product.expiryDate = newExpiryDate
        product.openDate = openDate
        product.paoMonths = paoMonths
        updateCalculatedValues()
    }
    
    func saveChanges() {
        isSaving = true
        
        Task { @MainActor in
            do {
                let updatedProduct = try await repository.update(product)
                self.product = updatedProduct
                NotificationManager.shared.scheduleExpiryNotifications(for: updatedProduct)
                isSaving = false
            } catch {
                errorMessage = "Failed to save changes"
                isSaving = false
            }
        }
    }
    
    func markAsUsed() {
        product.isActive = false
        saveChanges()
    }
    
    func deleteProduct() async throws {
        try await repository.delete(product)
    }
}
