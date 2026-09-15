import SwiftUI

struct ChipSelect<T: RawRepresentable & Hashable & CaseIterable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    @Binding var selection: T
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(T.allCases), id: \.self) { option in
                    Text(option.rawValue)
                        .font(.ffLabel(13))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selection == option ? Color.ffInk : Color.ffPaper)
                        .foregroundColor(selection == option ? .white : .ffInk)
                        .cornerRadius(20)
                        .onTapGesture { selection = option }
                }
            }
        }
    }
}
