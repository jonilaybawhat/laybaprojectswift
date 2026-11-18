import SwiftUI

// The 5 tabs from the Figma bottom bar
struct MainTabView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            RevenueView().tabItem { Label("Revenue", systemImage: "chart.line.uptrend.xyaxis") }
            ExpenseView().tabItem { Label("Expenses", systemImage: "creditcard.fill") }
            ReportsView().tabItem { Label("Reports", systemImage: "doc.text.fill") }
            ChartsView().tabItem { Label("Charts", systemImage: "chart.pie.fill") }
        }
        .tint(settings.darkTheme ? .ffYellow : .ffInk)
        .overlay(ToastBanner())
    }
}
