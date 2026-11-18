import Foundation
import SwiftData

// One shared SwiftData database for the whole app
enum Database {
    static let container: ModelContainer = {
        let schema = Schema([RevenueEntry.self, ExpenseEntry.self, UserAccount.self])
        let config = ModelConfiguration(schema: schema)

        // Normal case: open the database
        if let container = try? ModelContainer(for: schema, configurations: [config]) {
            return container
        }

        // The old database no longer matches the models: delete it and start fresh
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
