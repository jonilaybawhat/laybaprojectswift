import SwiftUI
import Combine

// Small in-app banner that shows for a few seconds (used for new revenue / expense alerts).
final class ToastController: ObservableObject {
    @Published var message: String?
    private var workItem: DispatchWorkItem?

    func show(_ text: String) {
        workItem?.cancel()
        withAnimation(.spring()) { message = text }
        let item = DispatchWorkItem { [weak self] in
            withAnimation(.easeOut) { self?.message = nil }
        }
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8, execute: item)
    }
}
