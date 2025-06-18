import Foundation

struct ChatMessage: Identifiable, Equatable {
    enum Sender { case user, bot }
    let id = UUID()
    let text: String
    let sender: Sender
}
