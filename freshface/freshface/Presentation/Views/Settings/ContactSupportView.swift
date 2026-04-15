import SwiftUI
import Network

struct ContactSupportView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    // Form fields
    @State private var selectedCategory: FeedbackCategory = .general
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var message: String = ""

    // UI states
    @State private var isSubmitting: Bool = false
    @State private var showSuccessAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showNetworkWarning: Bool = false
    @State private var isNetworkAvailable: Bool = true

    // Network monitor
    @State private var networkMonitor: NWPathMonitor?
    @State private var networkMonitorQueue: DispatchQueue?

    // Character limit for message
    private let maxMessageLength: Int = 1000

    // API endpoint
    private let feedbackAPIURL = "https://feedback-board.iocompile67692.workers.dev/api/feedback"

    var body: some View {
        NavigationStack {
            Form {
                categorySection
                contactInfoSection
                messageSection
                submitSection
            }
            .navigationTitle("Contact Support")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Feedback Submitted", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for your feedback! We'll get back to you soon.")
            }
            .alert("Submission Failed", isPresented: $showErrorAlert) {
                Button("Try Again", role: .cancel) {}
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text(errorMessage)
            }
            .alert("Network Required", isPresented: $showNetworkWarning) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please check your internet connection and try again.")
            }
            .onAppear {
                startNetworkMonitoring()
            }
            .onDisappear {
                stopNetworkMonitoring()
            }
        }
    }

    // MARK: - Network Monitoring
    private func startNetworkMonitoring() {
        networkMonitor = NWPathMonitor()
        networkMonitorQueue = DispatchQueue(label: "NetworkMonitor")

        networkMonitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isNetworkAvailable = path.status == .satisfied
            }
        }

        networkMonitor?.start(queue: networkMonitorQueue!)
    }

    private func stopNetworkMonitoring() {
        networkMonitor?.cancel()
        networkMonitor = nil
        networkMonitorQueue = nil
    }

    // MARK: - Network Status Banner
    private var networkStatusBanner: some View {
        Group {
            if !isNetworkAvailable {
                HStack(spacing: 8) {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.orange)
                    Text("No internet connection")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
            }
        }
    }

    // MARK: - Category Section
    private var categorySection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(FeedbackCategory.allCases) { category in
                        CategoryChip(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(Color.clear)
        } header: {
            Text("What can we help you with?")
        } footer: {
            if !isNetworkAvailable {
                Text("Internet connection required to submit feedback")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
    }

    // MARK: - Contact Info Section
    private var contactInfoSection: some View {
        Section(header: Text("Contact Information")) {
            VStack(alignment: .leading, spacing: 16) {
                // Name field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Name")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    TextField("Your name", text: $name)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .textContentType(.name)
                        .autocapitalization(.words)
                }

                // Email field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)

                    TextField("your.email@example.com", text: $email)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
            }
            .padding(.vertical, 8)
        }
    }

    // MARK: - Message Section
    private var messageSection: some View {
        Section(header: Text("Message")) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if message.isEmpty {
                        Text("Describe your issue or suggestion here...")
                            .foregroundColor(.secondary.opacity(0.6))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }

                    TextEditor(text: $message)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                }

                HStack {
                    Text("\(message.count)/\(maxMessageLength)")
                        .font(.caption)
                        .foregroundColor(message.count > maxMessageLength ? .red : .secondary)

                    Spacer()

                    if message.count > maxMessageLength {
                        Text("Character limit exceeded")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Submit Section
    private var submitSection: some View {
        Section {
            Button(action: submitFeedback) {
                HStack {
                    Spacer()

                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else if !isNetworkAvailable {
                        HStack(spacing: 6) {
                            Image(systemName: "wifi.slash")
                            Text("No Connection")
                        }
                        .fontWeight(.semibold)
                    } else {
                        Text("Submit Feedback")
                            .fontWeight(.semibold)
                    }

                    Spacer()
                }
            }
            .disabled(isSubmitting || !isFormValid || !isNetworkAvailable)
            .listRowBackground(
                isFormValid && isNetworkAvailable
                    ? Color(hex: "007AFF")
                    : Color.gray.opacity(0.3)
            )
            .foregroundColor(isFormValid && isNetworkAvailable ? .white : .secondary)
            .cornerRadius(10)
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }

    // MARK: - Validation
    private var isFormValid: Bool {
        !message.isEmpty &&
        message.count <= maxMessageLength &&
        !email.isEmpty &&
        isValidEmail(email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Submit Action
    private func submitFeedback() {
        // Check network connectivity
        guard isNetworkAvailable else {
            showNetworkWarning = true
            return
        }

        isSubmitting = true

        // Prepare request body
        let feedbackData: [String: Any] = [
            "name": name,
            "email": email,
            "subject": selectedCategory.rawValue,
            "message": message,
            "app_name": "FreshFace"
        ]

        guard let url = URL(string: feedbackAPIURL),
              let jsonData = try? JSONSerialization.data(withJSONObject: feedbackData) else {
            errorMessage = "Invalid request data"
            showErrorAlert = true
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false

                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    showErrorAlert = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    errorMessage = "Invalid server response"
                    showErrorAlert = true
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    showSuccessAlert = true
                } else {
                    errorMessage = "Server error (\(httpResponse.statusCode)). Please try again later."
                    showErrorAlert = true
                }
            }
        }.resume()
    }
}

// MARK: - Feedback Category
enum FeedbackCategory: String, CaseIterable, Identifiable {
    case general = "General Feedback"
    case bug = "Bug Report"
    case feature = "Feature Request"
    case question = "Question"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .general: return "message.fill"
        case .bug: return "ladybug.fill"
        case .feature: return "lightbulb.fill"
        case .question: return "questionmark.circle.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .general: return Color(hex: "007AFF")
        case .bug: return Color(hex: "FF3B30")
        case .feature: return Color(hex: "34C759")
        case .question: return Color(hex: "FF9500")
        case .other: return Color(hex: "8E8E93")
        }
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let category: FeedbackCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : category.color)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? category.color : category.color.opacity(0.15))
                    )

                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? category.color : .primary)
                    .lineLimit(1)
                    .fixedSize()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? category.color.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? category.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Text Field Style
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
    }
}

// MARK: - Preview
struct ContactSupportView_Previews: PreviewProvider {
    static var previews: some View {
        ContactSupportView()
    }
}
