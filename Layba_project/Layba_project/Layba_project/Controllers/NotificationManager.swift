import Foundation
import UserNotifications

// Schedules the weekly summary reminder (every Monday, 8:00 AM).
enum NotificationManager {
    private static let weeklyID = "ff.weekly.summary"

    static func setWeeklyReminder(_ enabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [weeklyID])
        guard enabled else { return }

        Task {
            // Ask permission first
            let granted = (try? await center.requestAuthorization(options: [.alert, .sound])) ?? false
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "FreightFolio"
            content.body = "Your weekly summary is ready. Check last week's revenue and expenses."

            var when = DateComponents()
            when.weekday = 2   // Monday
            when.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: when, repeats: true)
            let request = UNNotificationRequest(identifier: weeklyID, content: content, trigger: trigger)
            try? await center.add(request)
        }
    }
}
