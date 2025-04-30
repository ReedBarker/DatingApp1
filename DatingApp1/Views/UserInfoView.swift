import SwiftUI

struct UserInfoView: View {
    let username: String
    let bio: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(username)
                .font(.title.bold())

            Text(bio)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(
            username: "Jane Doe",
            bio: "Loves hiking & photography. Passionate about outdoor adventures and capturing beautiful moments in nature."
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
