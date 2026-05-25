import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showSuccessToast = false

    private let authRepo: AuthRepositoryProtocol

    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }

    func loadUser(from appState: AppState) {
        if let user = appState.currentUser {
            self.displayName = user.displayName
        }
    }

    func saveChanges(appState: AppState) async {
        let name = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            try await authRepo.updateDisplayName(name)
            
            appState.currentUser?.displayName = name
            showSuccessToast = true
            
            Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                await MainActor.run {
                    self.showSuccessToast = false
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        try? authRepo.signOut()
    }
}
