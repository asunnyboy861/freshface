import SwiftUI

struct OnboardingContainerView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    @Binding var hasCompleted: Bool
    var onComplete: (() -> Void)?

    var body: some View {
        VStack(spacing: 24) {
            pageIndicator

            actionButtons
        }
        .padding(.horizontal, 32)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color(hex: "FF6B9D") : Color.gray.opacity(0.3))
                    .frame(width: index == currentPage ? 10 : 8, height: index == currentPage ? 10 : 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            if currentPage < totalPages - 1 {
                Button(action: skipOnboarding) {
                    Text("Skip")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }

                Button(action: nextPage) {
                    Text("Next")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FF6B9D"))
                        .cornerRadius(12)
                }
            } else {
                Button(action: completeOnboarding) {
                    Text("Get Started")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
            }
        }
    }

    private func nextPage() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage = min(currentPage + 1, totalPages - 1)
        }
    }

    private func skipOnboarding() {
        completeOnboarding()
    }

    private func completeOnboarding() {
        onComplete?()
        withAnimation(.easeInOut(duration: 0.3)) {
            hasCompleted = true
        }
    }
}

#Preview {
    OnboardingContainerView(
        currentPage: .constant(0),
        totalPages: 4,
        hasCompleted: .constant(false)
    )
}
