import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            if authViewModel.userSession != nil {
                SwipeView()
                    .environmentObject(authViewModel)
                    .navigationBarHidden(true)
            } else {
                AuthView(viewModel: authViewModel)
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
