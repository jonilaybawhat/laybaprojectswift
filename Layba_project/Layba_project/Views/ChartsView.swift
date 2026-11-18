import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var settings: SettingsStore

    @State private var mode: ChartMode = .trend

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AppHeader(title: "Financial charts")
                    SegmentedControl(selection: $mode)
                    LaneMarker()

                    if mode == .trend { trend } else { categories }
                }
                .padding(16)
            }
            .screenBackground()
            .navigationBarHidden(true)
        }
    }

    // MARK: Trend

    var trend: some View {
        let months = appData.reports.monthlyTrend(count: 6)
        let avgProfit = months.isEmpty ? 0 : months.reduce(0) { $0 + $1.net } / Double(months.count)
        let best = months.max { $0.net < $1.net }

        return VStack(alignment: .leading, spacing: 12) {
            Card {
                SectionTitle("Revenue vs expense — last 6 months")
                HStack(spacing: 16) {
                    legend(.ffGreen, "Revenue")
                    legend(.ffRed, "Expenses")
                }
                Chart {
                    ForEach(months) { m in
                        LineMark(x: .value("Month", m.label), y: .value("Amount", m.revenue), series: .value("Type", "Revenue"))
                            .foregroundStyle(Color.ffGreen)
                            .lineStyle(StrokeStyle(lineWidth: 2.5))
                            .interpolationMethod(.monotone)
                        PointMark(x: .value("Month", m.label), y: .value("Amount", m.revenue))
                            .foregroundStyle(Color.ffGreen)
                        LineMark(x: .value("Month", m.label), y: .value("Amount", m.expense), series: .value("Type", "Expenses"))
                            .foregroundStyle(Color.ffRed)
                            .lineStyle(StrokeStyle(lineWidth: 2.5))
                            .interpolationMethod(.monotone)
                        PointMark(x: .value("Month", m.label), y: .value("Amount", m.expense))
                            .foregroundStyle(Color.ffRed)
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic(desiredCount: 4)) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let amount = value.as(Double.self) { Text(Money.compact(amount)).font(.ffLabel(9)) }
                        }
                    }
                }
                .frame(height: 170)
            }

            HStack(spacing: 10) {
                StatChip(label: "Avg monthly profit", value: avgProfit, isRevenue: true)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Best month").font(.ffLabel(11)).foregroundColor(.ffSteel)
                    Text(best?.fullName ?? "-").font(.ffTitle(18)).foregroundColor(.ffInk)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color.ffPanel)
                .cornerRadius(12)
            }
        }
    }

    // MARK: Categories

    var categories: some View {
        let shares = appData.reports.categoryShares()
        return Card {
            SectionTitle("Expense breakdown")
            Text("Last 6 months").font(.ffLabel(11)).foregroundColor(.ffSteel)
            if shares.isEmpty {
                Text("No expenses yet.").font(.ffBody(13)).foregroundColor(.ffSteel)
            } else {
                HStack(alignment: .center, spacing: 14) {
                    DonutChart(shares: shares)
                    VStack(spacing: 10) {
                        ForEach(shares) { item in
                            HStack(spacing: 8) {
                                Circle().fill(item.category.color).frame(width: 9, height: 9)
                                Text(item.category.rawValue).font(.ffBody(13)).foregroundColor(.ffInk)
                                Spacer()
                                Text("\(Int(item.percent.rounded()))%").font(.ffMono(13).weight(.bold)).foregroundColor(.ffSteel)
                            }
                        }
                    }
                }
            }
        }
    }

    func legend(_ color: Color, _ text: String) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 2).fill(color).frame(width: 18, height: 3)
            Text(text).font(.ffLabel(11)).foregroundColor(.ffSteel)
        }
    }
}
