import SwiftUI

struct SettingsView: View {
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("useSystemAppearance") private var useSystemAppearance = true
    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled = false
    @State private var showOnboarding = false
    @State private var showClearDataAlert = false
    @State private var showExportSuccess = false
    @State private var isExporting = false
    @State private var isClearing = false

    @State private var showHelpCenter = false
    @State private var showContactSupport = false

    var body: some View {
        NavigationStack {
            Form {
                iCloudSection

                notificationSettingsSection

                appearanceSection

                skinProfileSection

                dataManagementSection

                supportSection

                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showOnboarding) {
                OnboardingView(hasCompleted: .constant(true))
            }
            .alert("Clear All Data", isPresented: $showClearDataAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This will permanently delete all your products, routines, and data. This action cannot be undone.")
            }
            .alert("Export Successful", isPresented: $showExportSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your data has been exported successfully.")
            }
            .onAppear {
            }
        }
    }

    private var iCloudSection: some View {
        Section(header: Text("iCloud Sync (Optional)"), footer: icloudFooter) {
            Toggle(isOn: $iCloudSyncEnabled) {
                Label("Enable iCloud Sync", systemImage: "icloud")
            }
            .onChange(of: iCloudSyncEnabled) { _, newValue in
                if newValue {
                    enableICloudSync()
                } else {
                    disableICloudSync()
                }
            }

            if iCloudSyncEnabled {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "34C759"))
                    Text("Syncing to iCloud...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                HStack {
                    Image(systemName: "iphone")
                        .foregroundColor(.secondary)
                    Text("Local storage only")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var icloudFooter: some View {
        Text(iCloudSyncEnabled
             ? "Your data will be synced across all your Apple devices. Requires iCloud account."
             : "Your data is stored locally on this device only. Enable sync to backup to iCloud.")
            .font(.caption)
            .foregroundColor(.secondary)
    }

    private func enableICloudSync() {
        Task {
            await iCloudStateManager.shared.checkStatus()
            if iCloudStateManager.shared.isICloudAvailable {
                print("iCloud sync enabled successfully")
            } else {
                iCloudSyncEnabled = false
                print("iCloud not available, sync disabled")
            }
        }
    }

    private func disableICloudSync() {
        print("iCloud sync disabled, using local storage")
    }

    private var notificationSettingsSection: some View {
        Section(header: Text("Notifications"), footer: Text("Configure when and how you receive product expiry alerts.")) {
            Toggle("Enable Notifications", isOn: $notificationsEnabled)
                .onChange(of: notificationsEnabled) { _, newValue in
                    Task {
                        if newValue {
                            _ = await NotificationManager.shared.requestAuthorization()
                        } else {
                            NotificationManager.shared.cancelAllNotifications()
                        }
                    }
                }

            NavigationLink(destination: NotificationSettingsDetailView()) {
                Label("Notification Preferences", systemImage: "bell.badge")
            }
        }
    }

    private var appearanceSection: some View {
        Section(header: Text("Appearance")) {
            Toggle("Use System Appearance", isOn: $useSystemAppearance)

            if !useSystemAppearance {
                Toggle("Dark Mode", isOn: $darkModeEnabled)
            }
        }
    }

    private var skinProfileSection: some View {
        Section(header: Text("Skin Profile")) {
            NavigationLink(destination: SkinProfileView()) {
                Label("My Skin Profile", systemImage: "person.crop.circle")
            }
        }
    }

    private var dataManagementSection: some View {
        Section(header: Text("Data Management"), footer: Text("Export your data as CSV or clear all stored information.")) {
            Button(action: exportData) {
                HStack {
                    Label("Export Data", systemImage: "square.and.arrow.up")
                    Spacer()
                    if isExporting {
                        ProgressView()
                    }
                }
            }
            .disabled(isExporting)

            Button(role: .destructive, action: { showClearDataAlert = true }) {
                HStack {
                    Label("Clear All Data", systemImage: "trash")
                    Spacer()
                    if isClearing {
                        ProgressView()
                    }
                }
            }
            .disabled(isClearing)
        }
    }

    private var supportSection: some View {
        Section(header: Text("Support & Help")) {
            Button(action: { showHelpCenter = true }) {
                Label("Help Center", systemImage: "book.fill")
            }

            Button(action: { showOnboarding = true }) {
                Label("Show Onboarding Guide", systemImage: "play.circle.fill")
            }

            Button(action: { showContactSupport = true }) {
                Label("Contact Support", systemImage: "envelope.fill")
            }
        }
        .sheet(isPresented: $showHelpCenter) {
            HelpCenterView()
        }
        .sheet(isPresented: $showContactSupport) {
            ContactSupportView()
        }
    }

    private var aboutSection: some View {
        Section(header: Text("About")) {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0 (Build 1)")
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Build Date")
                Spacer()
                Text("2026.04.07")
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Last Synced")
                Spacer()
                if iCloudSyncEnabled, let lastChecked = iCloudStateManager.shared.lastChecked {
                    Text(lastChecked, style: .relative)
                        .foregroundColor(.secondary)
                } else {
                    Text("Never")
                        .foregroundColor(.secondary)
                }
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/freshface-privacy/")!) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }

            Link(destination: URL(string: "https://asunnyboy861.github.io/freshface-terms/")!) {
                Label("Terms of Service", systemImage: "doc.text.fill")
            }

            Button(action: rateApp) {
                Label("Rate FreshFace", systemImage: "star.fill")
            }
        }
    }

    private func exportData() {
        isExporting = true

        Task {
            do {
                let products = try await CloudProductRepository().fetchAll()
                let csvString = generateCSV(from: products)

                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("FreshFace_Export_\(Date().formatted(.iso8601)).csv")
                try csvString.write(to: tempURL, atomically: true, encoding: .utf8)

                await MainActor.run {
                    isExporting = false
                    showExportSuccess = true
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                }
                print("Export error: \(error)")
            }
        }
    }

    private func generateCSV(from products: [Product]) -> String {
        var csv = "Name,Brand,Category,Type,Opened Date,Expiry Date,PAO (Months),Notes\n"

        for product in products {
            let name = product.name.replacingOccurrences(of: ",", with: ";")
            let brand = (product.brand ?? "").replacingOccurrences(of: ",", with: ";")
            let category = product.category.displayName
            let type = product.productType?.displayName ?? ""
            let openDate = product.openDate.map { ISO8601DateFormatter().string(from: $0) } ?? ""
            let expiryDate = product.expiryDate.map { ISO8601DateFormatter().string(from: $0) } ?? ""
            let pao = product.paoMonths.map { String($0) } ?? ""
            let notes = (product.notes ?? "").replacingOccurrences(of: ",", with: ";").replacingOccurrences(of: "\n", with: " ")

            csv += "\(name),\(brand),\(category),\(type),\(openDate),\(expiryDate),\(pao),\(notes)\n"
        }

        return csv
    }

    private func clearAllData() {
        isClearing = true

        Task {
            do {
                let localProductRepo = LocalProductRepository()
                let localRoutineRepo = LocalRoutineRepository()

                let products = try await localProductRepo.fetchAll()
                for product in products {
                    try await localProductRepo.delete(product)
                }

                let routines = try await localRoutineRepo.fetchAll()
                for routine in routines {
                    try await localRoutineRepo.delete(routine)
                }

                NotificationManager.shared.cancelAllNotifications()

                await MainActor.run {
                    isClearing = false
                }
            } catch {
                await MainActor.run {
                    isClearing = false
                }
                print("Clear data error: \(error)")
            }
        }
    }

    private func rateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id123456789?action=write-review") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
}
