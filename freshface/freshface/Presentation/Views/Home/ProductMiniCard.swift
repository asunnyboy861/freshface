import SwiftUI

struct ProductMiniCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 80)
                    .overlay(
                        Image(systemName: product.category.icon)
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.caption.bold())
                    .lineLimit(1)
                
                if let risk = product.riskLevel,
                   let days = product.daysRemaining {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: risk.color))
                            .frame(width: 6, height: 6)
                        Text(days <= 0 ? "Expired" : "\(days)d")
                            .font(.caption2)
                            .foregroundColor(days <= 0 ? .red : .secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProductMiniCard(product: Product.sampleData[0])
}
