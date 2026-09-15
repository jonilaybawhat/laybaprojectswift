import SwiftUI

struct StatChip: View {
    let label: String
    let value: Double
    let isRevenue: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.ffLabel(11)).foregroundColor(.ffSteel)
            Text(value, format: .currency(code: "PHP")).font(.ffMono(14)).foregroundColor(isRevenue ? .ffGreen : .ffRed)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(isRevenue ? Color.ffGreenBg : Color.ffRedBg)
        .cornerRadius(12)
    }
}
