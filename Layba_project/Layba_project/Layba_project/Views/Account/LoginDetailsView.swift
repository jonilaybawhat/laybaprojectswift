import SwiftUI

// Change username and password
struct LoginDetailsView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var settings: SettingsStore

    @State private var username = ""
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var message: String?
    @State private var isError = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SubScreenHeader(title: "Login details", subtitle: "Change your username or password.")

                DarkField(label: "Username", placeholder: "Username", text: $username)
                DarkField(label: "Current password", placeholder: "Required to save changes", text: $currentPassword, isSecure: true)
                DarkField(label: "New password (optional)", placeholder: "Leave blank to keep the same", text: $newPassword, isSecure: true)
                DarkField(label: "Confirm new password", placeholder: "Type it again", text: $confirmPassword, isSecure: true)

                if let message {
                    Text(message).font(.ffLabel(12)).foregroundColor(isError ? .ffRed : .ffGreen)
                }

                PrimaryButton(label: "Save changes", isEnabled: !currentPassword.isEmpty, action: save)
            }
            .padding(16)
        }
        .screenBackground()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { username = auth.username }
    }

    func save() {
        if !newPassword.isEmpty && newPassword != confirmPassword {
            message = "New passwords do not match."
            isError = true
            return
        }
        if let error = auth.updateCredentials(currentPassword: currentPassword, newUsername: username, newPassword: newPassword) {
            message = error
            isError = true
        } else {
            message = "Saved. Use your new details next time you log in."
            isError = false
            currentPassword = ""; newPassword = ""; confirmPassword = ""
        }
    }
}
