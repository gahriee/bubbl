import Foundation

protocol AuthRepositoryProtocol {
    var currentUser: BubblUser? { get }
    func register(email: String, password: String, displayName: String) async throws -> BubblUser
    func login(email: String, password: String) async throws -> BubblUser
    func signOut() throws
    func observeAuthState(onChange: @escaping (BubblUser?) -> Void)
    func findUser(byEmail email: String) async throws -> BubblUser?
    func updateDisplayName(_ name: String) async throws
}
