import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthRepository: AuthRepositoryProtocol {
    private let auth = Auth.auth()
    private let db   = Firestore.firestore()

    var currentUser: BubblUser? {
        guard let user = auth.currentUser else { return nil }
        // Returned from cache; full profile loaded on login/register
        return BubblUser(id: user.uid, email: user.email ?? "", displayName: user.displayName ?? "")
    }

    func register(email: String, password: String, displayName: String) async throws -> BubblUser {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user   = BubblUser(id: result.user.uid, email: email, displayName: displayName)
        try await db.collection(Constants.users).document(user.id).setData(user.toMap)
        return user
    }

    func login(email: String, password: String) async throws -> BubblUser {
        let result = try await auth.signIn(withEmail: email, password: password)
        let snap   = try await db.collection(Constants.users).document(result.user.uid).getDocument()
        guard let data = snap.data(), let user = BubblUser(document: data, id: snap.documentID) else {
            throw BubblError.userNotFound
        }
        return user
    }

    func signOut() throws {
        try auth.signOut()
    }

    func observeAuthState(onChange: @escaping (BubblUser?) -> Void) {
        auth.addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let self = self, let firebaseUser = firebaseUser else { onChange(nil); return }
            Task {
                let snap = try? await self.db.collection(Constants.users)
                                             .document(firebaseUser.uid).getDocument()
                let user = snap.flatMap { BubblUser(document: $0.data() ?? [:], id: $0.documentID) }
                await MainActor.run { onChange(user) }
            }
        }
    }

    func findUser(byEmail email: String) async throws -> BubblUser? {
        let snapshot = try await db.collection(Constants.users)
            .whereField("email", isEqualTo: email)
            .getDocuments()
        
        guard let doc = snapshot.documents.first else {
            return nil
        }
        return BubblUser(document: doc.data(), id: doc.documentID)
    }

    func updateDisplayName(_ name: String) async throws {
        guard let user = auth.currentUser else { throw BubblError.userNotFound }
        let request = user.createProfileChangeRequest()
        request.displayName = name
        try await request.commitChanges()
        
        try await db.collection(Constants.users).document(user.uid).updateData(["displayName": name])
    }
}
