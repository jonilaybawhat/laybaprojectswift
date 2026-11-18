import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var settings: SettingsStore

    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer(minLength: 40)
                LogoMark()
                AppHeader(title: "Welcome back", subtitle: "Log in to your account")
                LaneMarker()

                DarkField(label: "Username", placeholder: "Your username", text: $username)
                DarkField(label: "Password", placeholder: "Your password", text: $password, isSecure: true)

                if let errorMessage {
                    Text(errorMessage).font(.ffLabel(12)).foregroundColor(.ffRed)
                }

                PrimaryButton(label: "Log in", isEnabled: !username.isEmpty && !password.isEmpty, action: login)

                Button(action: { auth.showOnboarding = true }) {
                    Text("Create a new account")
                        .font(.ffLabel(13))
                        .foregroundColor(settings.onScreenSecondary)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 4)
            }
            .padding(20)
        }
        .screenBackground()
    }

    func login() {
        if auth.login(username: username, password: password) {
            errorMessage = nil
        } else {
            errorMessage = "Wrong username or password."
        }
    }
}

// Truck logo used on Login and Get Started
struct LogoMark: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24).fill(Color.ffDarkPanel)
            RoundedRectangle(cornerRadius: 24).stroke(Color.ffDarkBorder, lineWidth: 1)
            Image(systemName: "box.truck.fill")
                .font(.system(size: 36))
                .foregroundColor(.ffYellow)
        }
        .frame(width: 80, height: 80)
    }
}
