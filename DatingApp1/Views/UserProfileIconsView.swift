
import SwiftUI

struct UserProfileIconsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                authViewModel.signOut()
            } label: {
                Image(systemName: "power")
                    .font(.title)
                    .padding()
            }
        }
    }
}
