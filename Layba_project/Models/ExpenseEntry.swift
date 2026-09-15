import Foundation

struct ExpenseEntry: Identifiable {
    let id = UUID()
    var tripID: String
    var category: ExpenseCategory
    var vendor: String
    var plate: String
    var payMethod: PaymentMethod
    var amount: Double
    var notes: String
    var date: Date = Date()
}
