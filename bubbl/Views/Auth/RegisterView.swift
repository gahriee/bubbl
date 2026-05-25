import SwiftUI

struct RegisterView: View {
    @ObservedObject var vm: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                CustomTextField(icon: "person.fill", placeholder: "Display Name", text: $displayName)
                    .textInputAutocapitalization(.words)

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
                    _ = await vm.register(email: email, password: password, displayName: displayName)
                }
            }) {
                HStack {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Create Account")
                            .font(.headline)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .disabled(vm.isLoading || email.isEmpty || password.isEmpty || displayName.isEmpty)
            .opacity(vm.isLoading || email.isEmpty || password.isEmpty || displayName.isEmpty ? 0.6 : 1.0)
            .padding(.top, 8)
        }
        .padding(24)
    }
}
