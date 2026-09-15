import SwiftUI

struct PrimaryButton: View {
    let label: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.ffLabel(15))
                .foregroundColor(.ffYellowInk)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.ffYellow)
                .cornerRadius(14)
        }
    }
}
