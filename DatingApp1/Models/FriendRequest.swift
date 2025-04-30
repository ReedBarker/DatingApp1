import FirebaseFirestore

struct FriendRequest: Codable, Identifiable {
    @DocumentID var id: String?
    let sender: DocumentReference
    let receiver: DocumentReference
    var status: String
}
