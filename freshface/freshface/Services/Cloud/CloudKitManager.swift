import Foundation
import CloudKit

class CloudKitManager: ObservableObject {

    static let shared = CloudKitManager()

    private let container: CKContainer

    var privateDatabase: CKDatabase {
        container.privateCloudDatabase
    }

    func getAccountStatus() async throws -> CKAccountStatus {
        try await container.accountStatus()
    }

    private init() {
        container = CKContainer(identifier: "iCloud.com.zzoutuo.freshface")
    }

    enum CloudKitError: Error {
        case notAuthenticated
        case networkError
        case serverError
        case unknownError
    }

    func checkAccountStatus() async -> Bool {
        do {
            let status = try await container.accountStatus()
            return status == .available
        } catch {
            print("CloudKit account status error: \(error)")
            return false
        }
    }
}
