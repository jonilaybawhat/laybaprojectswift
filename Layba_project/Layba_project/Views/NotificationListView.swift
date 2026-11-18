import SwiftUI

// Opened from the bell icon on Home
struct NotificationListView: View {
    @EnvironmentObject var appData: AppData
    @State private var confirmClear = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SubScreenHeader(title: "Notifications", subtitle: "New entries and weekly summaries.")

                if appData.notifications.isEmpty {
                    Card {
                        Text("No notifications yet.").font(.ffBody(14)).foregroundColor(.ffInk)
                        Text("You can turn them on in Settings → Notifications.")
                            .font(.ffLabel(12)).foregroundColor(.ffSteel)
                    }
                } else {
                    Card {
                        ForEach(Array(appData.notifications.enumerated()), id: \.element.id) { index, item in
                            if index > 0 { RowLine() }
                            NotificationRow(item: item)
                        }
                    }

                    Button(action: { confirmClear = true }) {
                        Text("Clear all")
                            .font(.ffLabel(13))
                            .foregroundColor(.ffRed)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onDisappear { appData.markAllRead() }     // unread dots stay while you are looking
        .alert("Clear all notifications?", isPresented: $confirmClear) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) { appData.clearNotifications() }
        }
    }
}

// One row in the notifications list
struct NotificationRow: View {
    @EnvironmentObject var settings: SettingsStore
    let item: AppNotification

    var icon: String {
        switch item.kind {
        case "revenue": return "plus.circle.fill"
        case "expense": return "minus.circle.fill"
        default: return "calendar.circle.fill"
        }
    }

    var color: Color {
        switch item.kind {
        case "revenue": return .ffGreen
        case "expense": return .ffRed
        default: return .ffSteelBlue
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .font(.ffBody(14).weight(item.isRead ? .regular : .bold))
                    .foregroundColor(.ffInk)
                Text(item.message).font(.ffLabel(12)).foregroundColor(.ffSteel)
                Text("\(settings.formatDate(item.date)) · \(item.date.formatted(date: .omitted, time: .shortened))")
                    .font(.ffLabel(10)).foregroundColor(.ffSteel)
            }
            Spacer(minLength: 0)
            if !item.isRead {
                Circle().fill(Color.ffYellow).frame(width: 8, height: 8).padding(.top, 6)
            }
        }
        .padding(.vertical, 8)
    }
}
