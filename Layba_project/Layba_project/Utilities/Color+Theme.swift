import SwiftUI
import UIKit

extension UIColor {
    // Makes a UIColor from a hex code like "14181F"
    nonisolated convenience init(hex: String) {
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(rgb & 0x0000FF) / 255,
                  alpha: 1)
    }

    // A color that changes by itself between light mode and dark mode
    nonisolated static func adaptive(light: String, dark: String) -> UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        }
    }
}

extension Color {
    init(hex: String) {
        self.init(uiColor: UIColor(hex: hex))
    }

    // Light value / dark value
    init(light: String, dark: String) {
        self.init(uiColor: .adaptive(light: light, dark: dark))
    }

    // Cards and text: white cards in light mode, gray cards in dark mode
    static let ffPanel = Color(light: "FFFFFF", dark: "2C2C2E")      // cards, fields
    static let ffInk = Color(light: "14181F", dark: "F2F2F7")        // main text
    static let ffSteel = Color(light: "5B6472", dark: "A1A1AA")      // secondary text
    static let ffBorder = Color(light: "DCE0E4", dark: "3A3A3C")
    static let ffPaper = Color(light: "EEF0F2", dark: "3A3A3C")      // chips / light background
    static let ffInfoBg = Color(light: "E3EAF0", dark: "23303D")     // insight box

    // Money colors (a bit brighter in dark mode so they are easy to read)
    static let ffGreen = Color(light: "2F6B4F", dark: "4CBF86")
    static let ffGreenBg = Color(light: "E7F1EC", dark: "1F3A2D")
    static let ffRed = Color(light: "C1443B", dark: "F0675C")
    static let ffRedBg = Color(light: "FBEAE8", dark: "45221F")
    static let ffSteelBlue = Color(light: "33546F", dark: "8FB4D6")
    static let ffGrayChip = Color(light: "C8CDD4", dark: "8E8E93")
    static let ffPurple = Color(light: "7A6A9E", dark: "A898D0")

    // Brand colors (same in both modes)
    static let ffYellow = Color(hex: "FFC845")
    static let ffYellowInk = Color(hex: "3D2E00")

    // Dark theme screen colors
    static let ffBlack = Color.black
    static let ffOnDark = Color.white
    static let ffOnDarkSecondary = Color(hex: "9BA3AF")
    static let ffDarkPanel = Color(hex: "14181F")
    static let ffDarkField = Color(hex: "1E232C")
    static let ffDarkBorder = Color(hex: "2A303A")
}
