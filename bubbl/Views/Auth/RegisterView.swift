import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""

    var body: some View {
        VStack(spacing: 16) {
            TextField("Display Name", text: $displayName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Button(action: {
                Task {
                    _ = await vm.register(email: email, password: password, displayName: displayName)
                }
            }) {
                if vm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isLoading || email.isEmpty || password.isEmpty || displayName.isEmpty)
        }
        .padding()
    }
}
