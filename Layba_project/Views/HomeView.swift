import SwiftUI
import Charts

struct HomeView: View {
    @EnvironmentObject var appData: AppData

    struct ActivityItem: Identifiable {
        let id = UUID()
        let title: String
        let tripID: String
        let subtitle: String
        let meta: String
        let amount: Double
        let isRevenue: Bool
        let date: Date
    }

    var recentActivity: [ActivityItem] {
        let revItems = appData.revenueEntries.map {
            ActivityItem(title: "Haul — \($0.client)", tripID: $0.tripID, subtitle: "\($0.origin) → \($0.destination)", meta: $0.payMethod.rawValue, amount: $0.amount, isRevenue: true, date: $0.date)
        }
        let expItems = appData.expenseEntries.map {
            ActivityItem(title: $0.category.rawValue, tripID: $0.tripID, subtitle: $0.vendor.isEmpty ? $0.category.rawValue : $0.vendor, meta: $0.payMethod.rawValue, amount: $0.amount, isRevenue: false, date: $0.date)
        }
        return Array((revItems + expItems).sorted { $0.date > $1.date }.prefix(6))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AppHeader(title: "Good morning", subtitle: "Joman Company · \(Date().formatted(date: .abbreviated, time: .omitted))")
                    LaneMarker()

                    HeroCard(label: "Net cash flow · this month", amount: appData.netCashFlow)

                    HStack(spacing: 10) {
                        StatChip(label: "Revenue", value: appData.totalRevenue, isRevenue: true)
                        StatChip(label: "Expenses", value: appData.totalExpenses, isRevenue: false)
                    }

                    Card {
                        SectionTitle("This week")
                        Chart(appData.weekData) { day in
                            BarMark(x: .value("Day", day.day), y: .value("Amount", day.revenue))
                                .foregroundStyle(Color.ffGreen)
                                .position(by: .value("Type", "Revenue"))
                            BarMark(x: .value("Day", day.day), y: .value("Amount", day.expense))
                                .foregroundStyle(Color.ffRed)
                                .position(by: .value("Type", "Expense"))
                        }
                        .frame(height: 120)
                    }

                    Card {
                        SectionTitle("Recent activity")
                        ForEach(recentActivity) { item in
                            if item.tripID.isEmpty {
                                ActivityDetailRow(title: item.title, tripID: item.tripID, subtitle: item.subtitle, meta: item.meta, date: item.date, amount: item.amount, isRevenue: item.isRevenue)
                            } else {
                                NavigationLink(destination: TripDetailView(tripID: item.tripID)) {
                                    ActivityDetailRow(title: item.title, tripID: item.tripID, subtitle: item.subtitle, meta: item.meta, date: item.date, amount: item.amount, isRevenue: item.isRevenue)
                                }
                                .buttonStyle(.plain)
                            }
                            Divider()
                        }
                    }
                }
                .padding(16)
            }
            .background(Color.ffBlack.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}
