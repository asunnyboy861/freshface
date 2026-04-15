import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection

                dataCollectionSection

                dataStorageSection

                dataSharingSection

                yourRightsSection

                contactSection
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("FreshFace Privacy Policy")
                .font(.title2.bold())

            Text("Last Updated: April 7, 2026")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    private var dataCollectionSection: some View {
        PolicySection(
            title: "Data Collection",
            icon: "doc.text.fill",
            content: """
            FreshFace collects the following information to provide our service:

            • **Product Information**: Name, brand, category, type, and photos of skincare/beauty products you add
            • **Usage Data**: Expiry dates, opening dates, and usage frequency you provide
            • **Device Information**: Device type and iOS version for troubleshooting

            We do NOT collect:
            • Personal identification information (name, email, phone)
            • Location data
            • Health or biometric data
            """
        )
    }

    private var dataStorageSection: some View {
        PolicySection(
            title: "Data Storage",
            icon: "icloud.fill",
            content: """
            Your data is stored securely using:

            • **On-Device Storage**: Product data is stored locally on your device
            • **iCloud Sync**: With your permission, data syncs across your devices using Apple CloudKit

            All data is encrypted in transit and at rest using Apple's security infrastructure.
            """
        )
    }

    private var dataSharingSection: some View {
        PolicySection(
            title: "Data Sharing",
            icon: "person.2.fill",
            content: """
            We do NOT sell, trade, or transfer your data to third parties.

            We may share anonymous, aggregated data for:
            • App improvement purposes
            • Analytics and crash reporting

            Service providers (only when necessary):
            • Apple (for iCloud sync)
            • No other third-party services are used.
            """
        )
    }

    private var yourRightsSection: some View {
        PolicySection(
            title: "Your Rights",
            icon: "hand.raised.fill",
            content: """
            You have the right to:

            • **Access**: View all your stored data within the app
            • **Export**: Export your data at any time using the Export feature in Settings
            • **Delete**: Delete all your data using the Clear All Data feature in Settings
            • **Control Notifications**: Manage notification preferences in Settings

            To exercise these rights, use the in-app features or contact us.
            """
        )
    }

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Us")
                .font(.headline)

            Text("For privacy-related questions, contact us at:")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("privacy@freshface.app")
                .font(.subheadline)
                .foregroundColor(Color(hex: "FF6B9D"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PolicySection: View {
    let title: String
    let icon: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(Color(hex: "FF6B9D"))

            Text(LocalizedStringKey(content))
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
