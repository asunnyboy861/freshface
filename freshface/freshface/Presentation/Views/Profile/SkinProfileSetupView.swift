import SwiftUI

struct SkinProfileSetupView: View {
    @Binding var profile: SkinProfile
    @State private var selectedSkinType: SkinType?
    @State private var selectedConcerns: Set<SkinConcern> = []
    @State private var currentStep = 0

    private let totalSteps = 2

    var body: some View {
        VStack(spacing: 24) {
            progressIndicator

            Spacer()

            if currentStep == 0 {
                skinTypeSelection
            } else {
                concernsSelection
            }

            Spacer()

            navigationButtons
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .onAppear {
            selectedSkinType = profile.skinType
            selectedConcerns = Set(profile.primaryConcerns)
        }
    }

    private var progressIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? Color(hex: "34C759") : Color.gray.opacity(0.3))
                    .frame(height: 4)
            }
        }
    }

    private var skinTypeSelection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What's your skin type?")
                .font(.title2)
                .fontWeight(.bold)

            Text("Select the option that best describes your skin")
                .font(.subheadline)
                .foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(SkinType.allCases) { type in
                    SkinTypeCard(
                        skinType: type,
                        isSelected: selectedSkinType == type
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSkinType = type
                        }
                    }
                }
            }
        }
    }

    private var concernsSelection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What are your skin concerns?")
                .font(.title2)
                .fontWeight(.bold)

            Text("Select all that apply (optional)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(SkinConcern.allCases) { concern in
                    ConcernCard(
                        concern: concern,
                        isSelected: selectedConcerns.contains(concern)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if selectedConcerns.contains(concern) {
                                selectedConcerns.remove(concern)
                            } else {
                                selectedConcerns.insert(concern)
                            }
                        }
                    }
                }
            }
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if currentStep > 0 {
                Button(action: {
                    withAnimation {
                        currentStep -= 1
                    }
                }) {
                    Text("Back")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                }
            }

            Button(action: {
                if currentStep == totalSteps - 1 {
                    saveProfile()
                } else {
                    withAnimation {
                        currentStep += 1
                    }
                }
            }) {
                Text(currentStep == totalSteps - 1 ? "Complete" : "Next")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "34C759"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }

    private func saveProfile() {
        var updatedProfile = profile
        updatedProfile.skinType = selectedSkinType
        updatedProfile.primaryConcerns = Array(selectedConcerns)
        updatedProfile.updatedAt = Date()
        profile = updatedProfile
        SkinProfileStorage.shared.save(updatedProfile)
    }
}

struct SkinTypeCard: View {
    let skinType: SkinType
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: skinType.icon)
                .font(.system(size: 28))
                .foregroundColor(Color(hex: skinType.color))

            Text(skinType.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)

            Text(skinType.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color(hex: skinType.color).opacity(0.15) : Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color(hex: skinType.color) : Color.clear, lineWidth: 2)
        )
    }
}

struct ConcernCard: View {
    let concern: SkinConcern
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: concern.icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: concern.color))
                .frame(width: 32)

            Text(concern.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "34C759"))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color(hex: concern.color).opacity(0.15) : Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color(hex: concern.color) : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    SkinProfileSetupView(profile: .constant(SkinProfile()))
}
