import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            if authViewModel.userSession != nil {
                TabView {
                    SwipeView()
                        .tabItem {
                            Label("Swipe", systemImage: "person.2")
                        }
                    
                    FriendListView()
                        .tabItem {
                            Label("Friends", systemImage: "person.3.fill")
                        }
                }
                .navigationBarHidden(true)
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
