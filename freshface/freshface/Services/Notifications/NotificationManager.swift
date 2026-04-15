import Foundation
import UserNotifications

class NotificationManager: ObservableObject {

    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge]
            )
            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func scheduleExpiryNotifications(for product: Product) {
        guard let daysRemaining = product.daysRemaining else { return }

        let notificationDays = [30, 14, 7, 3, 1]

        for days in notificationDays {
            if daysRemaining > 0 && daysRemaining <= days {
                scheduleNotification(
                    for: product,
                    daysBefore: days,
                    daysRemaining: daysRemaining
                )
            }
        }

        if daysRemaining <= 0 && !product.isActive {
            scheduleExpiredNotification(for: product)
        }
    }

    private func scheduleNotification(for product: Product, daysBefore: Int, daysRemaining: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Product Expiring Soon"
        content.body = "\(product.name) expires in \(daysRemaining) day\(daysRemaining == 1 ? "" : "s")"
        content.sound = .default
        content.userInfo = ["productId": product.id.uuidString]
        content.categoryIdentifier = "EXPIRY_REMINDER"

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(daysBefore * 24 * 60 * 60),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "expiry-\(product.id.uuidString)-\(daysBefore)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleExpiredNotification(for product: Product) {
        let content = UNMutableNotificationContent()
        content.title = "Product Expired"
        content.body = "\(product.name) has expired. Please discard it safely."
        content.sound = .default
        content.userInfo = ["productId": product.id.uuidString]
        content.categoryIdentifier = "PRODUCT_EXPIRED"

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 60,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "expired-\(product.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func cancelNotification(for productId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["expiry-\(productId.uuidString)"]
        )
    }
}
