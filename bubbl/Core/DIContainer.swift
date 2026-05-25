import Foundation

final class DIContainer {
    let authRepo: AuthRepositoryProtocol
    let conversationRepo: ConversationRepositoryProtocol
    let messageRepo: MessageRepositoryProtocol

    init(
        authRepo:         AuthRepositoryProtocol         = AuthRepository(),
        conversationRepo: ConversationRepositoryProtocol = ConversationRepository(),
        messageRepo:      MessageRepositoryProtocol      = MessageRepository()
    ) {
        self.authRepo         = authRepo
        self.conversationRepo = conversationRepo
        self.messageRepo      = messageRepo
    }
}
