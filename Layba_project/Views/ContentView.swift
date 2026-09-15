import SwiftUI

struct ContentView: View {
    @StateObject private var appData = AppData()

    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            RevenueView().tabItem { Label("Revenue", systemImage: "chart.line.uptrend.xyaxis") }
            ExpenseView().tabItem { Label("Expenses", systemImage: "creditcard.fill") }
        }
        .tint(.ffInk)
        .environmentObject(appData)
    }
}
