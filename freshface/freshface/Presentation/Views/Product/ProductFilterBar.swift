import SwiftUI

struct ProductFilterBar: View {
    @Binding var selectedCategory: ProductCategory?
    let categories = ProductCategory.allCases

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filterChip(title: "All", icon: "square.grid.2x2", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(categories, id: \.self) { category in
                    filterChip(
                        title: category.displayName,
                        icon: category.icon,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func filterChip(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "FF6B9D") : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ProductFilterBar(selectedCategory: .constant(nil))
}
