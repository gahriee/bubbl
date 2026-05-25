import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = ProfileViewModel(authRepo: AuthRepository())

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Avatar Section
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 100, height: 100)
                                    .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Text(String(vm.displayName.prefix(1)).uppercased())
                                    .font(.system(size: 40, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 4) {
                                Text(vm.displayName.isEmpty ? "User" : vm.displayName)
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                
                                if let email = appState.currentUser?.email {
                                    Text(email)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.top, 24)

                        // Editable Info Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Profile Information")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.secondary)
                                .padding(.leading, 8)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.secondary)
                                        .frame(width: 24)
                                    
                                    TextField("Display Name", text: $vm.displayName)
                                        .font(.system(size: 17, weight: .regular, design: .rounded))
                                        .disableAutocorrection(true)
                                }
                                .padding()
                            }
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        }

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

                        // Action Buttons
                        VStack(spacing: 16) {
                            Button(action: {
                                Task { await vm.saveChanges(appState: appState) }
                            }) {
                                HStack {
                                    if vm.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Text("Save Changes")
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
                            .disabled(vm.isLoading || vm.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .opacity(vm.isLoading || vm.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                            
                            Button(action: {
                                vm.signOut()
                            }) {
                                Text("Sign Out")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.red.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            }
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                vm.loadUser(from: appState)
            }
            .overlay(
                VStack {
                    if vm.showSuccessToast {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Profile updated successfully")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.showSuccessToast)
            )
        }
    }
}
