import Foundation
import Combine
import SwiftData

// Main data controller. Reads and writes the logged-in account's revenue and expenses in SwiftData.
final class AppData: ObservableObject {
    private let context: ModelContext
    private var accountID: String?      // the account that is logged in

    @Published private(set) var revenueEntries: [RevenueEntry] = []
    @Published private(set) var expenseEntries: [ExpenseEntry] = []

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: Database

    // Called when someone logs in or out
    func load(accountID: String?) {
        self.accountID = accountID
        reload()
    }

    // Only fetch the entries that belong to the logged-in account
    private func reload() {
        guard let id = accountID else {
            revenueEntries = []
            expenseEntries = []
            return
        }
        let revenueQuery = FetchDescriptor<RevenueEntry>(
            predicate: #Predicate<RevenueEntry> { $0.accountID == id },
            sortBy: [SortDescriptor(\.date, order: .reverse)])
        let expenseQuery = FetchDescriptor<ExpenseEntry>(
            predicate: #Predicate<ExpenseEntry> { $0.accountID == id },
            sortBy: [SortDescriptor(\.date, order: .reverse)])
        revenueEntries = (try? context.fetch(revenueQuery)) ?? []
        expenseEntries = (try? context.fetch(expenseQuery)) ?? []
    }

    func addRevenue(_ entry: RevenueEntry) {
        guard let id = accountID else { return }
        entry.accountID = id
        context.insert(entry)
        try? context.save()
        reload()
    }

    func addExpense(_ entry: ExpenseEntry) {
        guard let id = accountID else { return }
        entry.accountID = id
        context.insert(entry)
        try? context.save()
        reload()
    }

    // MARK: Reports

    var reports: ReportController {
        ReportController(revenue: revenueEntries, expenses: expenseEntries)
    }

    // MARK: Totals

    var totalRevenue: Double { revenueEntries.reduce(0) { $0 + $1.amount } }
    var totalExpenses: Double { expenseEntries.reduce(0) { $0 + $1.amount } }
    var netCashFlow: Double { totalRevenue - totalExpenses }

    // This month only (Home screen)
    var monthSummary: PeriodSummary {
        reports.total(reports.monthInterval(offset: 0))
    }

    var monthDelta: DeltaBadge? {
        let current = monthSummary.net
        let previous = reports.total(reports.monthInterval(offset: -1)).net
        guard previous != 0 else { return nil }
        let percent = (current - previous) / abs(previous) * 100
        let arrow = percent >= 0 ? "▲" : "▼"
        return DeltaBadge(text: "\(arrow)\(Int(abs(percent).rounded()))% vs last month", isPositive: percent >= 0)
    }

    // Expense total for a category in the current month
    func expenseTotal(for category: ExpenseCategory) -> Double {
        let month = reports.monthInterval(offset: 0)
        return expenseEntries
            .filter { $0.category == category && $0.date >= month.start && $0.date < month.end }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: Trip IDs

    // Newest trip first (TRIP-016, TRIP-015, ...)
    var allTripIDs: [String] {
        let ids = Set(revenueEntries.map { $0.tripID } + expenseEntries.map { $0.tripID })
        return ids.filter { !$0.isEmpty }.sorted { $0 > $1 }
    }

    func nextTripID() -> String {
        let numbers = allTripIDs.compactMap { Int($0.replacingOccurrences(of: "TRIP-", with: "")) }
        return String(format: "TRIP-%03d", (numbers.max() ?? 0) + 1)
    }

    // MARK: Grouping for lists

    var revenueByMonth: [MonthGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: revenueEntries) { formatter.string(from: $0.date) }
        return grouped.map { key, entries in
            MonthGroup(label: key, entries: entries.sorted { $0.date > $1.date })
        }.sorted { ($0.entries.first?.date ?? .distantPast) > ($1.entries.first?.date ?? .distantPast) }
    }

    var expenseByMonth: [ExpenseMonthGroup] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        let grouped = Dictionary(grouping: expenseEntries) { formatter.string(from: $0.date) }
        return grouped.map { key, entries in
            ExpenseMonthGroup(label: key, entries: entries.sorted { $0.date > $1.date })
        }.sorted { ($0.entries.first?.date ?? .distantPast) > ($1.entries.first?.date ?? .distantPast) }
    }

    // Last 7 days for the Home chart
    var weekData: [DayTotal] { reports.lastDays(7) }
}
