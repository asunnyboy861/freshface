import SwiftUI

/// Ingredient analysis main view
/// Displays safety analysis for product ingredients
struct IngredientAnalysisView: View {
    let product: Product
    @StateObject private var viewModel = IngredientAnalysisViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isAnalyzing {
                        analyzingView
                    } else if let score = viewModel.safetyScore {
                        analysisResultView(score: score)
                    } else {
                        noIngredientsView
                    }
                }
                .padding()
            }
            .navigationTitle("Ingredient Analysis")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            viewModel.analyze(product: product)
        }
    }
    
    private var analyzingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Analyzing ingredients...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
    
    private func analysisResultView(score: ProductSafetyScore) -> some View {
        VStack(spacing: 20) {
            // Safety score card
            SafetyScoreCard(score: score)
            
            // Key concerns (if any)
            if !score.topConcerns.isEmpty {
                ConcernsSection(concerns: score.topConcerns)
            }
            
            // Ingredient breakdown
            if let parseResult = viewModel.parseResult {
                IngredientsBreakdownSection(
                    breakdown: score.ingredientBreakdown,
                    unrecognized: parseResult.unrecognizedIngredients
                )
            }
            
            // Disclaimer
            disclaimerView
        }
    }
    
    private var noIngredientsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("No Ingredients to Analyze")
                .font(.title2.bold())
            
            Text("Add ingredients to this product to see safety analysis and recommendations.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                viewModel.showAddIngredients = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Ingredients")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color(hex: "FF6B9D"))
                .cornerRadius(12)
            }
        }
        .padding(40)
        .sheet(isPresented: $viewModel.showAddIngredients) {
            AddIngredientsView(product: product) { ingredients in
                viewModel.saveIngredients(ingredients, for: product)
            }
        }
    }
    
    private var disclaimerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .foregroundColor(.secondary)
            
            Text("This analysis is for informational purposes only and does not constitute medical advice.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// MARK: - Add Ingredients View

struct AddIngredientsView: View {
    let product: Product
    let onSave: (String) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var ingredientsText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ingredients")) {
                    TextEditor(text: $ingredientsText)
                        .frame(minHeight: 200)
                        .font(.body)
                }
                
                Section(footer: Text("Enter ingredients separated by commas, semicolons, or new lines.")) {
                    EmptyView()
                }
                
                Section {
                    Button("Scan from Barcode") {
                        // TODO: Implement barcode scan for ingredients
                    }
                    .foregroundColor(Color(hex: "FF6B9D"))
                }
            }
            .navigationTitle("Add Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(ingredientsText)
                        dismiss()
                    }
                    .disabled(ingredientsText.isEmpty)
                }
            }
        }
    }
}

// MARK: - View Model

@MainActor
class IngredientAnalysisViewModel: ObservableObject {
    @Published var isAnalyzing = false
    @Published var safetyScore: ProductSafetyScore?
    @Published var parseResult: IngredientParseResult?
    @Published var showAddIngredients = false
    
    private let parser = IngredientParserService.shared
    private let calculator = SafetyRatingCalculator.shared
    private let productRepository = LocalProductRepository()
    
    func analyze(product: Product) {
        guard let ingredients = product.ingredients, !ingredients.isEmpty else {
            safetyScore = nil
            parseResult = nil
            return
        }
        
        isAnalyzing = true
        
        Task {
            // Parse ingredients
            let result = parser.parse(ingredientList: ingredients)
            parseResult = result
            
            // Calculate safety score
            safetyScore = calculator.calculateOverallScore(from: result)
            
            isAnalyzing = false
        }
    }
    
    func saveIngredients(_ ingredients: String, for product: Product) {
        Task {
            var updatedProduct = product
            updatedProduct.ingredients = ingredients
            updatedProduct.updatedAt = Date()
            
            do {
                try await productRepository.update(updatedProduct)
                // Re-analyze with new ingredients
                analyze(product: updatedProduct)
            } catch {
                print("Error saving ingredients: \(error)")
            }
        }
    }
}
