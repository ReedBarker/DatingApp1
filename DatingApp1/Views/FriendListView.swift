import SwiftUI

struct FriendListView: View {
    @StateObject private var vm = FriendsViewModel()
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView()
                } else if !vm.friends.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(vm.friends) { friend in
                                FriendView(friend: friend)
                                    .frame(minWidth: 150, minHeight: 150)
                            }
                        }
                        .padding()
                    }
                } else {
                    Text("No friends yet")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Friends")
            .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK", role: .cancel) { vm.errorMessage = nil }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
        .task { await vm.fetchFriends() }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
