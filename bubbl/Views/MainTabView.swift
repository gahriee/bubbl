import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ConversationListView()
                .tabItem {
                    Label("Messages", systemImage: "message.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
