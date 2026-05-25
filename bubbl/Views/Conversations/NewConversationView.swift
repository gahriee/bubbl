import SwiftUI

struct NewConversationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ConversationListViewModel
    @State private var email = ""

    var onConversationCreated: ((Conversation) -> Void)?

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Start a New Chat")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("Enter a friend's email address to connect.")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)

                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .frame(width: 24)
                        
                        TextField("user@example.com", text: $email)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .onChange(of: email) { newValue in
                                Task {
                                    await vm.searchUsers(query: newValue)
                                }
                            }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

                    if !vm.searchResults.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Suggestions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                
                            ForEach(vm.searchResults) { user in
                                Button(action: {
                                    email = user.email
                                    vm.searchResults = []
                                    Task {
                                        if let convo = await vm.startConversation(withEmail: user.email) {
                                            presentationMode.wrappedValue.dismiss()
                                            onConversationCreated?(convo)
                                        }
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(
                                                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                            )
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Text(String(user.displayName.prefix(1)).uppercased())
                                                    .font(.system(size: 14, weight: .bold))
                                                    .foregroundColor(.white)
                                            )
                                            
                                        VStack(alignment: .leading) {
                                            Text(user.displayName)
                                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                                .foregroundColor(.primary)
                                            Text(user.email)
                                                .font(.system(size: 14, weight: .regular, design: .rounded))
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                }
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                
                                if user.id != vm.searchResults.last?.id {
                                    Divider().padding(.leading, 64)
                                }
                            }
                        }
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

                    Button(action: {
                        Task {
                            if let convo = await vm.startConversation(withEmail: email) {
                                presentationMode.wrappedValue.dismiss()
                                onConversationCreated?(convo)
                            }
                        }
                    }) {
                        HStack {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Search & Chat")
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
                    .disabled(email.isEmpty || vm.isLoading)
                    .opacity(email.isEmpty || vm.isLoading ? 0.6 : 1.0)
                    .padding(.top, 8)

                    Spacer()
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}
