import SwiftUI

// Back button + FreightFolio header for pushed screens (Trip detail, Account, Settings pages)
struct SubScreenHeader: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settings: SettingsStore
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back").font(.ffLabel(14))
                }
                .foregroundColor(settings.onScreen)
            }
            AppHeader(title: title, subtitle: subtitle)
            LaneMarker()
        }
    }
}
