import Foundation

class LocalRoutineRepository: RoutineRepositoryProtocol {

    private let routinesKey = "freshface_routines"

    init() {}

    private var savedRoutines: [Routine] {
        get {
            guard let data = UserDefaults.standard.data(forKey: routinesKey) else {
                return []
            }
            return (try? JSONDecoder().decode([Routine].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: routinesKey)
            }
        }
    }

    func fetchAll() async throws -> [Routine] {
        return savedRoutines
    }

    func fetch(byId id: UUID) async throws -> Routine? {
        return savedRoutines.first { $0.id == id }
    }

    func create(_ routine: Routine) async throws -> Routine {
        var routines = savedRoutines
        routines.append(routine)
        savedRoutines = routines
        return routine
    }

    func update(_ routine: Routine) async throws -> Routine {
        var routines = savedRoutines
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            routines[index] = routine
            savedRoutines = routines
        }
        return routine
    }

    func delete(_ routine: Routine) async throws {
        var routines = savedRoutines
        routines.removeAll { $0.id == routine.id }
        savedRoutines = routines
    }

    func clearAll() {
        savedRoutines = []
    }
}
