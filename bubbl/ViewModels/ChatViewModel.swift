import Foundation
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText = ""
    @Published var isSending = false
    @Published var editingMessage: Message?

    private let messageRepo: MessageRepositoryProtocol
    private let conversationRepo: ConversationRepositoryProtocol
    let currentUser: BubblUser
    let conversation: Conversation

    private var listener: ListenerRegistration?

    init(
        conversation: Conversation,
        currentUser: BubblUser,
        messageRepo: MessageRepositoryProtocol,
        conversationRepo: ConversationRepositoryProtocol
    ) {
        self.conversation     = conversation
        self.currentUser      = currentUser
        self.messageRepo      = messageRepo
        self.conversationRepo = conversationRepo
    }

    func startObserving() {
        listener = messageRepo.observeMessages(in: conversation.id) { [weak self] updated in
            self?.messages = updated.sorted { $0.date < $1.date }
        }
    }

    func stopObserving() {
        listener?.remove()
    }

    func send() async {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        isSending = true
        defer { isSending = false }

        if let editingMessage = editingMessage {
            do {
                try await messageRepo.editMessage(messageID: editingMessage.id, newText: text, in: conversation.id)
                
                if let lastMsg = messages.last, lastMsg.id == editingMessage.id {
                    try await conversationRepo.updateLastMessage(
                        conversationID: conversation.id,
                        text: text,
                        date: lastMsg.date
                    )
                }
                
                self.editingMessage = nil
            } catch {
                inputText = text
            }
        } else {
            let message = Message(
                id:             UUID().uuidString,
                conversationID: conversation.id,
                senderID:       currentUser.id,
                senderName:     currentUser.displayName,
                text:           text,
                date:           Date(),
                isRead:         false,
                isEdited:       false
            )
            do {
                try await messageRepo.send(message: message)
                try await conversationRepo.updateLastMessage(
                    conversationID: conversation.id,
                    text: text,
                    date: message.date
                )
            } catch {
                // Re-add text to input on failure
                inputText = text
            }
        }
    }

    func startEditing(_ message: Message) {
        editingMessage = message
        inputText = message.text
    }
    
    func cancelEditing() {
        editingMessage = nil
        inputText = ""
    }
    
    func unsend(_ message: Message) {
        Task {
            do {
                try await messageRepo.unsendMessage(messageID: message.id, in: conversation.id)
                
                if let lastMsg = messages.last, lastMsg.id == message.id {
                    try await conversationRepo.updateLastMessage(
                        conversationID: conversation.id,
                        text: "Unsent a message",
                        date: lastMsg.date
                    )
                }
            } catch {
                print("Failed to unsend message: \(error)")
            }
        }
    }
}
