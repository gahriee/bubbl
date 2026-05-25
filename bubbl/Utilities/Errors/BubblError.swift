import Foundation

enum BubblError: LocalizedError {
    case userNotFound
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found in the database."
        case .custom(let message):
            return message
        }
    }
}
