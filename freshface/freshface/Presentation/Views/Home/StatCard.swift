import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2.bold())
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview {
    HStack(spacing: 20) {
        StatCard(title: "Total", value: "24", icon: "cube.box", color: Color(hex: "7B68EE"))
        StatCard(title: "Expiring", value: "3", icon: "exclamationmark.triangle.fill", color: .orange)
    }
}
