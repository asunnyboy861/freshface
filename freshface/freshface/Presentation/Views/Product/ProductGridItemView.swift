import SwiftUI

struct ProductGridItemView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                if let imageData = product.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "FF6B9D").opacity(0.3), Color(hex: "FFB6C1").opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: product.category.icon)
                                .font(.system(size: 40))
                                .foregroundColor(Color(hex: "FF6B9D").opacity(0.5))
                        )
                }

                if let riskLevel = product.riskLevel {
                    riskBadge(for: riskLevel)
                        .padding(8)
                }
            }
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                if let brand = product.brand {
                    Text(brand)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 4) {
                    Image(systemName: product.category.icon)
                        .font(.system(size: 10))
                    Text(product.category.displayName)
                        .font(.system(size: 10))
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func riskBadge(for riskLevel: RiskLevel) -> some View {
        HStack(spacing: 4) {
            Image(systemName: riskLevel.icon)
                .font(.system(size: 10))
            Text(riskLevel.rawValue)
                .font(.system(size: 10, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: riskLevel.color).opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

#Preview {
    let sampleProduct = Product(
        name: "Vitamin C Serum",
        brand: "The Ordinary",
        category: .skincare,
        productType: .serum
    )

    return ProductGridItemView(product: sampleProduct)
        .frame(width: 180)
        .padding()
}
