import SwiftUI

struct ConversationRowView: View {
    let conversation: Conversation
    let currentUserID: String

    var otherParticipantName: String {
        let otherIDs = conversation.participantIDs.filter { $0 != currentUserID }
        if let first = otherIDs.first, let name = conversation.participantNames[first] {
            return name
        }
        return "Unknown User"
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.accentColor.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(otherParticipantName.prefix(1)).uppercased())
                        .font(.headline)
                        .foregroundColor(.accentColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(otherParticipantName)
                    .font(.headline)
                
                Text(conversation.lastMessage.isEmpty ? "New conversation" : conversation.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(conversation.lastMessageDate, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                let unread = conversation.unreadCount[currentUserID] ?? 0
                if unread > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Text("\(unread)")
                                .font(.caption2)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(.vertical, 4)
    }
}
