import SwiftUI

struct HeroCard: View {
    let label: String
    let amount: Double
    var delta: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            LaneMarker().frame(width: 60)
            Text(label).font(.ffLabel()).foregroundColor(.ffSteel)
            Text(amount, format: .currency(code: "PHP")).font(.ffHero()).foregroundColor(.ffInk)
            if let delta { Text(delta).font(.ffLabel(12)).foregroundColor(.ffGreen) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.ffPanel)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ffBorder, lineWidth: 1))
    }
}
