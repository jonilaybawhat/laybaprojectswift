import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var settings: SettingsStore

    struct ActivityItem: Identifiable {
        let id: String
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
            ActivityItem(id: $0.id.uuidString, title: "Haul — \($0.client)", tripID: $0.tripID,
                         subtitle: "\($0.origin) → \($0.destination)", meta: $0.payMethod.rawValue,
                         amount: $0.amount, isRevenue: true, date: $0.date)
        }
        let expItems = appData.expenseEntries.map {
            ActivityItem(id: $0.id.uuidString, title: $0.category.rawValue, tripID: $0.tripID,
                         subtitle: $0.vendor.isEmpty ? $0.category.rawValue : $0.vendor, meta: $0.payMethod.rawValue,
                         amount: $0.amount, isRevenue: false, date: $0.date)
        }
        return Array((revItems + expItems).sorted { $0.date > $1.date }.prefix(6))
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        if hour < 18 { return "Good afternoon" }
        return "Good evening"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 8) {
                        AppHeader(title: greeting, subtitle: "\(auth.company) · \(settings.formatDate(Date()))")

                        // Bell with unread badge
                        NavigationLink(destination: NotificationListView()) {
                            headerIcon("bell.fill")
                                .overlay(alignment: .topTrailing) {
                                    if appData.unreadCount > 0 {
                                        Text(appData.unreadCount > 9 ? "9+" : "\(appData.unreadCount)")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 5)
                                            .frame(minWidth: 18, minHeight: 18)
                                            .background(Color.ffRed)
                                            .clipShape(Capsule())
                                            .offset(x: 6, y: -6)
                                    }
                                }
                        }

                        // Settings
                        NavigationLink(destination: AccountView()) {
                            headerIcon("gearshape.fill")
                        }
                    }
                    LaneMarker()

                    HeroCard(label: "Net cash flow · this month",
                             amount: appData.monthSummary.net,
                             delta: appData.monthDelta?.text,
                             deltaPositive: appData.monthDelta?.isPositive ?? true)

                    HStack(spacing: 10) {
                        StatChip(label: "Revenue", value: appData.monthSummary.revenue, isRevenue: true)
                        StatChip(label: "Expenses", value: appData.monthSummary.expense, isRevenue: false)
                    }

                    Card {
                        SectionTitle("This week")
                        RevenueExpenseBarChart(days: appData.weekData)
                    }

                    Card {
                        SectionTitle("Recent activity")
                        if recentActivity.isEmpty {
                            Text("No activity yet.").font(.ffBody(13)).foregroundColor(.ffSteel)
                        }
                        ForEach(Array(recentActivity.enumerated()), id: \.element.id) { index, item in
                            if index > 0 { RowLine() }
                            if item.tripID.isEmpty {
                                row(item)
                            } else {
                                NavigationLink(destination: TripDetailView(tripID: item.tripID)) { row(item) }
                                    .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .screenBackground()
            .navigationBarHidden(true)
            .onAppear {
                if settings.weeklySummary { appData.addWeeklySummaryIfNeeded() }
            }
        }
    }

    func headerIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 16))
            .foregroundColor(settings.onScreen)
            .frame(width: 38, height: 38)
            .background(Color.ffPanel)
            .cornerRadius(12)
    }

    func row(_ item: ActivityItem) -> some View {
        ActivityDetailRow(title: item.title, tripID: item.tripID, subtitle: item.subtitle, meta: item.meta,
                          date: item.date, amount: item.amount, isRevenue: item.isRevenue)
    }
}
