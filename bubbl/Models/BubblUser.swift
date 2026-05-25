import Foundation

struct BubblUser: Identifiable, Equatable {
    let id: String
    let email: String
    var displayName: String

    init(id: String, email: String, displayName: String) {
        self.id          = id
        self.email       = email
        self.displayName = displayName
    }

    init?(document: [String: Any], id: String) {
        guard
            let email       = document["email"]       as? String,
            let displayName = document["displayName"] as? String
        else { return nil }
        self.id          = id
        self.email       = email
        self.displayName = displayName
    }

    var toMap: [String: Any] {
        ["email": email, "displayName": displayName]
    }
}
