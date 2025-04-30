import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createUser(user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"])
        }
        try db.collection(Constants.Collections.users).document(userId).setData(from: user)
    }
    
    func fetchUsers(excluding excludedIDs: [String]) async throws -> [User] {
        let snapshot = try await db.collection(Constants.Collections.users).getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let user = try document.data(as: User.self)
                return excludedIDs.contains(user.id ?? "") ? nil : user
            } catch {
                print("Error decoding user \(document.documentID): \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func fetchUsers(withIDs ids: [String]) async throws -> [User] {
        var users: [User] = []
        for id in ids {
            let document = try await db.collection(Constants.Collections.users).document(id).getDocument()
            if let user = try? document.data(as: User.self) {
                users.append(user)
            }
        }
        return users
    }
    
    func fetchFriendIDs(userId: String) async throws -> [String] {
        let userRef = db.collection(Constants.Collections.users).document(userId)
        let query = db.collection(Constants.Collections.friendships)
            .whereField("userIds", arrayContains: userRef)
        
        let snapshot = try await query.getDocuments()
        var friendIDs = [String]()
        
        for doc in snapshot.documents {
            guard let refs = doc.data()["userIds"] as? [DocumentReference] else { continue }
            let ids = refs.map { $0.documentID }
            friendIDs += ids.filter { $0 != userId }
        }
        
        return friendIDs
    }
    
    func sendFriendRequest(to receiverID: String) async throws {
        guard let senderID = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authenticated"])
        }
        
        let requestData: [String: Any] = [
            "sender": db.collection("users").document(senderID),
            "receiver": db.collection("users").document(receiverID),
            "status": "pending"
        ]
        
        try await db.collection(Constants.Collections.friendRequests).addDocument(data: requestData)
    }
    
    func acceptFriendRequest(_ requestID: String) async throws {
        let requestRef = db.collection(Constants.Collections.friendRequests).document(requestID)
        try await requestRef.updateData(["status": "accepted"])
        
        guard let request = try? await requestRef.getDocument().data(as: FriendRequest.self) else {
            throw NSError(domain: "Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])
        }
        
        let friendshipData: [String: Any] = [
            "userIds": [
                request.sender,
                request.receiver
            ]
        ]
        
        try await db.collection(Constants.Collections.friendships).addDocument(data: friendshipData)
    }
}
