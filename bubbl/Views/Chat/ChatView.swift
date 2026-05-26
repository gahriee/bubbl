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
        ZStack {
            // Background
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
                
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.messages) { message in
                                MessageBubble(
                                    message:   message,
                                    isFromMe:  message.senderID == vm.currentUser.id
                                )
                                .id(message.id)
                                .contextMenu {
                                    if message.senderID == vm.currentUser.id && !message.isUnsent {
                                        Button(action: {
                                            vm.startEditing(message)
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive, action: {
                                            vm.unsend(message)
                                        }) {
                                            Label("Unsend", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    .onChange(of: vm.messages.count) { _ in
                        if let last = vm.messages.last {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                ChatInputBar(
                    text: $vm.inputText,
                    isSending: vm.isSending,
                    editingMessage: vm.editingMessage,
                    onCancelEdit: { vm.cancelEditing() }
                ) {
                    Task { await vm.send() }
                }
            }
        }
        .navigationTitle(vm.conversation.participantNames.filter { $0.key != vm.currentUser.id }
                            .values.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear  { vm.startObserving() }
        .onDisappear { vm.stopObserving() }
    }
}
