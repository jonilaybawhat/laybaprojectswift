import Foundation
import CryptoKit

// Passwords are never stored as plain text. Only the SHA256 hash is saved.
enum PasswordHasher {
    static func hash(_ password: String) -> String {
        let digest = SHA256.hash(data: Data(("freightfolio." + password).utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
