import SwiftUI

struct MessageBubble: View {
    let message: Message
    let isFromMe: Bool

    var body: some View {
        HStack {
            if isFromMe { Spacer(minLength: 50) }
            VStack(alignment: isFromMe ? .trailing : .leading, spacing: 4) {
                Text(message.isUnsent ? "Unsent a message" : message.text)
                    .font(.system(size: 16, weight: message.isUnsent ? .light : .regular, design: .rounded))
                    .italic(message.isUnsent)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if message.isUnsent {
                                Color(UIColor.secondarySystemGroupedBackground)
                            } else if isFromMe {
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                Color(UIColor.secondarySystemGroupedBackground)
                            }
                        }
                    )
                    .foregroundColor(message.isUnsent ? .secondary : (isFromMe ? .white : .primary))
                    .clipShape(ChatBubbleShape(isFromMe: isFromMe))
                    .shadow(color: (isFromMe && !message.isUnsent) ? .purple.opacity(0.25) : .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        Group {
                            if message.isUnsent {
                                ChatBubbleShape(isFromMe: isFromMe)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            }
                        }
                    )
                
                HStack(spacing: 4) {
                    Text(message.date, style: .time)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        
                    if message.isEdited && !message.isUnsent {
                        Text("(Edited)")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 4)
            }
            if !isFromMe { Spacer(minLength: 50) }
        }
    }
}

struct ChatBubbleShape: Shape {
    var isFromMe: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight, isFromMe ? .bottomLeft : .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        return Path(path.cgPath)
    }
}
