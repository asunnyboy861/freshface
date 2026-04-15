import SwiftUI

/// Clean product recommendations page
/// Recommends high-rated alternatives based on product category
struct ProductRecommendationsView: View {
    let category: ProductCategory
    let currentProduct: Product?
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var viewModel = ProductRecommendationsViewModel()
    @State private var showAddSuccessMessage = false
    @State private var addedProductName = ""
    @State private var selectedRecommendation: ProductRecommendation?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection

                if viewModel.isLoading {
                    ProgressView("Finding clean alternatives...")
                        .padding()
                } else if viewModel.recommendations.isEmpty {
                    emptyStateView
                } else {
                    recommendationsList
                }
            }
            .padding()
        }
        .navigationTitle("Clean Alternatives")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.loadRecommendations(
                for: category,
                excluding: currentProduct?.id,
                repository: coordinator.productRepository
            )
        }
        .alert("Added to Library", isPresented: $showAddSuccessMessage) {
            Button("OK") { }
            Button("View Products") {
                coordinator.navigate(to: .products)
            }
        } message: {
            Text("\(addedProductName) has been added to your product library.")
        }
        .sheet(item: $selectedRecommendation) { recommendation in
            NavigationStack {
                RecommendedProductDetailView(recommendation: recommendation)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                selectedRecommendation = nil
                            }
                        }
                    }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 48))
                .foregroundColor(.green)

            Text("Discover Clean Beauty")
                .font(.title2.bold())

            Text("High-rated alternatives in \(category.displayName) with safer ingredients")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var recommendationsList: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.recommendations) { recommendation in
                CleanAlternativeCard(
                    recommendation: recommendation,
                    onAddToLibrary: {
                        addToLibrary(recommendation)
                    },
                    onViewDetails: {
                        selectedRecommendation = recommendation
                    }
                )
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No recommendations yet")
                .font(.headline)

            Text("Add more products with ingredient analysis to get personalized recommendations")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private func addToLibrary(_ recommendation: ProductRecommendation) {
        Task {
            do {
                let newProduct = Product(
                    name: recommendation.product.name,
                    brand: recommendation.product.brand,
                    category: recommendation.product.category,
                    productType: recommendation.product.productType,
                    imageData: recommendation.product.imageData,
                    ingredients: recommendation.product.ingredients
                )

                _ = try await coordinator.productRepository.create(newProduct)

                await MainActor.run {
                    addedProductName = newProduct.name
                    showAddSuccessMessage = true
                }
            } catch {
                print("Failed to add product: \(error)")
            }
        }
    }
}

// MARK: - Clean Alternative Card

struct CleanAlternativeCard: View {
    let recommendation: ProductRecommendation
    let onAddToLibrary: () -> Void
    let onViewDetails: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "cube.box")
                            .foregroundColor(.secondary)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.product.name)
                        .font(.headline)

                    Text(recommendation.product.brand ?? "Unknown Brand")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.shield.fill")
                            .foregroundColor(Color(hex: recommendation.safetyScore.rating.color))
                        Text("\(recommendation.safetyScore.overallScore)/100")
                            .font(.caption.bold())
                            .foregroundColor(Color(hex: recommendation.safetyScore.rating.color))
                    }
                }

                Spacer()
            }

            if let reason = recommendation.recommendationReason {
                Text(reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
            }

            HStack(spacing: 12) {
                Button(action: onAddToLibrary) {
                    Label("Add to Library", systemImage: "plus.circle")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)

                Button(action: onViewDetails) {
                    Label("View Details", systemImage: "info.circle")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - View Model

@MainActor
class ProductRecommendationsViewModel: ObservableObject {
    @Published var recommendations: [ProductRecommendation] = []
    @Published var isLoading = false

    private let parser = IngredientParserService.shared
    private let calculator = SafetyRatingCalculator.shared

    func loadRecommendations(for category: ProductCategory, excluding excludedId: UUID?, repository: ProductRepositoryProtocol) {
        isLoading = true

        Task {
            do {
                let allProducts = try await repository.fetchAll()
                let categoryProducts = allProducts.filter {
                    $0.category == category && $0.id != excludedId
                }

                var highRatedRecommendations: [ProductRecommendation] = []

                for product in categoryProducts {
                    guard let ingredients = product.ingredients, !ingredients.isEmpty else { continue }

                    let parseResult = parser.parse(ingredientList: ingredients)
                    let safetyScore = calculator.calculateOverallScore(from: parseResult)

                    guard safetyScore.overallScore >= 80 else { continue }

                    let recommendation = ProductRecommendation(
                        product: product,
                        safetyScore: safetyScore,
                        recommendationReason: generateRecommendationReason(for: safetyScore)
                    )

                    highRatedRecommendations.append(recommendation)
                }

                recommendations = highRatedRecommendations.sorted {
                    $0.safetyScore.overallScore > $1.safetyScore.overallScore
                }

                isLoading = false
            } catch {
                print("Error loading recommendations: \(error)")
                isLoading = false
            }
        }
    }

    private func generateRecommendationReason(for score: ProductSafetyScore) -> String {
        if score.isClean {
            return "Clean Beauty - Safe for daily use"
        } else if score.overallScore >= 60 {
            return "Generally safe with minimal concerns"
        } else {
            return "Check ingredient details before use"
        }
    }
}
