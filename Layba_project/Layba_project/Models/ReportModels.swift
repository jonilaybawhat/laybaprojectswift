import Foundation

// MARK: - Grouped lists (Revenue / Expenses screens)

struct MonthGroup: Identifiable {
    let label: String
    let entries: [RevenueEntry]
    var id: String { label }
    var total: Double { entries.reduce(0) { $0 + $1.amount } }
}

struct ExpenseMonthGroup: Identifiable {
    let label: String
    let entries: [ExpenseEntry]
    var id: String { label }
    var total: Double { entries.reduce(0) { $0 + $1.amount } }
}

// MARK: - Report building blocks

struct PeriodSummary {
    let revenue: Double
    let expense: Double
    var net: Double { revenue - expense }
}

struct DeltaBadge {
    let text: String
    let isPositive: Bool
}

struct DayTotal: Identifiable {
    let day: String
    let revenue: Double
    let expense: Double
    var id: String { day }
}

struct RankedItem: Identifiable {
    let name: String
    let amount: Double
    var id: String { name }
}

struct CategoryTotal: Identifiable {
    let category: ExpenseCategory
    let amount: Double
    var id: String { category.rawValue }
}

struct CategoryShare: Identifiable {
    let category: ExpenseCategory
    let amount: Double
    let percent: Double
    var id: String { category.rawValue }
}

struct WeekReport {
    let label: String
    let summary: PeriodSummary
    let deltaPercent: Double?
    let days: [DayTotal]
    let topClients: [RankedItem]
    let topCategories: [CategoryTotal]
}

struct WeekRow: Identifiable {
    let title: String
    let revenue: Double
    let expense: Double
    let net: Double
    var id: String { title }
}

struct CumulativePoint: Identifiable {
    let label: String
    let net: Double
    var id: String { label }
}

struct MonthReport {
    let label: String
    let opening: Double
    let closing: Double
    let cumulative: [CumulativePoint]
    let weeks: [WeekRow]
    let insight: String
}

struct MonthTotal: Identifiable {
    let label: String
    let fullName: String
    let revenue: Double
    let expense: Double
    var net: Double { revenue - expense }
    var id: String { label }
}
