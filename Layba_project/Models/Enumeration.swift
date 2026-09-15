import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case gcash = "GCash"
    case bankTransfer = "Bank Transfer"
    case check = "Check"
    var id: String { rawValue }
}

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case fuel = "Fuel"
    case toll = "Toll"
    case maintenance = "Maintenance"
    case driverPay = "Driver pay"
    case registration = "Registration"
    case other = "Other"
    var id: String { rawValue }
}
