import Foundation
import SwiftData

// Saved in the SwiftData database
@Model
final class ExpenseEntry {
    @Attribute(.unique) var id: UUID
    var accountID: String           // which account owns this entry
    var tripID: String
    var categoryRaw: String         // saved as text in the database
    var vendor: String
    var plate: String
    var payMethodRaw: String        // saved as text in the database
    var amount: Double
    var notes: String
    var date: Date

    // Use these in the app: turn the saved text back into enums
    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var payMethod: PaymentMethod {
        get { PaymentMethod(rawValue: payMethodRaw) ?? .cash }
        set { payMethodRaw = newValue.rawValue }
    }

    init(tripID: String, category: ExpenseCategory, vendor: String, plate: String,
         payMethod: PaymentMethod, amount: Double, notes: String,
         date: Date = Date(), accountID: String = "") {
        self.id = UUID()
        self.accountID = accountID
        self.tripID = tripID
        self.categoryRaw = category.rawValue
        self.vendor = vendor
        self.plate = plate
        self.payMethodRaw = payMethod.rawValue
        self.amount = amount
        self.notes = notes
        self.date = date
    }
}
