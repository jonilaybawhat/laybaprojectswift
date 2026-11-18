import SwiftUI
import Combine

// App settings. Every change is saved right away in UserDefaults.
final class SettingsStore: ObservableObject {

    @Published var notifyNewRevenue: Bool { didSet { UserDefaults.standard.set(notifyNewRevenue, forKey: "ff.notifyRevenue") } }
    @Published var notifyNewExpense: Bool { didSet { UserDefaults.standard.set(notifyNewExpense, forKey: "ff.notifyExpense") } }
    @Published var weeklySummary: Bool {
        didSet {
            UserDefaults.standard.set(weeklySummary, forKey: "ff.weeklySummary")
            NotificationManager.setWeeklyReminder(weeklySummary)
        }
    }
    @Published var darkTheme: Bool { didSet { UserDefaults.standard.set(darkTheme, forKey: "ff.darkTheme") } }
    @Published var defaultPayment: PaymentMethod { didSet { UserDefaults.standard.set(defaultPayment.rawValue, forKey: "ff.defaultPayment") } }
    @Published var dateFormat: DateFormatOption { didSet { UserDefaults.standard.set(dateFormat.rawValue, forKey: "ff.dateFormat") } }

    init() {
        let defaults = UserDefaults.standard
        notifyNewRevenue = defaults.object(forKey: "ff.notifyRevenue") as? Bool ?? true
        notifyNewExpense = defaults.object(forKey: "ff.notifyExpense") as? Bool ?? true
        weeklySummary = defaults.object(forKey: "ff.weeklySummary") as? Bool ?? false
        darkTheme = defaults.object(forKey: "ff.darkTheme") as? Bool ?? true
        defaultPayment = PaymentMethod(rawValue: defaults.string(forKey: "ff.defaultPayment") ?? "") ?? .cash
        dateFormat = DateFormatOption(rawValue: defaults.string(forKey: "ff.dateFormat") ?? "") ?? .monthFirst
    }

    // Colors that change with the theme (used for things placed directly on the screen background)
    var background: Color { darkTheme ? .ffBlack : .ffPaper }
    var onScreen: Color { darkTheme ? .ffOnDark : .ffInk }
    var onScreenSecondary: Color { darkTheme ? .ffOnDarkSecondary : .ffSteel }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat.pattern
        return formatter.string(from: date)
    }
}
