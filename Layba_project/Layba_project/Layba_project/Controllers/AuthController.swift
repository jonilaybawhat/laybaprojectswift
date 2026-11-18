import Foundation
import Combine
import SwiftData

// Handles sign up, login, logout and changing username/password.
// Many accounts can be saved; only one is logged in at a time.
final class AuthController: ObservableObject {
    private let context: ModelContext

    @Published private(set) var account: UserAccount?   // the logged-in account
    @Published private(set) var hasAccount = false      // is there at least one account saved?
    @Published var isLoggedIn = false
    @Published var showOnboarding = false

    init(context: ModelContext) {
        self.context = context
        hasAccount = !allAccounts().isEmpty
    }

    var accountID: String? { account?.id.uuidString }
    var company: String { account?.company ?? "" }
    var owner: String { account?.owner ?? "" }
    var username: String { account?.username ?? "" }

    // Initials for the monogram badge, e.g. "Joman Company" -> "JC"
    var monogram: String {
        let letters = company.split(separator: " ").prefix(2).compactMap { $0.first }
        let text = String(letters).uppercased()
        return text.isEmpty ? "FF" : text
    }

    // MARK: Database helpers

    private func allAccounts() -> [UserAccount] {
        (try? context.fetch(FetchDescriptor<UserAccount>())) ?? []
    }

    private func findAccount(username: String) -> UserAccount? {
        let key = username.trimmingCharacters(in: .whitespaces).lowercased()
        return allAccounts().first { $0.username.lowercased() == key }
    }

    // MARK: Sign up / login / logout

    // Returns an error message, or nil when it worked.
    func register(company: String, owner: String, username: String, password: String) -> String? {
        let user = username.trimmingCharacters(in: .whitespaces)
        guard !user.isEmpty else { return "Please enter a username." }
        guard password.count >= 6 else { return "Password must be at least 6 characters." }
        guard findAccount(username: user) == nil else { return "That username is already taken." }

        let new = UserAccount(company: company.trimmingCharacters(in: .whitespaces),
                              owner: owner.trimmingCharacters(in: .whitespaces),
                              username: user,
                              passwordHash: PasswordHasher.hash(password))
        context.insert(new)
        try? context.save()

        account = new
        hasAccount = true
        showOnboarding = false
        isLoggedIn = true
        return nil
    }

    func login(username: String, password: String) -> Bool {
        guard let found = findAccount(username: username),
              found.passwordHash == PasswordHasher.hash(password) else { return false }
        account = found
        isLoggedIn = true
        return true
    }

    func logout() {
        isLoggedIn = false
        account = nil
    }

    // MARK: Change username / password

    // Returns an error message, or nil when it worked. Leave newPassword empty to keep the old one.
    func updateCredentials(currentPassword: String, newUsername: String, newPassword: String) -> String? {
        guard let current = account else { return "No account found." }
        guard current.passwordHash == PasswordHasher.hash(currentPassword) else { return "Current password is incorrect." }
        let user = newUsername.trimmingCharacters(in: .whitespaces)
        guard !user.isEmpty else { return "Username cannot be empty." }
        if let other = findAccount(username: user), other.id != current.id {
            return "That username is already taken."
        }
        if !newPassword.isEmpty {
            guard newPassword.count >= 6 else { return "New password must be at least 6 characters." }
            current.passwordHash = PasswordHasher.hash(newPassword)
        }
        current.username = user
        try? context.save()
        objectWillChange.send()   // refresh screens that show the username
        return nil
    }
}
