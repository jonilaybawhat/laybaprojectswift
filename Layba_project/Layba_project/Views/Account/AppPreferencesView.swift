import SwiftUI

struct AppPreferencesView: View {
    @EnvironmentObject var settings: SettingsStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SubScreenHeader(title: "App preferences")

                SettingGroup {
                    SettingToggleRow(label: "Dark theme", detail: "Black background", isOn: $settings.darkTheme, showsLine: false)
                }

                SettingSectionHead("Default payment method")
                Card {
                    SegmentedControl(selection: $settings.defaultPayment)
                }

                SettingSectionHead("Date format")
                Card {
                    SegmentedControl(selection: $settings.dateFormat)
                    Text("Example: \(settings.formatDate(Date()))")
                        .font(.ffLabel(12))
                        .foregroundColor(.ffSteel)
                }

                SettingSectionHead("Currency")
                SettingGroup {
                    SettingNavRow(label: "Currency", value: "PHP (₱)", showsArrow: false, showsLine: false)
                }
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}
