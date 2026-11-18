import SwiftUI

// Labeled text field for forms that sit on the screen background (Login, Get Started, Settings)
struct DarkField: View {
    @EnvironmentObject var settings: SettingsStore
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.ffLabel(12)).foregroundColor(settings.onScreenSecondary)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .font(.ffBody(15))
            .foregroundColor(.ffInk)
            .padding(14)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.ffBorder, lineWidth: 1))
            .environment(\.colorScheme, .light)
        }
    }
}
