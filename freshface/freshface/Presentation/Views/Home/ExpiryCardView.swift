import SwiftUI

struct ExpiryCardView: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageData = product.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: product.category.icon)
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                
                if let brand = product.brand {
                    Text(brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 6) {
                    if let risk = product.riskLevel,
                       let days = product.daysRemaining {
                        Circle()
                            .fill(Color(hex: risk.color))
                            .frame(width: 8, height: 8)
                        
                        Text(days <= 0 ? "Expired" : "\(days) days left")
                            .font(.caption2)
                            .foregroundColor(days <= 0 ? .red : (days <= 7 ? .orange : .secondary))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: riskIcon)
                .foregroundColor(riskColor)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
    
    private var riskIcon: String {
        guard let risk = product.riskLevel else { return "checkmark.circle" }
        return risk.icon
    }
    
    private var riskColor: Color {
        guard let risk = product.riskLevel else { return .green }
        return Color(hex: risk.color)
    }
}

#Preview {
    ExpiryCardView(product: Product.sampleData[0])
}
