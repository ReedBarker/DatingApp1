import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var swipedUserIDs = [String]()
    
    func fetchUsers() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let friendIDs = try await FirestoreService.shared.fetchFriendIDs(userId: currentUserId)
            let excludedIDs = [currentUserId] + friendIDs + swipedUserIDs
            let fetched = try await FirestoreService.shared.fetchUsers(excluding: excludedIDs)
            users = fetched
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addSwipedUser(_ userId: String) {
        swipedUserIDs.append(userId)
    }
}
