import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SubScreenHeader(title: "Notifications")

                SettingGroup {
                    SettingToggleRow(label: "New revenue entry",
                                     detail: "Show an alert when you save revenue",
                                     isOn: $settings.notifyNewRevenue)
                    SettingToggleRow(label: "New expense entry",
                                     detail: "Show an alert when you save an expense",
                                     isOn: $settings.notifyNewExpense)
                    SettingToggleRow(label: "Weekly summary",
                                     detail: "Reminder every Monday, 8:00 AM",
                                     isOn: $settings.weeklySummary,
                                     showsLine: false)
                }
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}
