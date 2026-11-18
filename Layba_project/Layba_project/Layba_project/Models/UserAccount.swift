import Foundation
import SwiftData

// Saved in the SwiftData database. Each account has its own ID.
@Model
final class UserAccount {
    @Attribute(.unique) var id: UUID
    var company: String
    var owner: String
    var username: String
    var passwordHash: String

    init(company: String, owner: String, username: String, passwordHash: String) {
        self.id = UUID()
        self.company = company
        self.owner = owner
        self.username = username
        self.passwordHash = passwordHash
    }
}
