import Foundation
import CloudKit
import UIKit

@MainActor
class iCloudStateManager: ObservableObject {
    static let shared = iCloudStateManager()

    @Published var status: iCloudStatus = .checking
    @Published var lastChecked: Date?

    enum iCloudStatus: String, CaseIterable {
        case checking = "Checking..."
        case available = "Available"
        case unavailable = "Unavailable"
        case notConfigured = "Not Configured"
        case networkError = "Network Error"

        var icon: String {
            switch self {
            case .checking:
                return "arrow.triangle.2.circlepath"
            case .available:
                return "icloud"
            case .unavailable, .notConfigured:
                return "icloud.slash"
            case .networkError:
                return "wifi.slash"
            }
        }

        var color: String {
            switch self {
            case .available:
                return "34C759"
            case .checking, .networkError:
                return "FF9500"
            default:
                return "FF3B30"
            }
        }

        var isAccessible: Bool {
            self == .available
        }
    }

    private init() {}

    func checkStatus() async {
        status = .checking

        do {
            let accountStatus = try await CloudKitManager.shared.getAccountStatus()

            switch accountStatus {
            case .available:
                status = .available
            case .noAccount:
                status = .notConfigured
            case .restricted, .temporarilyUnavailable:
                status = .unavailable
            @unknown default:
                status = .unavailable
            }

            lastChecked = Date()
        } catch {
            if error.localizedDescription.contains("network") ||
               error.localizedDescription.contains("connection") {
                status = .networkError
            } else {
                status = .unavailable
            }
        }
    }

    func refreshIfNeeded() async {
        guard let lastCheckedTime = lastChecked else {
            await checkStatus()
            return
        }

        let timeSinceLastCheck = Date().timeIntervalSince(lastCheckedTime)

        if timeSinceLastCheck > 30 {
            await checkStatus()
        }
    }

    var isICloudAvailable: Bool {
        status == .available
    }

    var shouldShowSetupGuide: Bool {
        status == .notConfigured || status == .unavailable
    }

    var errorMessage: String? {
        switch status {
        case .notConfigured:
            return "iCloud is not configured on this device. Please sign in to your iCloud account in Settings."
        case .unavailable:
            return "iCloud is currently unavailable. Please check your internet connection and try again."
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .checking:
            return nil
        case .available:
            return nil
        }
    }

    func openICloudSettings() {
        if let url = URL(string: "App-prefs:root=APPLE_ACCOUNT") {
            UIApplication.shared.open(url)
        } else if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
