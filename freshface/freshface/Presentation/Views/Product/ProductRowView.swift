import SwiftUI

struct ProductRowView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            productImage
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(1)
                
                if let brand = product.brand {
                    Text(brand)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                HStack(spacing: 8) {
                    Text(product.category.displayName)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                    
                    if let risk = product.riskLevel,
                       let days = product.daysRemaining {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: risk.color))
                                .frame(width: 8, height: 8)
                            
                            Text(days <= 0 ? "Expired" : "\(days)d left")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(days <= 0 ? .red : Color(hex: risk.color))
                        }
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var productImage: some View {
        Group {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: product.category.icon)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    List {
        ForEach(Product.sampleData.prefix(3)) { product in
            ProductRowView(product: product)
        }
    }
}
