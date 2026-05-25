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

                List(vm.conversations) { conversation in
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
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewConversation = true
                    }) {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.accentColor)
                            .shadow(color: .accentColor.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                }
            }
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
