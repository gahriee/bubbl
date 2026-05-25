import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var vm = ProfileViewModel(authRepo: AuthRepository())

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(vm.displayName.prefix(1)).uppercased())
                                    .font(.largeTitle)
                                    .foregroundColor(.accentColor)
                            )
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .listRowBackground(Color.clear)

                Section(header: Text("Profile Information")) {
                    if let email = appState.currentUser?.email {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(email)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    TextField("Display Name", text: $vm.displayName)
                        .disableAutocorrection(true)
                }

                if let error = vm.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }

                Section {
                    Button(action: {
                        Task { await vm.saveChanges() }
                    }) {
                        if vm.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Save Changes")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(vm.isLoading || vm.displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                Section {
                    Button(action: {
                        vm.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                vm.loadUser(from: appState)
            }
        }
    }
}
