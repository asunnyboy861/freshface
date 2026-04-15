import SwiftUI

struct SkinProfileView: View {
    @State private var profile: SkinProfile?
    @State private var showSetupView = false
    @State private var showClearAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let profile = profile, hasProfile(profile) {
                    profileContent(profile)
                } else {
                    emptyState
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationTitle("My Skin Profile")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if profile != nil && hasProfile(profile!) {
                    Button("Edit") {
                        showSetupView = true
                    }
                }
            }
        }
        .sheet(isPresented: $showSetupView) {
            NavigationStack {
                SkinProfileSetupView(profile: Binding(
                    get: { profile ?? SkinProfile() },
                    set: { newProfile in
                        profile = newProfile
                        SkinProfileStorage.shared.save(newProfile)
                    }
                ))
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            showSetupView = false
                        }
                    }
                }
            }
        }
        .alert("Clear Skin Profile", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                clearProfile()
            }
        } message: {
            Text("This will permanently delete your skin profile. This action cannot be undone.")
        }
        .onAppear {
            loadProfile()
        }
    }

    private func hasProfile(_ profile: SkinProfile) -> Bool {
        profile.skinType != nil || !profile.primaryConcerns.isEmpty
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No Skin Profile")
                .font(.title2)
                .fontWeight(.bold)

            Text("Set up your skin profile to get personalized product recommendations and better expiry tracking.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Button(action: { showSetupView = true }) {
                Label("Create Skin Profile", systemImage: "plus.circle.fill")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color(hex: "34C759"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.vertical, 40)
    }

    private func profileContent(_ profile: SkinProfile) -> some View {
        VStack(spacing: 20) {
            if let skinType = profile.skinType {
                skinTypeCard(skinType)
            }

            if !profile.primaryConcerns.isEmpty {
                concernsCard(profile.primaryConcerns)
            }

            Button(role: .destructive) {
                showClearAlert = true
            } label: {
                Label("Clear Skin Profile", systemImage: "trash")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            .padding(.top, 8)
        }
    }

    private func skinTypeCard(_ skinType: SkinType) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: skinType.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: skinType.color))

                Text("Skin Type")
                    .font(.headline)
            }

            HStack(spacing: 16) {
                Circle()
                    .fill(Color(hex: skinType.color).opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: skinType.icon)
                            .font(.system(size: 28))
                            .foregroundColor(Color(hex: skinType.color))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(skinType.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(skinType.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private func concernsCard(_ concerns: [SkinConcern]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "F5A623"))

                Text("Primary Concerns")
                    .font(.headline)
            }

            FlowLayout(spacing: 10) {
                ForEach(concerns) { concern in
                    HStack(spacing: 6) {
                        Image(systemName: concern.icon)
                            .font(.caption)

                        Text(concern.rawValue)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: concern.color).opacity(0.15))
                    )
                    .foregroundColor(Color(hex: concern.color))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }

    private func loadProfile() {
        profile = SkinProfileStorage.shared.load()
    }

    private func clearProfile() {
        SkinProfileStorage.shared.clear()
        profile = nil
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = computeLayout(proposal: proposal, subviews: subviews)

        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                      y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }

    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        let containerWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > containerWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            maxWidth = max(maxWidth, currentX)
        }

        return (CGSize(width: maxWidth, height: currentY + lineHeight), positions)
    }
}

#Preview {
    NavigationStack {
        SkinProfileView()
    }
}
