import SwiftUI

struct RevenueView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var toast: ToastController

    @State private var tripID = ""
    @State private var client = ""
    @State private var origin = ""
    @State private var destination = ""
    @State private var payMethod: PaymentMethod = .cash
    @State private var amountText = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var saved = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AppHeader(title: "Log revenue")
                    LaneMarker()

                    Card {
                        Text("Trip ID").font(.ffLabel(11)).foregroundColor(.ffSteel)
                        TextField("Leave blank for \(appData.nextTripID())", text: $tripID).textFieldStyle(.roundedBorder)
                        TripSuggestionChips(tripIDs: appData.allTripIDs, selection: $tripID)

                        TextField("Client name", text: $client).textFieldStyle(.roundedBorder)
                        HStack {
                            TextField("Origin", text: $origin).textFieldStyle(.roundedBorder)
                            TextField("Destination", text: $destination).textFieldStyle(.roundedBorder)
                        }
                        SegmentedControl(selection: $payMethod)
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                        TextField("Notes (optional)", text: $notes).textFieldStyle(.roundedBorder)
                    }

                    PrimaryButton(label: saved ? "Saved ✓" : "Save revenue entry", action: save)

                    ForEach(appData.revenueByMonth) { month in
                        Card {
                            MonthHeader(label: month.label, total: month.total, isRevenue: true)
                            ForEach(Array(month.entries.enumerated()), id: \.element.id) { index, entry in
                                if index > 0 { RowLine() }
                                NavigationLink(destination: TripDetailView(tripID: entry.tripID)) {
                                    RevenueDetailRow(entry: entry)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
            }
            .screenBackground()
            .navigationBarHidden(true)
            .onAppear { payMethod = settings.defaultPayment }
        }
    }

    func save() {
        guard let amount = Double(amountText), amount > 0, !client.isEmpty else { return }
        let finalTripID = tripID.isEmpty ? appData.nextTripID() : tripID
        let entry = RevenueEntry(tripID: finalTripID, client: client, origin: origin, destination: destination,
                                 payMethod: payMethod, amount: amount, notes: notes, plate: "NGP 2049", date: date)
        appData.addRevenue(entry)
        if settings.notifyNewRevenue {
            toast.show("New revenue · \(finalTripID) · \(Money.string(amount))")
        }
        tripID = ""; client = ""; origin = ""; destination = ""; amountText = ""; notes = ""; date = Date()
        payMethod = settings.defaultPayment
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { saved = false }
    }
}
