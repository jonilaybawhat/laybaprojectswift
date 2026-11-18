import Foundation

// Sample trips so the dashboard, reports and charts have something to show
// on first launch. Dates are relative to today.
enum SampleData {

    private struct Cost {
        let category: ExpenseCategory
        let vendor: String
        let amount: Double
        var note: String = ""
    }

    private struct Trip {
        let daysAgo: Int
        let client: String
        let origin: String
        let destination: String
        let pay: PaymentMethod
        let amount: Double
        let note: String
        let costs: [Cost]
    }

    private static func cost(_ category: ExpenseCategory, _ vendor: String, _ amount: Double, note: String = "") -> Cost {
        Cost(category: category, vendor: vendor, amount: amount, note: note)
    }

    // Oldest first. Trip IDs are assigned in this order (TRIP-001 = oldest).
    private static let trips: [Trip] = [
        Trip(daysAgo: 160, client: "San Miguel Corp", origin: "Batangas", destination: "Manila", pay: .cash, amount: 16500, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 3900), cost(.toll, "SLEX", 620)]),
        Trip(daysAgo: 148, client: "Jollibee Foods Corp", origin: "Pampanga", destination: "Pasig", pay: .gcash, amount: 21000, note: "",
             costs: [cost(.fuel, "Shell Tarlac", 4100), cost(.toll, "NLEX", 680), cost(.driverPay, "Driver trip pay", 2500)]),
        Trip(daysAgo: 132, client: "Universal Robina Corp", origin: "Cavite", destination: "Quezon City", pay: .cash, amount: 12800, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 3600), cost(.toll, "CAVITEX", 240)]),
        Trip(daysAgo: 118, client: "Puregold", origin: "Laguna", destination: "Quezon City", pay: .bankTransfer, amount: 14200, note: "",
             costs: [cost(.fuel, "Caltex Calamba", 3800), cost(.maintenance, "Midas Auto Center", 5200, note: "Brake pads")]),
        Trip(daysAgo: 104, client: "San Miguel Corp", origin: "Batangas", destination: "Manila", pay: .cash, amount: 17800, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 4000), cost(.toll, "SLEX", 620)]),
        Trip(daysAgo: 90, client: "Jollibee Foods Corp", origin: "Pampanga", destination: "Pasig", pay: .bankTransfer, amount: 23500, note: "",
             costs: [cost(.fuel, "Shell Tarlac", 4300), cost(.toll, "NLEX", 680), cost(.driverPay, "Driver trip pay", 2500)]),
        Trip(daysAgo: 76, client: "Universal Robina Corp", origin: "Cavite", destination: "Quezon City", pay: .cash, amount: 13600, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 3700), cost(.registration, "LTO Lucena", 6800, note: "Yearly renewal")]),
        Trip(daysAgo: 62, client: "Puregold", origin: "Laguna", destination: "Quezon City", pay: .gcash, amount: 15100, note: "",
             costs: [cost(.fuel, "Caltex Calamba", 3900), cost(.toll, "SLEX", 410)]),
        Trip(daysAgo: 49, client: "San Miguel Corp", origin: "Batangas", destination: "Manila", pay: .cash, amount: 18900, note: "Delivered on time",
             costs: [cost(.fuel, "Petron Sta. Rosa", 4200), cost(.toll, "SLEX", 620), cost(.driverPay, "Driver trip pay", 2500)]),
        Trip(daysAgo: 38, client: "Jollibee Foods Corp", origin: "Pampanga", destination: "Pasig", pay: .bankTransfer, amount: 22800, note: "",
             costs: [cost(.fuel, "Shell Tarlac", 4400), cost(.toll, "NLEX", 680)]),
        Trip(daysAgo: 27, client: "Universal Robina Corp", origin: "Cavite", destination: "Quezon City", pay: .cash, amount: 12900, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 3600), cost(.maintenance, "Tire shop", 7800, note: "Two new tires")]),
        Trip(daysAgo: 17, client: "Puregold", origin: "Laguna", destination: "Quezon City", pay: .gcash, amount: 14700, note: "",
             costs: [cost(.fuel, "Caltex Calamba", 3800), cost(.toll, "SLEX", 410), cost(.other, "Parking and meals", 650)]),
        Trip(daysAgo: 9, client: "San Miguel Corp", origin: "Batangas", destination: "Manila", pay: .cash, amount: 18500, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 4200), cost(.toll, "SLEX", 620)]),
        Trip(daysAgo: 5, client: "Jollibee Foods Corp", origin: "Pampanga", destination: "Pasig", pay: .bankTransfer, amount: 22000, note: "",
             costs: [cost(.fuel, "Shell Tarlac", 4350), cost(.toll, "NLEX", 680), cost(.driverPay, "Driver trip pay", 2500)]),
        Trip(daysAgo: 1, client: "Universal Robina Corp", origin: "Cavite", destination: "Quezon City", pay: .cash, amount: 13200, note: "",
             costs: [cost(.fuel, "Petron Sta. Rosa", 3650), cost(.maintenance, "Midas Auto Center", 3500, note: "Oil change + brake check")]),
        Trip(daysAgo: 0, client: "Puregold", origin: "Laguna", destination: "Quezon City", pay: .gcash, amount: 15500, note: "",
             costs: [cost(.fuel, "Caltex Calamba", 3900)])
    ]

    static func make() -> (revenue: [RevenueEntry], expenses: [ExpenseEntry]) {
        var revenue: [RevenueEntry] = []
        var expenses: [ExpenseEntry] = []

        for (index, trip) in trips.enumerated() {
            let tripID = String(format: "TRIP-%03d", index + 1)
            let date = Calendar.current.date(byAdding: .day, value: -trip.daysAgo, to: Date()) ?? Date()

            revenue.append(RevenueEntry(tripID: tripID, client: trip.client, origin: trip.origin, destination: trip.destination,
                                        payMethod: trip.pay, amount: trip.amount, notes: trip.note, plate: "NGP 2049", date: date))

            for item in trip.costs {
                expenses.append(ExpenseEntry(tripID: tripID, category: item.category, vendor: item.vendor, plate: "NGP 2049",
                                             payMethod: .cash, amount: item.amount, notes: item.note, date: date))
            }
        }

        revenue.sort { $0.date > $1.date }
        expenses.sort { $0.date > $1.date }
        return (revenue, expenses)
    }
}
