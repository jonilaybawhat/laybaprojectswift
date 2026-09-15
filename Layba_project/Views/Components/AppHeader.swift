import SwiftUI

struct AppHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Circle().fill(Color.ffYellow).frame(width: 8, height: 8)
                Text("FREIGHTFOLIO")
                    .font(.ffLabel(11))
                    .foregroundColor(.ffOnDarkSecondary)
                    .tracking(1.2)
            }
            Text(title).font(.ffHero(26)).foregroundColor(.ffOnDark)
            if let subtitle {
                Text(subtitle).font(.ffLabel()).foregroundColor(.ffOnDarkSecondary)
            }
        }
    }
}
