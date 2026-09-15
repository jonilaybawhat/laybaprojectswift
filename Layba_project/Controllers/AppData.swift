import Foundation
import Combine

final class AppData: ObservableObject {
    @Published var revenueEntries: [RevenueEntry] = [
        RevenueEntry(tripID: "TRIP-001", client: "San Miguel Corp", origin: "Batangas", destination: "Manila", payMethod: .cash, amount: 18500, notes: "Delivered on time", plate: "NGP 2049"),
        RevenueEntry(tripID: "TRIP-002", client: "Jollibee Foods Corp", origin: "Pampanga", destination: "Pasig", payMethod: .gcash, amount: 22000, notes: "", plate: "NGP 2049")
    ]
    @Published var expenseEntries: [ExpenseEntry] = [
        ExpenseEntry(tripID: "TRIP-001", category: .fuel, vendor: "Petron", plate: "NGP 2049", payMethod: .cash, amount: 4200, notes: "Full tank before Batangas run"),
        ExpenseEntry(tripID: "TRIP-002", category: .toll, vendor: "NLEX", plate: "NGP 2049", payMethod: .cash, amount: 680, notes: "NLEX southbound")
    ]

    var totalRevenue: Double { revenueEntries.reduce(0) { $0 + $1.amount } }
    var totalExpenses: Double { expenseEntries.reduce(0) { $0 + $1.amount } }
    var netCashFlow: Double { totalRevenue - totalExpenses }

    func expenseTotal(for category: ExpenseCategory) -> Double {
        expenseEntries.filter { $0.category == category }.reduce(0) { $0 + $1.amount }
    }

    // Existing trip ids across both revenue & expenses — for suggestion chips
    var allTripIDs: [String] {
        let ids = Set(revenueEntries.map { $0.tripID } + expenseEntries.map { $0.tripID })
        return ids.filter { !$0.isEmpty }.sorted()
    }

    struct MonthGroup: Identifiable {
        let id = UUID()
        let label: String
        let entries: [RevenueEntry]
        var total: Double { entries.reduce(0) { $0 + $1.amount } }
    }

    var revenueByMonth: [MonthGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: revenueEntries) { formatter.string(from: $0.date) }
        return grouped.map { key, entries in
            MonthGroup(label: key, entries: entries.sorted { $0.date > $1.date })
        }.sorted { ($0.entries.first?.date ?? .distantPast) > ($1.entries.first?.date ?? .distantPast) }
    }

    struct DayTotal: Identifiable {
        let id = UUID()
        let day: String
        let revenue: Double
        let expense: Double
    }

    var weekData: [DayTotal] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let days = (0..<7).map { calendar.date(byAdding: .day, value: -$0, to: Date())! }.reversed()
        return days.map { day in
            let rev = revenueEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            let exp = expenseEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            return DayTotal(day: formatter.string(from: day), revenue: rev, expense: exp)
        }
    }
}
