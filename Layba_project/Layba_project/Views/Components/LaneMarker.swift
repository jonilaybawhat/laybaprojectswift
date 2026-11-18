import SwiftUI

struct LaneMarker: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 2))
                path.addLine(to: CGPoint(x: geo.size.width, y: 2))
            }
            .stroke(style: StrokeStyle(lineWidth: 4, dash: [14, 10]))
        }
        .frame(height: 4)
        .foregroundColor(.ffYellow)
    }
}
