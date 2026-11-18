import SwiftUI

// "< Sep 1 – Sep 7 >" switcher for Reports
struct PeriodSwitcher: View {
    @EnvironmentObject var settings: SettingsStore
    let label: String
    let canGoBack: Bool
    let canGoForward: Bool
    let onBack: () -> Void
    let onForward: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left").frame(width: 36, height: 36)
            }
            .disabled(!canGoBack)
            .opacity(canGoBack ? 1 : 0.3)

            Spacer()
            Text(label).font(.ffLabel(14)).foregroundColor(settings.onScreen)
            Spacer()

            Button(action: onForward) {
                Image(systemName: "chevron.right").frame(width: 36, height: 36)
            }
            .disabled(!canGoForward)
            .opacity(canGoForward ? 1 : 0.3)
        }
        .foregroundColor(settings.onScreen)
    }
}
