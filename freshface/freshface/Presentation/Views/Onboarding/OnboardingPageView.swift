import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            iconSection

            textSection

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var iconSection: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "FF6B9D").opacity(0.3),
                            Color(hex: "FFB6C1").opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 200, height: 200)

            Image(systemName: page.imageName)
                .font(.system(size: 80, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }

    private var textSection: some View {
        VStack(spacing: 16) {
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)

            Text(page.description)
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
    }
}

#Preview {
    OnboardingPageView(page: .welcome)
}
