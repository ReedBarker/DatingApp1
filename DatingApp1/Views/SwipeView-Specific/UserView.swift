import SwiftUI

struct UserView: View {
    let user: User
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ProfilePictureView(urlString: user.profilePicUrl ?? "")
                UserInfoView(username: user.username, bio: user.bio ?? "")
                ImageGridView(urls: user.imageUrls ?? [""])
            }
            .padding()
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User(
            id: "1",
            username: "Jane Doe",
            bio: "Loves hiking & photography. Passionate about outdoor adventures and capturing beautiful moments in nature.",
            profilePicUrl: "https://example.com/profile.jpg",
            imageUrls: Array(repeating: "https://example.com/photo.jpg", count: 6),
            preferences: .init(darkMode: false)
        ))
    }
}
