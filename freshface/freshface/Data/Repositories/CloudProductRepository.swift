import Foundation
import CloudKit

class CloudProductRepository: ProductRepositoryProtocol {
    
    private let database: CKDatabase
    private let recordType = "Product"
    
    init(database: CKDatabase = CloudKitManager.shared.privateDatabase) {
        self.database = database
    }
    
    func fetchAll() async throws -> [Product] {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        
        let (matchResults, _) = try await database.records(matching: query)
        
        var products: [Product] = []
        for (_, result) in matchResults {
            switch result {
            case .success(let record):
                if let product = productFromRecord(record) {
                    products.append(product)
                }
            case .failure(let error):
                print("Error fetching record: \(error)")
            }
        }
        return products
    }
    
    func fetch(byId id: UUID) async throws -> Product? {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        
        do {
            let record = try await database.record(for: recordID)
            return productFromRecord(record)
        } catch {
            return nil
        }
    }
    
    func create(_ product: Product) async throws -> Product {
        let record = recordFromProduct(product)
        let savedRecord = try await database.save(record)
        return productFromRecord(savedRecord) ?? product
    }
    
    func update(_ product: Product) async throws -> Product {
        let recordID = CKRecord.ID(recordName: product.id.uuidString)
        
        do {
            let existingRecord = try await database.record(for: recordID)
            let updatedRecord = updateRecord(existingRecord, with: product)
            let savedRecord = try await database.save(updatedRecord)
            return productFromRecord(savedRecord) ?? product
        } catch {
            throw error
        }
    }
    
    func delete(_ product: Product) async throws {
        let recordID = CKRecord.ID(recordName: product.id.uuidString)
        try await database.deleteRecord(withID: recordID)
    }
    
    func fetchExpiring() async throws -> [Product] {
        let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date())!
        let predicate = NSPredicate(format: "expiryDate <= %@ AND expiryDate >= %@", thirtyDaysFromNow as NSDate, Date() as NSDate)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let (matchResults, _) = try await database.records(matching: query)
        
        var products: [Product] = []
        for (_, result) in matchResults {
            if case .success(let record) = result,
               let product = productFromRecord(record) {
                products.append(product)
            }
        }
        return products
    }
    
    func search(query: String) async throws -> [Product] {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR brand CONTAINS[cd] %@", query, query)
        let ckQuery = CKQuery(recordType: recordType, predicate: predicate)
        
        let (matchResults, _) = try await database.records(matching: ckQuery)
        
        var products: [Product] = []
        for (_, result) in matchResults {
            if case .success(let record) = result,
               let product = productFromRecord(record) {
                products.append(product)
            }
        }
        return products
    }
    
    func filter(by category: ProductCategory?) async throws -> [Product] {
        guard let category else { return try await fetchAll() }
        
        let predicate = NSPredicate(format: "category == %@", category.rawValue)
        let ckQuery = CKQuery(recordType: recordType, predicate: predicate)
        
        let (matchResults, _) = try await database.records(matching: ckQuery)
        
        var products: [Product] = []
        for (_, result) in matchResults {
            if case .success(let record) = result,
               let product = productFromRecord(record) {
                products.append(product)
            }
        }
        return products
    }
    
    private func recordFromProduct(_ product: Product) -> CKRecord {
        let record = CKRecord(recordType: recordType, recordID: CKRecord.ID(recordName: product.id.uuidString))
        
        record["id"] = product.id.uuidString
        record["name"] = product.name
        record["brand"] = product.brand
        record["category"] = product.category.rawValue
        
        if let productType = product.productType {
            record["productType"] = productType.rawValue
        }
        
        record["purchaseDate"] = product.purchaseDate
        record["openDate"] = product.openDate
        record["expiryDate"] = product.expiryDate
        record["paoMonths"] = product.paoMonths
        
        if let imageData = product.imageData {
            record["imageData"] = imageData
        }
        
        record["barcode"] = product.barcode
        record["notes"] = product.notes
        record["usageFrequency"] = product.usageFrequency
        record["estimatedRemaining"] = product.estimatedRemaining
        record["isActive"] = product.isActive
        record["createdAt"] = product.createdAt
        record["updatedAt"] = product.updatedAt
        
        return record
    }
    
    private func updateRecord(_ record: CKRecord, with product: Product) -> CKRecord {
        record["name"] = product.name
        record["brand"] = product.brand
        record["category"] = product.category.rawValue
        record["productType"] = product.productType?.rawValue
        record["purchaseDate"] = product.purchaseDate
        record["openDate"] = product.openDate
        record["expiryDate"] = product.expiryDate
        record["paoMonths"] = product.paoMonths
        record["imageData"] = product.imageData
        record["barcode"] = product.barcode
        record["notes"] = product.notes
        record["usageFrequency"] = product.usageFrequency
        record["estimatedRemaining"] = product.estimatedRemaining
        record["isActive"] = product.isActive
        record["updatedAt"] = Date()
        
        return record
    }
    
    private func productFromRecord(_ record: CKRecord) -> Product? {
        guard let idString = record["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = record["name"] as? String,
              let categoryString = record["category"] as? String,
              let category = ProductCategory(rawValue: categoryString) else {
            return nil
        }
        
        let productTypeString = record["productType"] as? String
        let productType = productTypeString.flatMap { ProductType(rawValue: $0) }
        
        return Product(
            id: id,
            name: name,
            brand: record["brand"] as? String,
            category: category,
            productType: productType,
            purchaseDate: record["purchaseDate"] as? Date,
            openDate: record["openDate"] as? Date,
            expiryDate: record["expiryDate"] as? Date,
            paoMonths: record["paoMonths"] as? Int,
            imageData: record["imageData"] as? Data,
            barcode: record["barcode"] as? String,
            notes: record["notes"] as? String,
            usageFrequency: record["usageFrequency"] as? Int,
            estimatedRemaining: record["estimatedRemaining"] as? Double,
            isActive: record["isActive"] as? Bool ?? true,
            createdAt: record["createdAt"] as? Date ?? Date(),
            updatedAt: record["updatedAt"] as? Date ?? Date()
        )
    }
}
