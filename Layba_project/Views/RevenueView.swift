import SwiftUI

struct RevenueView: View {
    @EnvironmentObject var appData: AppData

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
                        TextField("e.g. TRIP-003", text: $tripID).textFieldStyle(.roundedBorder)
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
                            HStack {
                                SectionTitle(month.label)
                                Spacer()
                                Text(month.total, format: .currency(code: "PHP")).font(.ffMono(13)).foregroundColor(.ffGreen)
                            }
                            ForEach(month.entries) { entry in
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
            .background(Color.ffBlack.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    func save() {
        guard let amount = Double(amountText), !client.isEmpty else { return }
        let finalTripID = tripID.isEmpty ? "TRIP-\(appData.revenueEntries.count + 1)" : tripID
        let entry = RevenueEntry(tripID: finalTripID, client: client, origin: origin, destination: destination, payMethod: payMethod, amount: amount, notes: notes, plate: "NGP 2049", date: date)
        appData.revenueEntries.insert(entry, at: 0)
        tripID = ""; client = ""; origin = ""; destination = ""; amountText = ""; notes = ""; date = Date()
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { saved = false }
    }
}
