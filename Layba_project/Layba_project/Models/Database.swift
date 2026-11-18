import Foundation
import SwiftData

enum Database {
    static let container: ModelContainer = {
        let schema = Schema([RevenueEntry.self, ExpenseEntry.self, UserAccount.self, AppNotification.self])
        let config = ModelConfiguration(schema: schema)

        if let container = try? ModelContainer(for: schema, configurations: [config]) {
            return container
        }

        for suffix in ["", "-shm", "-wal"] {
            try? FileManager.default.removeItem(atPath: config.url.path + suffix)
        }

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create the database: \(error)")
        }
    }()
}
