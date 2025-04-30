import SwiftUI

struct FriendProfileIconsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
            }
            Spacer()
        }
    }
}
