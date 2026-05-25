import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    var isSending: Bool
    var onSend: () -> Void

    var body: some View {
        HStack {
            TextField("Type a message...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)
            
            Button(action: onSend) {
                if isSending {
                    ProgressView()
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                }
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom))
    }
}
