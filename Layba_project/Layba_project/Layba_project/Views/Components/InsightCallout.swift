import SwiftUI

// Blue info box with a short sentence (Monthly report)
struct InsightCallout: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle").foregroundColor(.ffSteelBlue)
            Text(text).font(.ffBody(13)).foregroundColor(.ffSteelBlue)
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color(hex: "E3EAF0"))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ffSteelBlue.opacity(0.25), lineWidth: 1))
    }
}
