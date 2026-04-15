import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection

                acceptanceSection

                useOfServiceSection

                userAccountsSection

                intellectualPropertySection

                limitationOfLiabilitySection

                changesToTermsSection

                contactSection
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B9D"), Color(hex: "FF8FAB")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text("Terms of Service")
                .font(.title2.bold())

            Text("Last Updated: April 7, 2026")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    private var acceptanceSection: some View {
        TermsSection(
            title: "Acceptance of Terms",
            content: """
            By downloading, installing, or using FreshFace, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the app.
            """
        )
    }

    private var useOfServiceSection: some View {
        TermsSection(
            title: "Use of Service",
            content: """
            FreshFace is designed to help you track skincare and beauty product expiration dates. You agree to:

            • Use the app for its intended purpose only
            • Provide accurate information when adding products
            • Not misuse or attempt to exploit the app
            • Comply with all applicable laws and regulations

            The app is provided "as is" without warranties of any kind.
            """
        )
    }

    private var userAccountsSection: some View {
        TermsSection(
            title: "User Accounts",
            content: """
            To use FreshFace, you may need to:

            • Sign in with your Apple ID for iCloud sync
            • Grant necessary permissions (notifications, camera for barcode scanning)

            You are responsible for maintaining the confidentiality of your account and ensuring accurate data entry.
            """
        )
    }

    private var intellectualPropertySection: some View {
        TermsSection(
            title: "Intellectual Property",
            content: """
            All content, features, and functionality of FreshFace, including but not limited to:

            • Text, graphics, logos, and icons
            • Software and technology
            • App design and user interface

            Are owned by FreshFace and are protected by copyright and other intellectual property laws.
            """
        )
    }

    private var limitationOfLiabilitySection: some View {
        TermsSection(
            title: "Limitation of Liability",
            content: """
            FreshFace shall not be liable for:

            • Any indirect, incidental, special, or consequential damages
            • Loss of data, profits, or business opportunities
            • Any damages arising from reliance on product expiry information

            The app's expiry predictions are estimates based on user-provided data and should not be the sole basis for product safety decisions.
            """
        )
    }

    private var changesToTermsSection: some View {
        TermsSection(
            title: "Changes to Terms",
            content: """
            We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting. Your continued use of the app after changes constitutes acceptance of the new terms.
            """
        )
    }

    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contact Us")
                .font(.headline)

            Text("For questions about these Terms of Service, contact us at:")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("legal@freshface.app")
                .font(.subheadline)
                .foregroundColor(Color(hex: "FF6B9D"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TermsSection: View {
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
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
        TermsOfServiceView()
    }
}
