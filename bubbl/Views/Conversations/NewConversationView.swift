import SwiftUI

struct NewConversationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ConversationListViewModel
    @State private var email = ""

    var onConversationCreated: ((Conversation) -> Void)?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter user's email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: {
                    Task {
                        if let convo = await vm.startConversation(withEmail: email) {
                            presentationMode.wrappedValue.dismiss()
                            onConversationCreated?(convo)
                        }
                    }
                }) {
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        Text("Search & Chat")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || vm.isLoading)
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("New Message")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
