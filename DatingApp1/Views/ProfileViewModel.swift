import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    
    private let userId: String
    
    var isCurrentUser: Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        return userId == currentUserId
    }
    
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchUser() async {
        do {
            let users = try await FirestoreService.shared.fetchUsers(withIDs: [userId])
            user = users.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
