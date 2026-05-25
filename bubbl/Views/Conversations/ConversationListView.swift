import SwiftUI

struct ConversationListView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = ConversationListViewModel(conversationRepo: ConversationRepository(), authRepo: AuthRepository())
    @State private var showNewConversation = false

    var body: some View {
        NavigationView {
            List(vm.conversations) { conversation in
                if let currentUser = appState.currentUser {
                    NavigationLink(destination: ChatView(conversation: conversation, currentUser: currentUser)) {
                        ConversationRowView(conversation: conversation, currentUserID: currentUser.id)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Messages")
            .navigationBarItems(trailing: Button(action: {
                showNewConversation = true
            }) {
                Image(systemName: "square.and.pencil")
            })
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
