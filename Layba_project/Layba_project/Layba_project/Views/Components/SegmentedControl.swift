import SwiftUI

struct SegmentedControl<T: RawRepresentable & Hashable & CaseIterable>: View where T.RawValue == String, T.AllCases: RandomAccessCollection {
    @Binding var selection: T
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(Array(T.allCases), id: \.self) { option in Text(option.rawValue).tag(option) }
        }
        .pickerStyle(.segmented)
    }
}
