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

enum DateFormatOption: String, CaseIterable, Identifiable {
    case monthFirst = "MM/DD/YYYY"
    case dayFirst = "DD/MM/YYYY"
    case yearFirst = "YYYY-MM-DD"
    var id: String { rawValue }

    var pattern: String {
        switch self {
        case .monthFirst: return "MM/dd/yyyy"
        case .dayFirst: return "dd/MM/yyyy"
        case .yearFirst: return "yyyy-MM-dd"
        }
    }
}

enum ReportPeriod: String, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    var id: String { rawValue }
}

enum ChartMode: String, CaseIterable, Identifiable {
    case trend = "Trend"
    case categories = "Categories"
    var id: String { rawValue }
}
