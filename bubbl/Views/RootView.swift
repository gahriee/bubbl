import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.currentUser != nil {
                MainTabView()
            } else {
                AuthView()
            }
        }
        .animation(.easeInOut, value: appState.currentUser != nil)
    }
}
