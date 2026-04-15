import Foundation
import CloudKit

class CloudUsageLogRepository: UsageLogRepositoryProtocol {

    private let database: CKDatabase
    private let recordType = "UsageLog"

    init(database: CKDatabase = CloudKitManager.shared.privateDatabase) {
        self.database = database
    }

    func fetch(for productId: UUID) async throws -> [UsageLog] {
        let predicate = NSPredicate(format: "productId == %@", productId.uuidString)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let (matchResults, _) = try await database.records(matching: query)

        var logs: [UsageLog] = []
        for (_, result) in matchResults {
            if case .success(let record) = result,
               let log = usageLogFromRecord(record) {
                logs.append(log)
            }
        }
        return logs
    }

    func create(_ log: UsageLog) async throws -> UsageLog {
        let record = recordFromUsageLog(log)
        let savedRecord = try await database.save(record)
        return usageLogFromRecord(savedRecord) ?? log
    }

    func delete(_ log: UsageLog) async throws {
        let recordID = CKRecord.ID(recordName: log.id.uuidString)
        try await database.deleteRecord(withID: recordID)
    }

    private func recordFromUsageLog(_ log: UsageLog) -> CKRecord {
        let record = CKRecord(recordType: recordType, recordID: CKRecord.ID(recordName: log.id.uuidString))

        record["id"] = log.id.uuidString
        record["productId"] = log.productId.uuidString
        record["date"] = log.date
        record["notes"] = log.notes
        record["skinCondition"] = log.skinCondition
        record["createdAt"] = log.createdAt

        return record
    }

    private func usageLogFromRecord(_ record: CKRecord) -> UsageLog? {
        guard let idString = record["id"] as? String,
              let id = UUID(uuidString: idString),
              let productIdString = record["productId"] as? String,
              let productId = UUID(uuidString: productIdString),
              let date = record["date"] as? Date else {
            return nil
        }

        return UsageLog(
            id: id,
            productId: productId,
            date: date,
            notes: record["notes"] as? String,
            skinCondition: record["skinCondition"] as? String,
            createdAt: record["createdAt"] as? Date ?? Date()
        )
    }
}
