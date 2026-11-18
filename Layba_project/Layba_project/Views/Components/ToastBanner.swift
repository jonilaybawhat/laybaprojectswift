import SwiftUI

// Banner that slides in from the top. Driven by ToastController.
struct ToastBanner: View {
    @EnvironmentObject var toast: ToastController

    var body: some View {
        VStack {
            if let message = toast.message {
                HStack(spacing: 10) {
                    Image(systemName: "bell.fill").foregroundColor(.ffYellow)
                    Text(message).font(.ffLabel(13)).foregroundColor(.white)
                    Spacer(minLength: 0)
                }
                .padding(14)
                .background(Color.ffDarkPanel)
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.ffDarkBorder, lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            Spacer()
        }
        .allowsHitTesting(false)
    }
}
