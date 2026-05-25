import Foundation
import FirebaseFirestore

struct Message: Identifiable, Equatable {
    let id: String
    let conversationID: String
    let senderID: String
    let senderName: String
    let text: String
    let date: Date
    var isRead: Bool
    var isEdited: Bool
    var isUnsent: Bool

    init(
        id: String,
        conversationID: String,
        senderID: String,
        senderName: String,
        text: String,
        date: Date,
        isRead: Bool,
        isEdited: Bool = false,
        isUnsent: Bool = false
    ) {
        self.id             = id
        self.conversationID = conversationID
        self.senderID       = senderID
        self.senderName     = senderName
        self.text           = text
        self.date           = date
        self.isRead         = isRead
        self.isEdited       = isEdited
        self.isUnsent       = isUnsent
    }

    init?(document: [String: Any], id: String) {
        guard
            let conversationID = document["conversationID"] as? String,
            let senderID       = document["senderID"]       as? String,
            let senderName     = document["senderName"]     as? String,
            let text           = document["text"]           as? String,
            let timestamp      = document["date"]           as? Timestamp
        else { return nil }
        self.id             = id
        self.conversationID = conversationID
        self.senderID       = senderID
        self.senderName     = senderName
        self.text           = text
        self.date           = timestamp.dateValue()
        self.isRead         = document["isRead"] as? Bool ?? false
        self.isEdited       = document["isEdited"] as? Bool ?? false
        self.isUnsent       = document["isUnsent"] as? Bool ?? false
    }

    var toMap: [String: Any] {
        [
            "conversationID": conversationID,
            "senderID":       senderID,
            "senderName":     senderName,
            "text":           text,
            "date":           Timestamp(date: date),
            "isRead":         isRead,
            "isEdited":       isEdited,
            "isUnsent":       isUnsent
        ]
    }
}
