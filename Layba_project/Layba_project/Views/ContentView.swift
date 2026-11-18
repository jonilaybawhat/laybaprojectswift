import SwiftUI
import SwiftData

// Root of the app. Creates the shared controllers and decides which flow to show:
// Get Started -> Login -> Main app.
struct ContentView: View {
    @StateObject private var appData = AppData(context: Database.container.mainContext)
    @StateObject private var auth = AuthController(context: Database.container.mainContext)
    @StateObject private var settings = SettingsStore()
    @StateObject private var toast = ToastController()

    var body: some View {
        Group {
            if auth.isLoggedIn {
                MainTabView()
            } else if auth.hasAccount && !auth.showOnboarding {
                LoginView()
            } else {
                OnboardingView()
            }
        }
        // When someone logs in or out, load only that account's data
        .onChange(of: auth.accountID) { _, newID in
            appData.load(accountID: newID)
            if settings.weeklySummary { appData.addWeeklySummaryIfNeeded() }
        }
        .environmentObject(appData)
        .environmentObject(auth)
        .environmentObject(settings)
        .environmentObject(toast)
        .preferredColorScheme(settings.darkTheme ? .dark : .light)
    }
}
