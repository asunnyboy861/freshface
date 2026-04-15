import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompleted: Bool
    @State private var currentPage = 0
    @State private var profile: SkinProfile = SkinProfile()

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(Array(OnboardingPage.allCases.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }

                SkinProfileOnboardingView(profile: $profile)
                    .tag(OnboardingPage.allCases.count)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            OnboardingContainerView(
                currentPage: $currentPage,
                totalPages: OnboardingPage.allCases.count + 1,
                hasCompleted: $hasCompleted,
                onComplete: {
                    if profile.skinType != nil || !profile.primaryConcerns.isEmpty {
                        SkinProfileStorage.shared.save(profile)
                    }
                }
            )
            .padding(.bottom, 40)
        }
        .ignoresSafeArea()
    }
}

struct SkinProfileOnboardingView: View {
    @Binding var profile: SkinProfile

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "34C759"))

                Text("Personalize Your Experience")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Tell us about your skin to get personalized recommendations")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            SkinProfileSetupView(profile: $profile)

            Spacer()
        }
        .padding(.top, 60)
    }
}

enum OnboardingPage: String, CaseIterable, Identifiable {
    case welcome = "Welcome"
    case track = "Track Everything"
    case notify = "Stay Notified"
    case privacy = "Your Privacy"

    var id: String { rawValue }

    var imageName: String {
        switch self {
        case .welcome: return "sparkles"
        case .track: return "cube.box.fill"
        case .notify: return "bell.badge.fill"
        case .privacy: return "lock.shield.fill"
        }
    }

    var title: String { rawValue }

    var description: String {
        switch self {
        case .welcome:
            return "Your personal skincare expiry manager"
        case .track:
            return "Add products and never forget when they expire"
        case .notify:
            return "Get gentle reminders before products go bad"
        case .privacy:
            return "All data stored securely on your device and iCloud"
        }
    }
}

#Preview {
    OnboardingView(hasCompleted: .constant(false))
}
