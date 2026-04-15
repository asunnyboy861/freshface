import SwiftUI

struct NotificationSettingsDetailView: View {
    @AppStorage("expiryAlertsEnabled") private var expiryAlertsEnabled = true
    @AppStorage("routineRemindersEnabled") private var routineRemindersEnabled = true
    @AppStorage("weeklyDigestEnabled") private var weeklyDigestEnabled = false
    @AppStorage("expiryAlertDays") private var expiryAlertDays = 7
    @AppStorage("quietHoursEnabled") private var quietHoursEnabled = false
    @State private var quietHoursStart: Date = {
        var components = DateComponents()
        components.hour = 22
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    @State private var quietHoursEnd: Date = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()

    var body: some View {
        Form {
            notificationTypesSection
            advancedSettingsSection
            quietHoursSection
        }
        .navigationTitle("Notification Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var notificationTypesSection: some View {
        Section(header: Text("Notification Types")) {
            Toggle(isOn: $expiryAlertsEnabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expiry Alerts")
                        .font(.body)
                    Text("Get reminded before products expire")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Toggle(isOn: $routineRemindersEnabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Routine Reminders")
                        .font(.body)
                    Text("Daily reminders for your skincare routines")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Toggle(isOn: $weeklyDigestEnabled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Weekly Digest")
                        .font(.body)
                    Text("Summary of your product status")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var advancedSettingsSection: some View {
        Section(header: Text("Advanced Settings")) {
            Picker("Expiry Alert Days", selection: $expiryAlertDays) {
                Text("3 days before").tag(3)
                Text("7 days before").tag(7)
                Text("14 days before").tag(14)
                Text("30 days before").tag(30)
            }

            Stepper("Alert Days: \(expiryAlertDays)",
                    value: $expiryAlertDays,
                    in: 1...30)
        }
    }

    private var quietHoursSection: some View {
        Section(header: Text("Quiet Hours")) {
            Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)

            if quietHoursEnabled {
                DatePicker("From",
                           selection: $quietHoursStart,
                           displayedComponents: .hourAndMinute)

                DatePicker("To",
                           selection: $quietHoursEnd,
                           displayedComponents: .hourAndMinute)
            }
        }
    }
}

struct NotificationSettingsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationSettingsDetailView()
        }
    }
}
