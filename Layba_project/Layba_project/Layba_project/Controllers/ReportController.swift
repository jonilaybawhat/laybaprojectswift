import Foundation

// Builds all numbers for the Reports and Charts screens.
// Weeks start on Monday.
struct ReportController {
    let revenue: [RevenueEntry]
    let expenses: [ExpenseEntry]

    private var cal: Calendar { Calendar(identifier: .iso8601) }

    // MARK: Intervals

    func weekInterval(offset: Int) -> DateInterval {
        let thisWeek = cal.dateInterval(of: .weekOfYear, for: Date())!
        let start = cal.date(byAdding: .weekOfYear, value: offset, to: thisWeek.start)!
        let end = cal.date(byAdding: .day, value: 7, to: start)!
        return DateInterval(start: start, end: end)
    }

    func monthInterval(offset: Int) -> DateInterval {
        let base = cal.date(byAdding: .month, value: offset, to: Date())!
        return cal.dateInterval(of: .month, for: base)!
    }

    var earliestDate: Date {
        let all = revenue.map { $0.date } + expenses.map { $0.date }
        return all.min() ?? Date()
    }

    func canGoBackWeek(offset: Int) -> Bool { weekInterval(offset: offset).start > earliestDate }
    func canGoBackMonth(offset: Int) -> Bool { monthInterval(offset: offset).start > earliestDate }

    // MARK: Totals

    private func inside(_ date: Date, _ interval: DateInterval) -> Bool {
        date >= interval.start && date < interval.end
    }

    func revenueTotal(_ interval: DateInterval) -> Double {
        revenue.filter { inside($0.date, interval) }.reduce(0) { $0 + $1.amount }
    }

    func expenseTotal(_ interval: DateInterval) -> Double {
        expenses.filter { inside($0.date, interval) }.reduce(0) { $0 + $1.amount }
    }

    func total(_ interval: DateInterval) -> PeriodSummary {
        PeriodSummary(revenue: revenueTotal(interval), expense: expenseTotal(interval))
    }

    // Last n days ending today (used by Home chart)
    func lastDays(_ n: Int) -> [DayTotal] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return (0..<n).reversed().map { back in
            let day = cal.date(byAdding: .day, value: -back, to: Date())!
            let rev = revenue.filter { cal.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            let exp = expenses.filter { cal.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            return DayTotal(day: formatter.string(from: day), revenue: rev, expense: exp)
        }
    }

    // MARK: Weekly report

    func weekReport(offset: Int) -> WeekReport {
        let interval = weekInterval(offset: offset)
        let previous = weekInterval(offset: offset - 1)
        let summary = total(interval)
        let prevNet = total(previous).net

        var delta: Double? = nil
        if prevNet != 0 { delta = (summary.net - prevNet) / abs(prevNet) * 100 }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let lastDay = cal.date(byAdding: .day, value: -1, to: interval.end)!
        let label = "\(formatter.string(from: interval.start)) – \(formatter.string(from: lastDay))"

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        let days: [DayTotal] = (0..<7).map { i in
            let day = cal.date(byAdding: .day, value: i, to: interval.start)!
            let rev = revenue.filter { cal.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            let exp = expenses.filter { cal.isDate($0.date, inSameDayAs: day) }.reduce(0) { $0 + $1.amount }
            return DayTotal(day: dayFormatter.string(from: day), revenue: rev, expense: exp)
        }

        let weekRevenue = revenue.filter { inside($0.date, interval) }
        let clientTotals = Dictionary(grouping: weekRevenue, by: { $0.client }).map { name, items in
            RankedItem(name: name, amount: items.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }

        let weekExpenses = expenses.filter { inside($0.date, interval) }
        let categoryTotals = Dictionary(grouping: weekExpenses, by: { $0.category }).map { cat, items in
            CategoryTotal(category: cat, amount: items.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }

        return WeekReport(label: label, summary: summary, deltaPercent: delta, days: days,
                          topClients: Array(clientTotals.prefix(3)), topCategories: Array(categoryTotals.prefix(3)))
    }

    // MARK: Monthly report

    func monthReport(offset: Int) -> MonthReport {
        let month = monthInterval(offset: offset)

        let before = DateInterval(start: .distantPast, end: month.start)
        let opening = revenueTotal(before) - expenseTotal(before)
        let monthSummary = total(month)
        let closing = opening + monthSummary.net

        // 4 weeks: days 1-7, 8-14, 15-21, 22-end
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "MMM d"

        var rows: [WeekRow] = []
        var points: [CumulativePoint] = []
        var running = 0.0
        var worstIndex = 0
        var worstNet = Double.greatestFiniteMagnitude
        var worstInterval = month

        for i in 0..<4 {
            let start = cal.date(byAdding: .day, value: i * 7, to: month.start)!
            let end = i == 3 ? month.end : cal.date(byAdding: .day, value: 7, to: start)!
            let part = DateInterval(start: start, end: end)
            let s = total(part)
            rows.append(WeekRow(title: "Week \(i + 1)", revenue: s.revenue, expense: s.expense, net: s.net))
            running += s.net
            points.append(CumulativePoint(label: shortFormatter.string(from: start), net: running))
            if s.net < worstNet { worstNet = s.net; worstIndex = i; worstInterval = part }
        }

        let positive = rows.filter { $0.net >= 0 }.count
        var insight = "\(positive) of 4 weeks closed positive."
        if positive < 4 {
            let worstExpenses = expenses.filter { inside($0.date, worstInterval) }
            let top = Dictionary(grouping: worstExpenses, by: { $0.category })
                .map { ($0.key, $0.value.reduce(0) { $0 + $1.amount }) }
                .max { $0.1 < $1.1 }
            if let top = top {
                insight += " Week \(worstIndex + 1) dipped on \(top.0.rawValue.lowercased()) costs."
            } else {
                insight += " Week \(worstIndex + 1) had the lowest net."
            }
        } else {
            insight += " Great month. Keep it up!"
        }

        let labelFormatter = DateFormatter()
        labelFormatter.dateFormat = "MMMM yyyy"
        return MonthReport(label: labelFormatter.string(from: month.start), opening: opening, closing: closing,
                           cumulative: points, weeks: rows, insight: insight)
    }

    // MARK: Charts

    // Revenue and expense for each of the last `count` months (oldest first)
    func monthlyTrend(count: Int = 6) -> [MonthTotal] {
        let short = DateFormatter(); short.dateFormat = "MMM"
        let full = DateFormatter(); full.dateFormat = "MMMM"
        return (0..<count).reversed().map { back in
            let interval = monthInterval(offset: -back)
            let s = total(interval)
            return MonthTotal(label: short.string(from: interval.start), fullName: full.string(from: interval.start),
                              revenue: s.revenue, expense: s.expense)
        }
    }

    // Expense share per category over the last 6 months
    func categoryShares(months: Int = 6) -> [CategoryShare] {
        let start = monthInterval(offset: -(months - 1)).start
        let interval = DateInterval(start: start, end: Date().addingTimeInterval(86400))
        let items = expenses.filter { inside($0.date, interval) }
        let grand = items.reduce(0) { $0 + $1.amount }
        guard grand > 0 else { return [] }
        return Dictionary(grouping: items, by: { $0.category }).map { cat, list in
            let amount = list.reduce(0) { $0 + $1.amount }
            return CategoryShare(category: cat, amount: amount, percent: amount / grand * 100)
        }.sorted { $0.amount > $1.amount }
    }
}
