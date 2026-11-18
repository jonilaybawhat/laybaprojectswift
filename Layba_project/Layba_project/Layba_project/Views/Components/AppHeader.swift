import SwiftUI

struct AppHeader: View {
    @EnvironmentObject var settings: SettingsStore
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Circle().fill(Color.ffYellow).frame(width: 8, height: 8)
                Text("FREIGHTFOLIO")
                    .font(.ffLabel(11))
                    .foregroundColor(settings.onScreenSecondary)
                    .tracking(1.2)
            }
            Text(title).font(.ffHero(26)).foregroundColor(settings.onScreen)
            if let subtitle {
                Text(subtitle).font(.ffLabel()).foregroundColor(settings.onScreenSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// Applies the theme background to a screen
struct ScreenBackground: ViewModifier {
    @EnvironmentObject var settings: SettingsStore
    func body(content: Content) -> some View {
        content.background(settings.background.ignoresSafeArea())
    }
}

extension View {
    func screenBackground() -> some View { modifier(ScreenBackground()) }
}
