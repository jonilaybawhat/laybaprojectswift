import SwiftUI
import Charts

struct ReportsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var settings: SettingsStore

    @State private var period: ReportPeriod = .weekly
    @State private var weekOffset = 0     // 0 = this week, -1 = last week ...
    @State private var monthOffset = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AppHeader(title: "Reports")
                    SegmentedControl(selection: $period)
                    LaneMarker()

                    if period == .weekly { weekly } else { monthly }
                }
                .padding(16)
            }
            .screenBackground()
            .navigationBarHidden(true)
        }
    }

    // MARK: Weekly

    var weekly: some View {
        let reports = appData.reports
        let report = reports.weekReport(offset: weekOffset)
        return VStack(alignment: .leading, spacing: 12) {
            PeriodSwitcher(label: report.label,
                           canGoBack: reports.canGoBackWeek(offset: weekOffset),
                           canGoForward: weekOffset < 0,
                           onBack: { weekOffset -= 1 },
                           onForward: { weekOffset += 1 })

            HeroCard(label: weekOffset == 0 ? "Net profit this week" : "Net profit this period",
                     amount: report.summary.net,
                     delta: deltaText(report.deltaPercent, name: "last week"),
                     deltaPositive: (report.deltaPercent ?? 0) >= 0,
                     revenue: report.summary.revenue,
                     expenses: report.summary.expense)

            Card {
                SectionTitle("Revenue vs expense, by day")
                RevenueExpenseBarChart(days: report.days, height: 110)
            }

            Card {
                SectionTitle("Top revenue sources")
                if report.topClients.isEmpty {
                    Text("No revenue this week.").font(.ffBody(13)).foregroundColor(.ffSteel)
                }
                ForEach(Array(report.topClients.enumerated()), id: \.element.id) { index, item in
                    if index > 0 { RowLine() }
                    HStack {
                        Text("0\(index + 1)").font(.ffTitle(16)).foregroundColor(.ffSteel)
                        Text(item.name).font(.ffBody(13)).foregroundColor(.ffInk)
                        Spacer()
                        Text(Money.string(item.amount)).font(.ffMono(13)).foregroundColor(.ffGreen)
                    }
                    .padding(.vertical, 4)
                }
            }

            Card {
                SectionTitle("Top expense categories")
                if report.topCategories.isEmpty {
                    Text("No expenses this week.").font(.ffBody(13)).foregroundColor(.ffSteel)
                }
                ForEach(Array(report.topCategories.enumerated()), id: \.element.id) { index, item in
                    if index > 0 { RowLine() }
                    HStack(spacing: 10) {
                        Circle().fill(item.category.color).frame(width: 10, height: 10)
                        Text(item.category.rawValue).font(.ffBody(13)).foregroundColor(.ffInk)
                        Spacer()
                        Text(Money.string(item.amount)).font(.ffMono(13)).foregroundColor(.ffRed)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    // MARK: Monthly

    var monthly: some View {
        let reports = appData.reports
        let report = reports.monthReport(offset: monthOffset)
        return VStack(alignment: .leading, spacing: 12) {
            PeriodSwitcher(label: report.label,
                           canGoBack: reports.canGoBackMonth(offset: monthOffset),
                           canGoForward: monthOffset < 0,
                           onBack: { monthOffset -= 1 },
                           onForward: { monthOffset += 1 })

            HStack(spacing: 10) {
                balanceBox("Opening balance", report.opening, .ffInk)
                balanceBox("Closing balance", report.closing, report.closing >= 0 ? .ffGreen : .ffRed)
            }

            Card {
                SectionTitle("Cumulative cash flow")
                Chart(report.cumulative) { point in
                    AreaMark(x: .value("Week", point.label), y: .value("Net", point.net))
                        .foregroundStyle(LinearGradient(colors: [Color.ffGreen.opacity(0.25), Color.ffGreen.opacity(0)],
                                                        startPoint: .top, endPoint: .bottom))
                        .interpolationMethod(.monotone)
                    LineMark(x: .value("Week", point.label), y: .value("Net", point.net))
                        .foregroundStyle(Color.ffGreen)
                        .lineStyle(StrokeStyle(lineWidth: 2.5))
                        .interpolationMethod(.monotone)
                    PointMark(x: .value("Week", point.label), y: .value("Net", point.net))
                        .foregroundStyle(Color.ffGreen)
                }
                .chartYAxis(.hidden)
                .frame(height: 120)
            }

            Card {
                SectionTitle("Weekly subtotals")
                HStack {
                    header("Week", .leading); header("Revenue", .trailing)
                    header("Expense", .trailing); header("Net", .trailing)
                }
                ForEach(report.weeks) { row in
                    RowLine()
                    HStack {
                        Text(row.title).font(.ffBody(12)).foregroundColor(.ffInk)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(Money.string(row.revenue)).font(.ffMono(11)).foregroundColor(.ffGreen)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(Money.string(row.expense)).font(.ffMono(11)).foregroundColor(.ffRed)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        Text(Money.string(row.net)).font(.ffMono(11).weight(.bold))
                            .foregroundColor(row.net < 0 ? .ffRed : .ffGreen)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                    .background(row.net < 0 ? Color.ffRedBg : Color.clear)
                }
            }

            InsightCallout(text: report.insight)
        }
    }

    // MARK: Helpers

    func header(_ text: String, _ alignment: Alignment) -> some View {
        Text(text).font(.ffLabel(11)).foregroundColor(.ffSteel).frame(maxWidth: .infinity, alignment: alignment)
    }

    func balanceBox(_ label: String, _ value: Double, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.ffLabel(11)).foregroundColor(.ffSteel)
            Text(Money.string(value)).font(.ffMono(15).weight(.bold)).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.ffPanel)
        .cornerRadius(14)
        .environment(\.colorScheme, .light)
    }

    func deltaText(_ percent: Double?, name: String) -> String? {
        guard let percent = percent else { return nil }
        let arrow = percent >= 0 ? "▲" : "▼"
        return "\(arrow)\(Int(abs(percent).rounded()))% vs \(name)"
    }
}
