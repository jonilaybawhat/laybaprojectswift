import SwiftUI

// Trip ID suggestion chips — tap to reuse an existing trip id
struct TripSuggestionChips: View {
    let tripIDs: [String]
    @Binding var selection: String

    var body: some View {
        if !tripIDs.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tripIDs, id: \.self) { id in
                        Text(id)
                            .font(.ffLabel(12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selection == id ? Color.ffInk : Color.ffPaper)
                            .foregroundColor(selection == id ? .white : .ffInk)
                            .cornerRadius(16)
                            .onTapGesture { selection = id }
                    }
                }
            }
        }
    }
}
