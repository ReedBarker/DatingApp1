import SwiftUI

struct FriendView: View {
    let friend: User
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ProfilePictureView(urlString: friend.profilePicUrl ?? "")
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Text(friend.username)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            ImageGridMiniView(urls: friend.imageUrls ?? [])
                .frame(height: 80)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(friend: User(
            id: "1",
            username: "John Doe",
            bio: nil,
            profilePicUrl: "https://picsum.photos/100",
            imageUrls: [
                "https://picsum.photos/200",
                "https://picsum.photos/201",
                "https://picsum.photos/202",
                "https://picsum.photos/203"
            ],
            preferences: nil
        ))
        .previewLayout(.sizeThatFits)
        .frame(width: 150, height: 150)
    }
}

