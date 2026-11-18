import SwiftUI

// Full-detail row used on Home's mixed activity feed
struct ActivityDetailRow: View {
    @EnvironmentObject var settings: SettingsStore
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
                Text((isRevenue ? "+" : "−") + Money.string(amount))
                    .font(.ffMono(13))
                    .foregroundColor(isRevenue ? .ffGreen : .ffRed)
            }
            Text(subtitle).font(.ffLabel(11)).foregroundColor(.ffSteel)
            HStack {
                Text(tripID.isEmpty ? "No trip" : tripID).font(.ffLabel(10)).foregroundColor(.ffSteelBlue)
                Text("· \(meta)").font(.ffLabel(10)).foregroundColor(.ffSteel)
                Spacer()
                Text(settings.formatDate(date)).font(.ffLabel(10)).foregroundColor(.ffSteel)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

// Full-detail row for the Revenue list
struct RevenueDetailRow: View {
    @EnvironmentObject var settings: SettingsStore
    let entry: RevenueEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.tripID).font(.ffLabel(11)).foregroundColor(.ffSteelBlue)
                Spacer()
                Text(settings.formatDate(entry.date)).font(.ffLabel(11)).foregroundColor(.ffSteel)
            }
            Text(entry.client).font(.ffBody(15)).foregroundColor(.ffInk)
            Text("\(entry.origin) → \(entry.destination)").font(.ffLabel(12)).foregroundColor(.ffSteel)
            HStack {
                Text(entry.payMethod.rawValue).font(.ffLabel(11)).foregroundColor(.ffSteel)
                Text("· \(entry.plate)").font(.ffLabel(11)).foregroundColor(.ffSteel)
                Spacer()
                Text(Money.string(entry.amount)).font(.ffMono(14)).foregroundColor(.ffGreen)
            }
            if !entry.notes.isEmpty { Text(entry.notes).font(.ffBody(12)).foregroundColor(.ffSteel) }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

// Full-detail row for the Expenses list
struct ExpenseDetailRow: View {
    @EnvironmentObject var settings: SettingsStore
    let entry: ExpenseEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.tripID.isEmpty ? "No trip" : entry.tripID).font(.ffLabel(11)).foregroundColor(.ffSteelBlue)
                Spacer()
                Text(settings.formatDate(entry.date)).font(.ffLabel(11)).foregroundColor(.ffSteel)
            }
            Text(entry.category.rawValue).font(.ffBody(15)).foregroundColor(.ffInk)
            if !entry.vendor.isEmpty { Text(entry.vendor).font(.ffLabel(12)).foregroundColor(.ffSteel) }
            HStack {
                Text(entry.payMethod.rawValue).font(.ffLabel(11)).foregroundColor(.ffSteel)
                Text("· \(entry.plate)").font(.ffLabel(11)).foregroundColor(.ffSteel)
                Spacer()
                Text(Money.string(entry.amount)).font(.ffMono(14)).foregroundColor(.ffRed)
            }
            if !entry.notes.isEmpty { Text(entry.notes).font(.ffBody(12)).foregroundColor(.ffSteel) }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}
