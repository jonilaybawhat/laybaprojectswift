import SwiftUI

extension Font {
    static func ffHero(_ size: CGFloat = 34) -> Font { .custom("Oswald-SemiBold", size: size) }
    static func ffTitle(_ size: CGFloat = 18) -> Font { .custom("Oswald-Medium", size: size) }
    static func ffBody(_ size: CGFloat = 15) -> Font { .custom("IBMPlexSans-Regular", size: size) }
    static func ffLabel(_ size: CGFloat = 12.5) -> Font { .custom("IBMPlexSans-Medium", size: size) }
    static func ffMono(_ size: CGFloat = 13) -> Font { .custom("IBMPlexMono-Medium", size: size) }
}
