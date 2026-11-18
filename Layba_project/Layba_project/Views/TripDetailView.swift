import SwiftUI

struct TripDetailView: View {
    let tripID: String
    @EnvironmentObject var appData: AppData

    var revenueForTrip: [RevenueEntry] { appData.revenueEntries.filter { $0.tripID == tripID } }
    var expensesForTrip: [ExpenseEntry] { appData.expenseEntries.filter { $0.tripID == tripID } }
    var tripRevenue: Double { revenueForTrip.reduce(0) { $0 + $1.amount } }
    var tripExpenses: Double { expensesForTrip.reduce(0) { $0 + $1.amount } }
    var tripNet: Double { tripRevenue - tripExpenses }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SubScreenHeader(title: tripID)

                HeroCard(label: "Net for this trip", amount: tripNet)

                HStack(spacing: 10) {
                    StatChip(label: "Revenue", value: tripRevenue, isRevenue: true)
                    StatChip(label: "Expenses", value: tripExpenses, isRevenue: false)
                }

                if !revenueForTrip.isEmpty {
                    Card {
                        SectionTitle("Revenue")
                        ForEach(Array(revenueForTrip.enumerated()), id: \.element.id) { index, entry in
                            if index > 0 { RowLine() }
                            RevenueDetailRow(entry: entry)
                        }
                    }
                }

                if !expensesForTrip.isEmpty {
                    Card {
                        SectionTitle("Expenses")
                        ForEach(Array(expensesForTrip.enumerated()), id: \.element.id) { index, entry in
                            if index > 0 { RowLine() }
                            ExpenseDetailRow(entry: entry)
                        }
                    }
                }
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
    }
}
