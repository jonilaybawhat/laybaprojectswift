import SwiftUI

struct HeroCard: View {
    let label: String
    let amount: Double
    var delta: String? = nil
    var deltaPositive: Bool = true
    var revenue: Double? = nil
    var expenses: Double? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            LaneMarker().frame(width: 60)
            Text(label).font(.ffLabel()).foregroundColor(.ffSteel)
            Text(Money.string(amount, decimals: 2))
                .font(.ffHero())
                .foregroundColor(amount < 0 ? .ffRed : .ffInk)
            if let delta {
                Text(delta).font(.ffLabel(12)).foregroundColor(deltaPositive ? .ffGreen : .ffRed)
            }
            if let revenue, let expenses {
                HStack(spacing: 16) {
                    Text("Revenue \(Money.string(revenue))").font(.ffMono(11)).foregroundColor(.ffGreen)
                    Text("Expenses \(Money.string(expenses))").font(.ffMono(11)).foregroundColor(.ffRed)
                }
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.ffPanel)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.ffBorder, lineWidth: 1))
        .environment(\.colorScheme, .light)
    }
}
