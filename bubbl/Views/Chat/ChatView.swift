import SwiftUI

struct ChatView: View {
    @StateObject private var vm: ChatViewModel

    // Since we don't have full DI setup yet, we instantiate repositories directly
    init(conversation: Conversation, currentUser: BubblUser) {
        _vm = StateObject(wrappedValue: ChatViewModel(
            conversation:     conversation,
            currentUser:      currentUser,
            messageRepo:      MessageRepository(),
            conversationRepo: ConversationRepository()
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.messages) { message in
                            MessageBubble(
                                message:   message,
                                isFromMe:  message.senderID == vm.currentUser.id
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
                .onChange(of: vm.messages.count) { _ in
                    if let last = vm.messages.last {
                        withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                    }
                }
            }

            Divider()
            ChatInputBar(text: $vm.inputText, isSending: vm.isSending) {
                Task { await vm.send() }
            }
        }
        .navigationTitle(vm.conversation.participantNames.values.first ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear  { vm.startObserving() }
        .onDisappear { vm.stopObserving() }
    }
}
