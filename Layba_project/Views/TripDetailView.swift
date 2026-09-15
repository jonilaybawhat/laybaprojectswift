import SwiftUI

struct TripDetailView: View {
    let tripID: String
    @EnvironmentObject var appData: AppData

    var revenueForTrip: [RevenueEntry] {
        appData.revenueEntries.filter { $0.tripID == tripID }
    }
    var expensesForTrip: [ExpenseEntry] {
        appData.expenseEntries.filter { $0.tripID == tripID }
    }
    var tripRevenue: Double { revenueForTrip.reduce(0) { $0 + $1.amount } }
    var tripExpenses: Double { expensesForTrip.reduce(0) { $0 + $1.amount } }
    var tripNet: Double { tripRevenue - tripExpenses }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                AppHeader(title: tripID)
                LaneMarker()

                HeroCard(label: "Net for this trip", amount: tripNet)

                HStack(spacing: 10) {
                    StatChip(label: "Revenue", value: tripRevenue, isRevenue: true)
                    StatChip(label: "Expenses", value: tripExpenses, isRevenue: false)
                }

                if !revenueForTrip.isEmpty {
                    Card {
                        SectionTitle("Revenue")
                        ForEach(revenueForTrip) { entry in
                            RevenueDetailRow(entry: entry)
                        }
                    }
                }

                if !expensesForTrip.isEmpty {
                    Card {
                        SectionTitle("Expenses")
                        ForEach(expensesForTrip) { entry in
                            ExpenseDetailRow(entry: entry)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.ffBlack.ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
