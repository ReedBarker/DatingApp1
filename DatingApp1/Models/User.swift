import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String
    var bio: String
    var profilePicUrl: String
    var imageUrls: [String]
    var preferences: Preferences

    struct Preferences: Codable {
        var darkMode: Bool
    }
}
