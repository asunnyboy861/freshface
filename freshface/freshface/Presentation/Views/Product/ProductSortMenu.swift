import SwiftUI

struct ProductSortMenu: View {
    @Binding var selectedOption: ProductSortOption

    var body: some View {
        Menu {
            ForEach(ProductSortOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Image(systemName: option.icon)
                        Text(option.rawValue)
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: selectedOption.icon)
                    .font(.system(size: 14))
                Text(selectedOption.rawValue)
                    .font(.system(size: 14, weight: .medium))
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ProductSortMenu(selectedOption: .constant(.dateAdded))
}
