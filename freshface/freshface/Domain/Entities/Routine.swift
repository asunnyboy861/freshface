import Foundation

struct Routine: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var routineType: RoutineType
    var time: Date?
    var steps: [RoutineStep]
    var isActive: Bool
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        routineType: RoutineType,
        time: Date? = nil,
        steps: [RoutineStep] = [],
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.routineType = routineType
        self.time = time
        self.steps = steps
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum RoutineType: String, CaseIterable, Codable {
    case morning = "Morning"
    case evening = "Evening"
    case custom = "Custom"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .morning: return "sunrise.fill"
        case .evening: return "moon.stars.fill"
        case .custom: return "star.fill"
        }
    }
}
