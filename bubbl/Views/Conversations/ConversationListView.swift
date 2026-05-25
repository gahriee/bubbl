import SwiftUI

struct ConversationListView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = ConversationListViewModel(conversationRepo: ConversationRepository(), authRepo: AuthRepository())
    @State private var showNewConversation = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                if vm.conversations.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary.opacity(0.5))
                        
                        Text("No Conversation History")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Tap the new chat icon below to start talking with your friends.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                    }
                } else {
                    List {
                        ForEach(vm.conversations) { conversation in
                            if let currentUser = appState.currentUser {
                                ZStack {
                                    NavigationLink(destination: ChatView(conversation: conversation, currentUser: currentUser)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    
                                    ConversationRowView(conversation: conversation, currentUserID: currentUser.id)
                                        .padding(.all, 12)
                                        .background(Color(UIColor.secondarySystemGroupedBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            }
                        }
                        .onDelete(perform: vm.deleteConversation)
                    }
                    .listStyle(PlainListStyle())
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showNewConversation = true
                        }) {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue.opacity(0.9), .purple.opacity(0.9)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .purple.opacity(0.3), radius: 6, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Messages")
            .sheet(isPresented: $showNewConversation) {
                NewConversationView(vm: vm) { conversation in
                    // Automatically navigate to this conversation if needed in future
                }
            }
        }
        .onAppear {
            vm.startObserving()
        }
        .onDisappear {
            vm.stopObserving()
        }
    }
}
