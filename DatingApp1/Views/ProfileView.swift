import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: userId))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.isCurrentUser {
                    UserProfileIconsView()
                } else {
                    FriendProfileIconsView()
                }
                
                ProfilePictureView(urlString: viewModel.user?.profilePicUrl ?? "")
                    .frame(width: 200, height: 200)
                
                UserInfoView(username: viewModel.user?.username ?? "",
                           bio: viewModel.user?.bio ?? "")
                
                ImageGridView(urls: viewModel.user?.imageUrls ?? [], columns: 3)
            }
            .padding()
        }
        .navigationTitle(viewModel.isCurrentUser ? "My Profile" : viewModel.user?.username ?? "Profile")
        .onAppear {
            Task { await viewModel.fetchUser() }
        }
    }
}
#Preview {
    ProfileView(userId: "")
}
