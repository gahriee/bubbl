import Foundation
import FirebaseFirestore

final class ConversationRepository: ConversationRepositoryProtocol {
    private let db = Firestore.firestore()

    func observeConversations(
        for userID: String,
        onChange: @escaping ([Conversation]) -> Void
    ) -> ListenerRegistration {
        return db.collection(Constants.conversations)
            .whereField("participantIDs", arrayContains: userID)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    onChange([])
                    return
                }
                let conversations = documents.compactMap { doc -> Conversation? in
                    Conversation(document: doc.data(), id: doc.documentID)
                }
                onChange(conversations)
            }
    }

    func findConversation(between userID: String, and otherID: String) async throws -> Conversation? {
        let snapshot = try await db.collection(Constants.conversations)
            .whereField("participantIDs", arrayContains: userID)
            .getDocuments()
        
        for doc in snapshot.documents {
            if let convo = Conversation(document: doc.data(), id: doc.documentID),
               convo.participantIDs.contains(otherID) {
                return convo
            }
        }
        return nil
    }

    func createConversation(_ conversation: Conversation) async throws -> Conversation {
        try await db.collection(Constants.conversations).document(conversation.id).setData(conversation.toMap)
        return conversation
    }

    func updateLastMessage(conversationID: String, text: String, date: Date) async throws {
        try await db.collection(Constants.conversations).document(conversationID).updateData([
            "lastMessage": text,
            "lastMessageDate": Timestamp(date: date)
        ])
    }

    func deleteConversation(_ conversationID: String) async throws {
        try await db.collection(Constants.conversations).document(conversationID).delete()
    }
}
