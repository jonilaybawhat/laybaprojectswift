import SwiftUI
import Charts

// Green/red bars per day. Used on Home and in the Weekly report.
struct RevenueExpenseBarChart: View {
    let days: [DayTotal]
    var height: CGFloat = 120

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Chart(days) { day in
                BarMark(x: .value("Day", day.day), y: .value("Amount", day.revenue))
                    .foregroundStyle(Color.ffGreen)
                    .position(by: .value("Type", "Revenue"))
                BarMark(x: .value("Day", day.day), y: .value("Amount", day.expense))
                    .foregroundStyle(Color.ffRed)
                    .position(by: .value("Type", "Expense"))
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 3)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let amount = value.as(Double.self) { Text(Money.compact(amount)).font(.ffLabel(9)) }
                    }
                }
            }
            .frame(height: height)

            HStack(spacing: 14) {
                legend(.ffGreen, "Revenue")
                legend(.ffRed, "Expenses")
            }
        }
    }

    private func legend(_ color: Color, _ text: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(text).font(.ffLabel(10)).foregroundColor(.ffSteel)
        }
    }
}
