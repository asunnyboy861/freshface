import Foundation

struct RoutineStep: Identifiable, Codable, Hashable {
    let id: UUID
    var productId: UUID?
    var productName: String
    var stepOrder: Int
    var waitTimeSeconds: Int?
    var isCompleted: Bool
    var notes: String?

    init(
        id: UUID = UUID(),
        productId: UUID? = nil,
        productName: String,
        stepOrder: Int,
        waitTimeSeconds: Int? = nil,
        isCompleted: Bool = false,
        notes: String? = nil
    ) {
        self.id = id
        self.productId = productId
        self.productName = productName
        self.stepOrder = stepOrder
        self.waitTimeSeconds = waitTimeSeconds
        self.isCompleted = isCompleted
        self.notes = notes
    }

    var waitTimeFormatted: String? {
        guard let seconds = waitTimeSeconds, seconds > 0 else { return nil }

        if seconds < 60 {
            return "\(seconds)s"
        } else {
            let minutes = seconds / 60
            let remainingSeconds = seconds % 60
            if remainingSeconds == 0 {
                return "\(minutes)m"
            } else {
                return "\(minutes)m \(remainingSeconds)s"
            }
        }
    }
}
