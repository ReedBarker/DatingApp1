import Foundation
import FirebaseFirestore

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await FirestoreService.shared.fetchUsers()
            users = fetched
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

