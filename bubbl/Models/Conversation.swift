import Foundation
import FirebaseFirestore

struct Conversation: Identifiable, Equatable {
    let id: String
    let participantIDs: [String]
    let participantNames: [String: String]
    var lastMessage: String
    var lastMessageDate: Date
    var unreadCount: [String: Int]

    init(
        id: String,
        participantIDs: [String],
        participantNames: [String: String],
        lastMessage: String,
        lastMessageDate: Date,
        unreadCount: [String: Int]
    ) {
        self.id               = id
        self.participantIDs   = participantIDs
        self.participantNames = participantNames
        self.lastMessage      = lastMessage
        self.lastMessageDate  = lastMessageDate
        self.unreadCount      = unreadCount
    }

    init?(document: [String: Any], id: String) {
        guard
            let participantIDs   = document["participantIDs"]   as? [String],
            let participantNames = document["participantNames"] as? [String: String],
            let lastMessage      = document["lastMessage"]      as? String,
            let timestamp        = document["lastMessageDate"]  as? Timestamp
        else { return nil }
        self.id               = id
        self.participantIDs   = participantIDs
        self.participantNames = participantNames
        self.lastMessage      = lastMessage
        self.lastMessageDate  = timestamp.dateValue()
        self.unreadCount      = document["unreadCount"] as? [String: Int] ?? [:]
    }

    var toMap: [String: Any] {
        [
            "participantIDs":   participantIDs,
            "participantNames": participantNames,
            "lastMessage":      lastMessage,
            "lastMessageDate":  Timestamp(date: lastMessageDate),
            "unreadCount":      unreadCount
        ]
    }
}
