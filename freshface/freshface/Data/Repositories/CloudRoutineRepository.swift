import Foundation
import CloudKit

class CloudRoutineRepository: RoutineRepositoryProtocol {

    private let database: CKDatabase
    private let recordType = "Routine"

    init(database: CKDatabase = CloudKitManager.shared.privateDatabase) {
        self.database = database
    }

    func fetchAll() async throws -> [Routine] {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]

        let (matchResults, _) = try await database.records(matching: query)

        var routines: [Routine] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                if let routine = routineFromRecord(record) {
                    routines.append(routine)
                }
            case .failure(let error):
                print("Error fetching routine: \(error)")
            }
        }
        return routines
    }

    func fetch(byId id: UUID) async throws -> Routine? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        do {
            let record = try await database.record(for: recordID)
            return routineFromRecord(record)
        } catch {
            return nil
        }
    }

    func create(_ routine: Routine) async throws -> Routine {
        let record = recordFromRoutine(routine)
        let savedRecord = try await database.save(record)
        return routineFromRecord(savedRecord) ?? routine
    }

    func update(_ routine: Routine) async throws -> Routine {
        let recordID = CKRecord.ID(recordName: routine.id.uuidString)
        do {
            let existingRecord = try await database.record(for: recordID)
            let updatedRecord = updateRecord(existingRecord, with: routine)
            let savedRecord = try await database.save(updatedRecord)
            return routineFromRecord(savedRecord) ?? routine
        } catch {
            throw error
        }
    }

    func delete(_ routine: Routine) async throws {
        let recordID = CKRecord.ID(recordName: routine.id.uuidString)
        try await database.deleteRecord(withID: recordID)
    }

    private func recordFromRoutine(_ routine: Routine) -> CKRecord {
        let record = CKRecord(recordType: recordType, recordID: CKRecord.ID(recordName: routine.id.uuidString))

        record["id"] = routine.id.uuidString
        record["name"] = routine.name
        record["routineType"] = routine.routineType.rawValue
        record["time"] = routine.time
        record["isActive"] = routine.isActive
        record["createdAt"] = routine.createdAt
        record["updatedAt"] = Date()

        if !routine.steps.isEmpty {
            if let stepsData = try? JSONEncoder().encode(routine.steps) {
                record["stepsData"] = stepsData
            }
        }

        return record
    }

    private func updateRecord(_ record: CKRecord, with routine: Routine) -> CKRecord {
        record["name"] = routine.name
        record["routineType"] = routine.routineType.rawValue
        record["time"] = routine.time
        record["isActive"] = routine.isActive
        record["updatedAt"] = Date()

        if !routine.steps.isEmpty {
            if let stepsData = try? JSONEncoder().encode(routine.steps) {
                record["stepsData"] = stepsData
            }
        } else {
            record["stepsData"] = nil
        }

        return record
    }

    private func routineFromRecord(_ record: CKRecord) -> Routine? {
        guard let idString = record["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = record["name"] as? String,
              let routineTypeString = record["routineType"] as? String,
              let routineType = RoutineType(rawValue: routineTypeString),
              let isActive = record["isActive"] as? Bool,
              let createdAt = record["createdAt"] as? Date else {
            return nil
        }

        var steps: [RoutineStep] = []
        if let stepsData = record["stepsData"] as? Data {
            steps = (try? JSONDecoder().decode([RoutineStep].self, from: stepsData)) ?? []
        }

        return Routine(
            id: id,
            name: name,
            routineType: routineType,
            time: record["time"] as? Date,
            steps: steps,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: record["updatedAt"] as? Date ?? Date()
        )
    }
}
