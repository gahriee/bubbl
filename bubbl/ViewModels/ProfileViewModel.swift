import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authRepo: AuthRepositoryProtocol

    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }

    func loadUser(from appState: AppState) {
        if let user = appState.currentUser {
            self.displayName = user.displayName
        }
    }

    func saveChanges() async {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            try await authRepo.updateDisplayName(name)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        try? authRepo.signOut()
    }
}
