import SwiftUI

// Month title + month total, used above grouped lists
struct MonthHeader: View {
    let label: String
    let total: Double
    let isRevenue: Bool

    var body: some View {
        HStack {
            SectionTitle(label)
            Spacer()
            Text(Money.string(total)).font(.ffMono(13)).foregroundColor(isRevenue ? .ffGreen : .ffRed)
        }
    }
}

// Thin line between list items (a plain Divider breaks inside NavigationLink labels)
struct RowLine: View {
    var body: some View {
        Rectangle().fill(Color.ffBorder).frame(height: 1)
    }
}
