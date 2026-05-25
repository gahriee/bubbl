import Foundation

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authRepo: AuthRepositoryProtocol

    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }

    func register(email: String, password: String, displayName: String) async -> BubblUser? {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            return try await authRepo.register(email: email, password: password, displayName: displayName)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func login(email: String, password: String) async -> BubblUser? {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do {
            return try await authRepo.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    func signOut() {
        try? authRepo.signOut()
    }
}
