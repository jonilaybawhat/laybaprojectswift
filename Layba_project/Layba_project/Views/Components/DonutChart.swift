import SwiftUI

// Color for each expense category (used by Reports and Charts)
extension ExpenseCategory {
    var color: Color {
        switch self {
        case .fuel: return .ffRed
        case .driverPay: return .ffSteelBlue
        case .maintenance: return .ffSteel
        case .toll: return .ffYellow
        case .registration: return .ffPurple
        case .other: return .ffGrayChip
        }
    }
}

// Donut chart built with Circle().trim so it works on iOS 16
struct DonutChart: View {
    let shares: [CategoryShare]

    private var segments: [(start: Double, end: Double, color: Color)] {
        var result: [(start: Double, end: Double, color: Color)] = []
        var running = 0.0
        for share in shares {
            let fraction = share.percent / 100
            result.append((start: running, end: running + fraction, color: share.category.color))
            running += fraction
        }
        return result
    }

    var body: some View {
        ZStack {
            ForEach(Array(segments.enumerated()), id: \.offset) { _, seg in
                Circle()
                    .trim(from: seg.start + 0.004, to: max(seg.start + 0.004, seg.end - 0.004))
                    .stroke(seg.color, style: StrokeStyle(lineWidth: 22, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
            }
            if let top = shares.first {
                VStack(spacing: 2) {
                    Text("\(Int(top.percent.rounded()))%").font(.ffHero(20)).foregroundColor(.ffInk)
                    Text(top.category.rawValue).font(.ffLabel(10)).foregroundColor(.ffSteel)
                }
            }
        }
        .padding(11)
        .frame(width: 148, height: 148)
    }
}
