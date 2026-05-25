import Foundation
import FirebaseFirestore

protocol MessageRepositoryProtocol {
    func observeMessages(
        in conversationID: String,
        onChange: @escaping ([Message]) -> Void
    ) -> ListenerRegistration

    func send(message: Message) async throws
    func markAsRead(messageID: String, in conversationID: String) async throws
}
