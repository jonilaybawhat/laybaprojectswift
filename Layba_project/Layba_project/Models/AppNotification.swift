import Foundation
import SwiftData

@Model
final class AppNotification {
    @Attribute(.unique) var id: UUID
    var accountID: String    
    var kind: String
    var title: String
    var message: String
    var date: Date
    var isRead: Bool
    var key: String

    init(accountID: String, kind: String, title: String, message: String, key: String = "") {
        self.id = UUID()
        self.accountID = accountID
        self.kind = kind
        self.title = title
        self.message = message
        self.date = Date()
        self.isRead = false
        self.key = key
    }
}
