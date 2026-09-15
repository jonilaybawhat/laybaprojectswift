import SwiftUI

// Full-detail row used on Home's mixed activity feed
struct ActivityDetailRow: View {
    let title: String
    let tripID: String
    let subtitle: String
    let meta: String
    let date: Date
    let amount: Double
    let isRevenue: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(isRevenue ? Color.ffGreen : Color.ffRed).frame(width: 8, height: 8)
                    Text(title).font(.ffBody(14)).foregroundColor(.ffInk)
                }
                Spacer()
                Text((isRevenue ? "+" : "−") + amount.formatted(.currency(code: "PHP").precision(.fractionLength(0))))
                    .font(.ffMono(13))
                    .foregroundColor(isRevenue ? .ffGreen : .ffRed)
            }
            Text(subtitle).font(.ffLabel(11)).foregroundColor(.ffSteel)
            HStack {
                Text(tripID.isEmpty ? "No trip" : tripID).font(.ffLabel(10)).foregroundColor(.ffSteelBlue)
                Text("· \(meta)").font(.ffLabel(10)).foregroundColor(.ffSteel)
                Spacer()
                Text(date.formatted(date: .abbreviated, time: .omitted)).font(.ffLabel(10)).foregroundColor(.ffSteel)
            }
        }
        .padding(.vertical, 8)
    }
}

// Full-detail row for the Revenue list
struct RevenueDetailRow: View {
    let entry: RevenueEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.tripID).font(.ffLabel(11)).foregroundColor(.ffSteelBlue)
                Spacer()
                Text(entry.date.formatted(date: .abbreviated, time: .omitted)).font(.ffLabel(11)).foregroundColor(.ffSteel)
            }
            Text(entry.client).font(.ffBody(15)).foregroundColor(.ffInk)
            Text("\(entry.origin) → \(entry.destination)").font(.ffLabel(12)).foregroundColor(.ffSteel)
            HStack {
                Text(entry.payMethod.rawValue).font(.ffLabel(11)).foregroundColor(.ffSteel)
                Text("· \(entry.plate)").font(.ffLabel(11)).foregroundColor(.ffSteel)
                Spacer()
                Text(entry.amount, format: .currency(code: "PHP")).font(.ffMono(14)).foregroundColor(.ffGreen)
            }
            if !entry.notes.isEmpty { Text(entry.notes).font(.ffBody(12)).foregroundColor(.ffSteel) }
        }
        .padding(.vertical, 8)
        Divider()
    }
}

// Full-detail row for the Expenses list
struct ExpenseDetailRow: View {
    let entry: ExpenseEntry
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.tripID.isEmpty ? "No trip" : entry.tripID).font(.ffLabel(11)).foregroundColor(.ffSteelBlue)
                Spacer()
                Text(entry.date.formatted(date: .abbreviated, time: .omitted)).font(.ffLabel(11)).foregroundColor(.ffSteel)
            }
            Text(entry.category.rawValue).font(.ffBody(15)).foregroundColor(.ffInk)
            if !entry.vendor.isEmpty { Text(entry.vendor).font(.ffLabel(12)).foregroundColor(.ffSteel) }
            HStack {
                Text(entry.payMethod.rawValue).font(.ffLabel(11)).foregroundColor(.ffSteel)
                Text("· \(entry.plate)").font(.ffLabel(11)).foregroundColor(.ffSteel)
                Spacer()
                Text(entry.amount, format: .currency(code: "PHP")).font(.ffMono(14)).foregroundColor(.ffRed)
            }
            if !entry.notes.isEmpty { Text(entry.notes).font(.ffBody(12)).foregroundColor(.ffSteel) }
        }
        .padding(.vertical, 8)
        Divider()
    }
}
