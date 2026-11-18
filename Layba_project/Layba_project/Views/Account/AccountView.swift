import SwiftUI

// Opened from the gear button on Home
struct AccountView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var settings: SettingsStore
    @State private var confirmLogout = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SubScreenHeader(title: "Account")

                // Profile card
                HStack(spacing: 16) {
                    Text(auth.monogram)
                        .font(.ffHero(22))
                        .foregroundColor(.ffYellow)
                        .frame(width: 58, height: 58)
                        .background(Color.ffYellow.opacity(0.12))
                        .cornerRadius(18)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(auth.company).font(.ffTitle(20)).foregroundColor(.white)
                        Text("\(auth.owner) · Owner / Operator").font(.ffLabel(13)).foregroundColor(.ffOnDarkSecondary)
                    }
                    Spacer(minLength: 0)
                }
                .padding(20)
                .background(Color.ffDarkPanel)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.ffDarkBorder, lineWidth: 1))

                SettingSectionHead("Account")
                SettingGroup {
                    SettingNavRow(label: "Profile information", value: auth.owner, showsArrow: false)
                    SettingNavRow(label: "Company details", value: auth.company, showsArrow: false)
                    NavigationLink(destination: LoginDetailsView()) {
                        SettingNavRow(label: "Login details", value: auth.username, showsLine: false)
                    }
                    .buttonStyle(.plain)
                }

                SettingSectionHead("Preferences")
                SettingGroup {
                    NavigationLink(destination: NotificationsView()) {
                        SettingNavRow(label: "Notifications")
                    }
                    .buttonStyle(.plain)
                    NavigationLink(destination: AppPreferencesView()) {
                        SettingNavRow(label: "App preferences", showsLine: false)
                    }
                    .buttonStyle(.plain)
                }

                SettingSectionHead("Session")
                SettingGroup {
                    Button(action: { confirmLogout = true }) {
                        SettingNavRow(label: "Log out", isDestructive: true, showsLine: false)
                    }
                    .buttonStyle(.plain)
                }

                Text("FreightFolio v1.0.0")
                    .font(.ffMono(11))
                    .foregroundColor(settings.onScreenSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert("Log out?", isPresented: $confirmLogout) {
            Button("Cancel", role: .cancel) {}
            Button("Log out", role: .destructive) { auth.logout() }
        } message: {
            Text("You will need your username and password to log in again.")
        }
    }
}
