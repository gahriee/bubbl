import Foundation
import FirebaseFirestore

@MainActor
final class ConversationListViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let conversationRepo: ConversationRepositoryProtocol
    private let authRepo: AuthRepositoryProtocol
    private var listener: ListenerRegistration?

    init(conversationRepo: ConversationRepositoryProtocol, authRepo: AuthRepositoryProtocol) {
        self.conversationRepo = conversationRepo
        self.authRepo         = authRepo
    }

    func startObserving() {
        guard let userID = authRepo.currentUser?.id else { return }
        listener = conversationRepo.observeConversations(for: userID) { [weak self] updated in
            self?.conversations = updated.sorted { $0.lastMessageDate > $1.lastMessageDate }
        }
    }

    func stopObserving() {
        listener?.remove()
    }

    func startConversation(withEmail email: String) async -> Conversation? {
        guard let me = authRepo.currentUser else { return nil }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            guard let otherUser = try await authRepo.findUser(byEmail: email) else {
                errorMessage = "User not found."
                return nil
            }
            if let existing = try await conversationRepo.findConversation(between: me.id, and: otherUser.id) {
                return existing
            }
            let newConvo = Conversation(
                id:               UUID().uuidString,
                participantIDs:   [me.id, otherUser.id],
                participantNames: [me.id: me.displayName, otherUser.id: otherUser.displayName],
                lastMessage:      "",
                lastMessageDate:  Date(),
                unreadCount:      [me.id: 0, otherUser.id: 0]
            )
            return try await conversationRepo.createConversation(newConvo)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
