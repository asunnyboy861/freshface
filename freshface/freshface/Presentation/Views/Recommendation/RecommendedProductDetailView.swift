import SwiftUI

struct RecommendedProductDetailView: View {
    let recommendation: ProductRecommendation

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                productInfoCard

                SafetyScoreCard(score: recommendation.safetyScore)

                if let ingredients = recommendation.product.ingredients, !ingredients.isEmpty {
                    ingredientsCard(ingredients)
                }

                recommendationReasonCard
            }
            .padding()
        }
        .navigationTitle(recommendation.product.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var productInfoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "FF6B9D").opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: recommendation.product.category.icon)
                            .font(.title2)
                            .foregroundColor(Color(hex: "FF6B9D"))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.product.name)
                        .font(.headline)

                    Text(recommendation.product.brand ?? "Unknown Brand")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(recommendation.product.category.displayName)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }

                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private func ingredientsCard(_ ingredients: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Key Ingredients")
                .font(.headline)

            let ingredientList = ingredients.components(separatedBy: ",").prefix(5)

            ForEach(ingredientList, id: \.self) { ingredient in
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(hex: "34C759"))
                        .frame(width: 6, height: 6)

                    Text(ingredient.trimmingCharacters(in: .whitespaces))
                        .font(.subheadline)
                }
            }

            if ingredients.components(separatedBy: ",").count > 5 {
                Text("+ \(ingredients.components(separatedBy: ",").count - 5) more ingredients")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }

    private var recommendationReasonCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(Color(hex: "FF6B9D"))
                Text("Why We Recommend")
                    .font(.headline)
            }

            Text(recommendation.recommendationReason ?? "This product has a high safety rating and is suitable for your skin type.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(hex: "FF6B9D").opacity(0.05))
        .cornerRadius(12)
    }
}