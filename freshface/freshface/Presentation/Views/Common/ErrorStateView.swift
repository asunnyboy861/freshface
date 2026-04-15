import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(hex: "FF6B9D"))
                        .cornerRadius(8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(message: "Failed to load products. Please check your connection.") {
        print("Retry tapped")
    }
}
