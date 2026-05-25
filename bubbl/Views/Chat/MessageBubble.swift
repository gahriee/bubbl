import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isFromMe: Bool

    var body: some View {
        HStack {
            if isFromMe { Spacer(minLength: 60) }
            VStack(alignment: isFromMe ? .trailing : .leading, spacing: 2) {
                Text(message.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isFromMe ? Color.accentColor : Color(.systemGray5))
                    .foregroundColor(isFromMe ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                Text(message.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            if !isFromMe { Spacer(minLength: 60) }
        }
    }
}
