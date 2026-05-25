import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var currentUser: BubblUser?
}
