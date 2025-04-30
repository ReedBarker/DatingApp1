import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var errorMessage: String?
    @Published var userSession: FirebaseAuth.User?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            self?.userSession = user
        }
    }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await createUserDocumentIfNeeded(userId: result.user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signUp() async {
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(
                id: result.user.uid,
                username: username,
                bio: "",
                profilePicUrl: "",
                imageUrls: [],
                preferences: User.Preferences(darkMode: false)
            )
            try await FirestoreService.shared.createUser(user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func createUserDocumentIfNeeded(userId: String) async {
        do {
            let document = try await Firestore.firestore().collection("users").document(userId).getDocument()
            guard !document.exists else { return }
            
            let user = User(
                id: userId,
                username: "User_\(userId.prefix(6))",
                bio: "",
                profilePicUrl: "",
                imageUrls: [],
                preferences: User.Preferences(darkMode: false)
            )
            try await FirestoreService.shared.createUser(user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
