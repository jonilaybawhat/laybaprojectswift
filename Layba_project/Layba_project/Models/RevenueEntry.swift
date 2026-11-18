import Foundation
import SwiftData

// Saved in the SwiftData database
@Model
final class RevenueEntry {
    @Attribute(.unique) var id: UUID
    var accountID: String           // which account owns this entry
    var tripID: String
    var client: String
    var origin: String
    var destination: String
    var payMethodRaw: String        // saved as text in the database
    var amount: Double
    var notes: String
    var plate: String
    var date: Date

    // Use this in the app: turns the saved text back into PaymentMethod
    var payMethod: PaymentMethod {
        get { PaymentMethod(rawValue: payMethodRaw) ?? .cash }
        set { payMethodRaw = newValue.rawValue }
    }

    init(tripID: String, client: String, origin: String, destination: String,
         payMethod: PaymentMethod, amount: Double, notes: String, plate: String,
         date: Date = Date(), accountID: String = "") {
        self.id = UUID()
        self.accountID = accountID
        self.tripID = tripID
        self.client = client
        self.origin = origin
        self.destination = destination
        self.payMethodRaw = payMethod.rawValue
        self.amount = amount
        self.notes = notes
        self.plate = plate
        self.date = date
    }
}
