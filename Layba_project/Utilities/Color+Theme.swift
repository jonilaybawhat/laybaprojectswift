import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }

    static let ffInk = Color(hex: "14181F")
    static let ffPaper = Color(hex: "EEF0F2")
    static let ffPanel = Color.white
    static let ffYellow = Color(hex: "FFC845")
    static let ffYellowInk = Color(hex: "3D2E00")
    static let ffGreen = Color(hex: "2F6B4F")
    static let ffGreenBg = Color(hex: "E7F1EC")
    static let ffRed = Color(hex: "C1443B")
    static let ffRedBg = Color(hex: "FBEAE8")
    static let ffSteelBlue = Color(hex: "33546F")
    static let ffSteel = Color(hex: "5B6472")
    static let ffBorder = Color(hex: "DCE0E4")

    // Black home theme
    static let ffBlack = Color.black
    static let ffOnDark = Color.white
    static let ffOnDarkSecondary = Color(hex: "9BA3AF")
}
