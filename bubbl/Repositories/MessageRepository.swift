import Foundation
import FirebaseFirestore

final class MessageRepository: MessageRepositoryProtocol {
    private let db = Firestore.firestore()

    func observeMessages(
        in conversationID: String,
        onChange: @escaping ([Message]) -> Void
    ) -> ListenerRegistration {
        return db.collection(Constants.conversations)
            .document(conversationID)
            .collection(Constants.messages)
            .order(by: "date", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }
                let messages = documents.compactMap { doc -> Message? in
                    Message(document: doc.data(), id: doc.documentID)
                }
                onChange(messages)
            }
    }

    func send(message: Message) async throws {
        try await db.collection(Constants.conversations)
            .document(message.conversationID)
            .collection(Constants.messages)
            .document(message.id)
            .setData(message.toMap)
    }

    func editMessage(messageID: String, newText: String, in conversationID: String) async throws {
        try await db.collection(Constants.conversations)
            .document(conversationID)
            .collection(Constants.messages)
            .document(messageID)
            .updateData([
                "text": newText,
                "isEdited": true
            ])
    }

    func unsendMessage(messageID: String, in conversationID: String) async throws {
        try await db.collection(Constants.conversations)
            .document(conversationID)
            .collection(Constants.messages)
            .document(messageID)
            .updateData([
                "text": "Unsent a message",
                "isUnsent": true
            ])
    }

    func markAsRead(messageID: String, in conversationID: String) async throws {
        try await db.collection(Constants.conversations)
            .document(conversationID)
            .collection(Constants.messages)
            .document(messageID)
            .updateData(["isRead": true])
    }
}
