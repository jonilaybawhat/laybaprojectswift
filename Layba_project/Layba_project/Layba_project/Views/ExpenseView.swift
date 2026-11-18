import SwiftUI

struct ExpenseView: View {
    @EnvironmentObject var appData: AppData
    @EnvironmentObject var settings: SettingsStore
    @EnvironmentObject var toast: ToastController

    @State private var tripID = ""
    @State private var category: ExpenseCategory = .fuel
    @State private var vendor = ""
    @State private var plate = "NGP 2049"
    @State private var payMethod: PaymentMethod = .cash
    @State private var amountText = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var saved = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    AppHeader(title: "Log expense")
                    LaneMarker()

                    Card {
                        Text("Trip ID (optional)").font(.ffLabel(11)).foregroundColor(.ffSteel)
                        TextField("e.g. TRIP-001", text: $tripID).textFieldStyle(.roundedBorder)
                        TripSuggestionChips(tripIDs: appData.allTripIDs, selection: $tripID)

                        ChipSelect(selection: $category)
                        TextField("Vendor / location", text: $vendor).textFieldStyle(.roundedBorder)
                        TextField("Plate number", text: $plate).textFieldStyle(.roundedBorder)
                        SegmentedControl(selection: $payMethod)
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                        TextField("Notes (optional)", text: $notes).textFieldStyle(.roundedBorder)
                    }

                    PrimaryButton(label: saved ? "Saved ✓" : "Save expense", action: save)

                    Card {
                        SectionTitle("This month by category")
                        ForEach(ExpenseCategory.allCases) { cat in
                            HStack {
                                Circle().fill(cat.color).frame(width: 8, height: 8)
                                Text(cat.rawValue).font(.ffBody(13)).foregroundColor(.ffInk)
                                Spacer()
                                Text(Money.string(appData.expenseTotal(for: cat))).font(.ffMono(13)).foregroundColor(.ffRed)
                            }
                        }
                    }

                    ForEach(appData.expenseByMonth) { month in
                        Card {
                            MonthHeader(label: month.label, total: month.total, isRevenue: false)
                            ForEach(Array(month.entries.enumerated()), id: \.element.id) { index, entry in
                                if index > 0 { RowLine() }
                                if entry.tripID.isEmpty {
                                    ExpenseDetailRow(entry: entry)
                                } else {
                                    NavigationLink(destination: TripDetailView(tripID: entry.tripID)) {
                                        ExpenseDetailRow(entry: entry)
                                    }
                                    .buttonStyle(.plain)
                                }
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
        guard let amount = Double(amountText), amount > 0 else { return }
        let entry = ExpenseEntry(tripID: tripID, category: category, vendor: vendor, plate: plate,
                                 payMethod: payMethod, amount: amount, notes: notes, date: date)
        appData.addExpense(entry)
        if settings.notifyNewExpense {
            toast.show("New expense · \(category.rawValue) · \(Money.string(amount))")
        }
        tripID = ""; vendor = ""; amountText = ""; notes = ""; date = Date()
        payMethod = settings.defaultPayment
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { saved = false }
    }
}
