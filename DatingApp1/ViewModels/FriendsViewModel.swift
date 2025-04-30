import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published var friends: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFriends() async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            errorMessage = "Not authenticated"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let friendIDs = try await FirestoreService.shared.fetchFriendIDs(userId: currentUserId)
            friends = try await FirestoreService.shared.fetchUsers(withIDs: friendIDs)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
