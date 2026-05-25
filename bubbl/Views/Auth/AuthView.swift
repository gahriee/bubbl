import SwiftUI

struct AuthView: View {
    @StateObject private var vm = AuthViewModel(authRepo: AuthRepository())
    @State private var isShowingLogin = true

    var body: some View {
        NavigationView {
            VStack {
                Picker("Authentication", selection: $isShowingLogin) {
                    Text("Login").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if isShowingLogin {
                    LoginView(vm: vm)
                } else {
                    RegisterView(vm: vm)
                }

                Spacer()
            }
            .navigationTitle(isShowingLogin ? "Welcome Back" : "Create Account")
        }
    }
}
