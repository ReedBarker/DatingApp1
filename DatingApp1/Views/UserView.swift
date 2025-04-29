import SwiftUI

struct UserView: View {
    @StateObject private var vm = UsersViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if vm.isLoading {
                    ProgressView()
                }
                else if let error = vm.errorMessage {
                    VStack(spacing: 8) {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await vm.fetchUsers() }
                        }
                    }
                }
                else {
                    ScrollView {
                        // <-- here’s our extracted grid
                        ImageGridView(urls: vm.users.flatMap { $0.imageUrls })
                            .padding()
                    }
                }
            }
            .task { await vm.fetchUsers() }
        }
    }
}

struct UserImagesView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

