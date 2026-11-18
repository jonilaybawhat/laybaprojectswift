import SwiftUI

// Group that holds setting rows (white in light mode, gray in dark mode)
struct SettingGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var body: some View {
        VStack(spacing: 0) { content() }
            .background(Color.ffPanel)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ffBorder, lineWidth: 1))
    }
}

// Section label above a group
struct SettingSectionHead: View {
    @EnvironmentObject var settings: SettingsStore
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text.uppercased())
            .font(.ffLabel(11))
            .tracking(0.8)
            .foregroundColor(settings.onScreenSecondary)
            .padding(.top, 8)
            .padding(.leading, 4)
    }
}

// Row with label, optional value and optional arrow
struct SettingNavRow: View {
    let label: String
    var value: String? = nil
    var showsArrow: Bool = true
    var isDestructive: Bool = false
    var showsLine: Bool = true

    var body: some View {
        HStack {
            Text(label).font(.ffBody(15)).foregroundColor(isDestructive ? .ffRed : .ffInk)
            Spacer()
            if let value {
                Text(value).font(.ffBody(14)).foregroundColor(.ffSteel)
            }
            if showsArrow && !isDestructive {
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.ffSteel)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            if showsLine { RowLine().padding(.leading, 16) }
        }
    }
}

// Row with a switch
struct SettingToggleRow: View {
    let label: String
    var detail: String? = nil
    @Binding var isOn: Bool
    var showsLine: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.ffBody(15)).foregroundColor(.ffInk)
                if let detail {
                    Text(detail).font(.ffLabel(12)).foregroundColor(.ffSteel)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn).labelsHidden().tint(.ffGreen)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            if showsLine { RowLine().padding(.leading, 16) }
        }
    }
}
