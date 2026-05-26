import SwiftUI

struct ConversationRowView: View {
    let conversation: Conversation
    let currentUserID: String

    var otherParticipantName: String {
        let otherIDs = conversation.participantIDs.filter { $0 != currentUserID }
        if let first = otherIDs.first, let name = conversation.participantNames[first], !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        }
        return "Unknown User"
    }

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.8), .purple.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: .purple.opacity(0.3), radius: 5, x: 0, y: 3)
                
                Text(String(otherParticipantName.prefix(1)).uppercased())
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            // Message Info
            VStack(alignment: .leading, spacing: 6) {
                Text(otherParticipantName)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(conversation.lastMessage.isEmpty ? "Start a conversation" : conversation.lastMessage)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // Date & Badge
            VStack(alignment: .trailing, spacing: 6) {
                Text(conversation.lastMessageDate, style: .time)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                
                let unread = conversation.unreadCount[currentUserID] ?? 0
                if unread > 0 {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 24, height: 24)
                            .shadow(color: .red.opacity(0.4), radius: 4, x: 0, y: 2)
                        
                        Text("\(unread)")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                } else {
                    Spacer().frame(height: 24)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
