import SwiftUI

struct EnhancedErrorStateView: View {
    let error: Error
    var retryAction: (() -> Void)?
    var showDetails: Bool = false
    var helpAction: (() -> Void)?
    @State private var isShowingDetails = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            errorIcon

            errorTitle

            errorMessage

            if showDetails {
                errorDetails
            }

            actionButtons

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(16)
        .padding()
    }

    private var errorIcon: some View {
        Image(systemName: errorIconName)
            .font(.system(size: 64))
            .foregroundColor(errorColor)
    }

    private var errorTitle: some View {
        Text(errorTitleText)
            .font(.title2.bold())
            .multilineTextAlignment(.center)
    }

    private var errorMessage: some View {
        Text(errorDescription)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }

    private var errorDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation { isShowingDetails.toggle() } }) {
                HStack {
                    Text("Technical Details")
                        .font(.caption)
                    Spacer()
                    Image(systemName: isShowingDetails ? "chevron.up" : "chevron.down")
                }
                .foregroundColor(.secondary)
            }

            if isShowingDetails {
                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .textSelection(.enabled)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            if let retryAction {
                Button(action: retryAction) {
                    Label("Try Again", systemImage: "arrow.clockwise")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FF6B9D"))
                        .cornerRadius(12)
                }
            }

            if let helpAction {
                Button(action: helpAction) {
                    Label("Get Help", systemImage: "questionmark.circle")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "FF6B9D"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FF6B9D").opacity(0.1))
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }

    private var errorIconName: String {
        if let cloudKitError = error as? CloudKitManager.CloudKitError {
            switch cloudKitError {
            case .notAuthenticated:
                return "person.crop.circle.badge.xmark"
            case .networkError:
                return "wifi.slash"
            case .serverError:
                return "server.rack"
            case .unknownError:
                return "exclamationmark.triangle"
            }
        }

        let errorString = error.localizedDescription.lowercased()

        if errorString.contains("network") || errorString.contains("connection") {
            return "wifi.slash"
        } else if errorString.contains("permission") || errorString.contains("access") {
            return "lock.fill"
        } else if errorString.contains("not found") || errorString.contains("404") {
            return "magnifyingglass"
        } else if errorString.contains("authentication") || errorString.contains("unauthorized") {
            return "person.crop.circle.badge.xmark"
        } else {
            return "exclamationmark.triangle"
        }
    }

    private var errorColor: Color {
        if let cloudKitError = error as? CloudKitManager.CloudKitError {
            switch cloudKitError {
            case .notAuthenticated:
                return Color(hex: "FF9500")
            case .networkError:
                return Color(hex: "FF9500")
            case .serverError:
                return Color(hex: "FF3B30")
            case .unknownError:
                return Color(hex: "FF3B30")
            }
        }

        let errorString = error.localizedDescription.lowercased()

        if errorString.contains("network") || errorString.contains("connection") {
            return Color(hex: "FF9500")
        } else if errorString.contains("permission") || errorString.contains("access") {
            return Color(hex: "FF9500")
        } else {
            return Color(hex: "FF3B30")
        }
    }

    private var errorTitleText: String {
        if let cloudKitError = error as? CloudKitManager.CloudKitError {
            switch cloudKitError {
            case .notAuthenticated:
                return "Authentication Required"
            case .networkError:
                return "Connection Error"
            case .serverError:
                return "Server Error"
            case .unknownError:
                return "Something Went Wrong"
            }
        }

        let errorString = error.localizedDescription.lowercased()

        if errorString.contains("network") || errorString.contains("connection") {
            return "No Internet Connection"
        } else if errorString.contains("permission") || errorString.contains("access") {
            return "Permission Denied"
        } else if errorString.contains("not found") {
            return "Not Found"
        } else if errorString.contains("authentication") || errorString.contains("unauthorized") {
            return "Authentication Required"
        } else {
            return "Oops! Something Went Wrong"
        }
    }

    private var errorDescription: String {
        if let cloudKitError = error as? CloudKitManager.CloudKitError {
            switch cloudKitError {
            case .notAuthenticated:
                return "Please sign in to your iCloud account to continue."
            case .networkError:
                return "Please check your internet connection and try again."
            case .serverError:
                return "Our servers are experiencing issues. Please try again later."
            case .unknownError:
                return "An unexpected error occurred. Please try again."
            }
        }

        let errorString = error.localizedDescription.lowercased()

        if errorString.contains("network") || errorString.contains("connection") {
            return "We couldn't connect to the internet. Please check your connection and tap 'Try Again'."
        } else if errorString.contains("permission") || errorString.contains("access") {
            return "You don't have permission to perform this action. Please check your settings."
        } else if errorString.contains("not found") {
            return "The requested resource could not be found."
        } else if errorString.contains("authentication") || errorString.contains("unauthorized") {
            return "Please sign in to continue using this feature."
        } else {
            return "An unexpected error occurred. Please try again or contact support if the problem persists."
        }
    }
}

struct NetworkStatusBanner: View {
    let isConnected: Bool
    var onRetry: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isConnected ? "wifi" : "wifi.slash")
                .foregroundColor(isConnected ? Color(hex: "34C759") : Color(hex: "FF3B30"))

            Text(isConnected ? "Connected" : "No Internet Connection")
                .font(.subheadline)

            if !isConnected {
                Button(action: onRetry) {
                    Text("Retry")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(Color(hex: "FF6B9D"))
                }
            }

            Spacer()
        }
        .padding()
        .background(isConnected ? Color(hex: "E8F5E9") : Color(hex: "FFEBEE"))
        .cornerRadius(8)
    }
}

struct SyncStatusIndicator: View {
    let status: SyncStatus
    var lastSyncDate: Date?

    enum SyncStatus {
        case synced
        case syncing
        case failed
        case pending

        var icon: String {
            switch self {
            case .synced: return "checkmark.circle.fill"
            case .syncing: return "arrow.triangle.2.circlepath"
            case .failed: return "xmark.circle.fill"
            case .pending: return "clock"
            }
        }

        var color: String {
            switch self {
            case .synced: return "34C759"
            case .syncing: return "007AFF"
            case .failed: return "FF3B30"
            case .pending: return "FF9500"
            }
        }

        var text: String {
            switch self {
            case .synced: return "Synced"
            case .syncing: return "Syncing..."
            case .failed: return "Sync Failed"
            case .pending: return "Pending Sync"
            }
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            if status == .syncing {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                Image(systemName: status.icon)
                    .foregroundColor(Color(hex: status.color))
            }

            Text(status.text)
                .font(.caption)

            if let lastSyncDate {
                Text("• \(lastSyncDate, style: .relative)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
