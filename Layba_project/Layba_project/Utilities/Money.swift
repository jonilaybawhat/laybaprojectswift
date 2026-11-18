import Foundation

// Peso formatting helpers used by every screen.
enum Money {
    static func string(_ value: Double, decimals: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = decimals
        formatter.maximumFractionDigits = decimals
        let body = formatter.string(from: NSNumber(value: abs(value))) ?? "0"
        return (value < 0 ? "−" : "") + "₱" + body
    }

    // Short form for chart axes: 12000 -> 12k
    static func compact(_ value: Double) -> String {
        if abs(value) >= 1000 { return "\(Int((value / 1000).rounded()))k" }
        return "\(Int(value))"
    }
}
