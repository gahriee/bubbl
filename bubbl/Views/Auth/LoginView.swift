import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                CustomTextField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                CustomSecureField(icon: "lock.fill", placeholder: "Password", text: $password)
            }
            .padding(.top, 16)

            if let error = vm.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text(error)
                }
                .foregroundColor(.red)
                .font(.footnote)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity)
            }

            Button(action: {
                Task {
                    _ = await vm.login(email: email, password: password)
                }
            }) {
                HStack {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Login")
                            .font(.headline)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(vm.isLoading || email.isEmpty || password.isEmpty)
            .opacity(vm.isLoading || email.isEmpty || password.isEmpty ? 0.6 : 1.0)
            .padding(.top, 8)
        }
        .padding(24)
    }
}
