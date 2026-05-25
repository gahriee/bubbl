import Foundation
import FirebaseFirestore

protocol ConversationRepositoryProtocol {
    func observeConversations(
        for userID: String,
        onChange: @escaping ([Conversation]) -> Void
    ) -> ListenerRegistration

    func findConversation(between userID: String, and otherID: String) async throws -> Conversation?
    func createConversation(_ conversation: Conversation) async throws -> Conversation
    func updateLastMessage(conversationID: String, text: String, date: Date) async throws
    func deleteConversation(_ conversationID: String) async throws
}
