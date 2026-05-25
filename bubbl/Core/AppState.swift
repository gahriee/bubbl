import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var currentUser: BubblUser?

    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
        container.authRepo.observeAuthState { [weak self] user in
            self?.currentUser = user
        }
    }
}
