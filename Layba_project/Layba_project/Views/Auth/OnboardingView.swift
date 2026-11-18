import SwiftUI

// Get Started: Welcome -> Company profile -> Create login
struct OnboardingView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var settings: SettingsStore

    @State private var step = 0
    @State private var company = ""
    @State private var owner = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var errorMessage: String?

    var canContinueProfile: Bool {
        !company.trimmingCharacters(in: .whitespaces).isEmpty && !owner.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var canFinish: Bool {
        !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty && !confirm.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if step == 0 { welcome }
                if step == 1 { profile }
                if step == 2 { account }
            }
            .padding(20)
        }
        .screenBackground()
    }

    // MARK: Step 0 — Welcome

    var welcome: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer(minLength: 80)
            LogoMark()
            AppHeader(title: "FreightFolio")
            LaneMarker()
            Text("Cash flow management for Filipino trucking operators. Let's set up your company profile to get started.")
                .font(.ffBody(15))
                .foregroundColor(settings.onScreenSecondary)
            Spacer(minLength: 40)
            PrimaryButton(label: "Get started") { step = 1 }
            if auth.hasAccount {
                Button(action: { auth.showOnboarding = false }) {
                    Text("Back to login")
                        .font(.ffLabel(13))
                        .foregroundColor(settings.onScreenSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: Step 1 — Company profile

    var profile: some View {
        VStack(alignment: .leading, spacing: 16) {
            backButton { step = 0 }
            AppHeader(title: "Company profile", subtitle: "Tell us about your trucking business.")
            LaneMarker()
            DarkField(label: "Company / business name", placeholder: "e.g. Joman Company", text: $company)
            DarkField(label: "Owner name", placeholder: "e.g. Juan Dela Cruz", text: $owner)
            PrimaryButton(label: "Continue", isEnabled: canContinueProfile) { step = 2 }
            if !canContinueProfile {
                Text("Fill in both fields to continue.")
                    .font(.ffLabel(12))
                    .foregroundColor(settings.onScreenSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: Step 2 — Login details

    var account: some View {
        VStack(alignment: .leading, spacing: 16) {
            backButton { step = 1 }
            AppHeader(title: "Create your login", subtitle: "You will use this every time you open the app.")
            LaneMarker()
            DarkField(label: "Username", placeholder: "Choose a username", text: $username)
            DarkField(label: "Password", placeholder: "At least 6 characters", text: $password, isSecure: true)
            DarkField(label: "Confirm password", placeholder: "Type it again", text: $confirm, isSecure: true)
            if let errorMessage {
                Text(errorMessage).font(.ffLabel(12)).foregroundColor(.ffRed)
            }
            PrimaryButton(label: "Create account", isEnabled: canFinish, action: finish)
        }
    }

    func finish() {
        guard password == confirm else {
            errorMessage = "Passwords do not match."
            return
        }
        errorMessage = auth.register(company: company, owner: owner, username: username, password: password)
    }

    func backButton(_ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Text("Back").font(.ffLabel(14))
            }
            .foregroundColor(settings.onScreen)
        }
    }
}
