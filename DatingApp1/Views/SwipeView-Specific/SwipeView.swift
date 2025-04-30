import SwiftUI

struct SwipeView: View {
    @StateObject private var vm = UsersViewModel()
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var isDragging = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)

                switch true {
                case vm.isLoading:
                    ProgressView()

                case vm.errorMessage != nil:
                    ErrorView(error: vm.errorMessage!) {
                        Task { await vm.fetchUsers() }
                    }

                case currentIndex < vm.users.count:
                    UserCardView(
                        user: vm.users[currentIndex],
                        geo: geo,
                        dragOffset: $dragOffset,
                        cardRotation: $cardRotation,
                        isDragging: $isDragging
                    )
                    .transition(.slide)
                    .animation(.interactiveSpring(), value: dragOffset)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 10)
                            .onChanged { value in
                                let dx = value.translation.width
                                let dy = value.translation.height
                                if abs(dx) > abs(dy) * 3 && abs(dx) > 20 {
                                    isDragging = true
                                    dragOffset.width = dx
                                    cardRotation = Double(dx / 20)
                                }
                            }
                            .onEnded { value in
                                let dx = value.translation.width
                                let dy = value.translation.height
                                let threshold = geo.size.width * 0.4
                                if abs(dx) > abs(dy) * 3 && abs(dx) > threshold {
                                    let direction: SwipeDirection = dx > 0 ? .right : .left
                                    swipeCard(direction: direction)
                                } else {
                                    withAnimation(.interactiveSpring()) {
                                        resetCardPosition()
                                    }
                                }
                            }
                    )
                    .zIndex(1)

                    if currentIndex + 1 < vm.users.count {
                        UserCardView(
                            user: vm.users[currentIndex + 1],
                            geo: geo,
                            dragOffset: .constant(.zero),
                            cardRotation: .constant(0),
                            isDragging: .constant(false)
                        )
                        .zIndex(0)
                        .scaleEffect(0.95)
                        .opacity(0.8)
                    }

                default:
                    EmptyStateView()
                }
            }
            .overlay(alignment: .topTrailing) {
                // Temporary logout button
                Button {
                    authViewModel.signOut()
                } label: {
                    Image(systemName: "power")
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding(.top, 50)
                .padding(.trailing, 20)
            }
            .overlay(bottomButtons, alignment: .bottom)
            .onAppear { Task { await vm.fetchUsers() } }
        }
    }

    private var bottomButtons: some View {
        HStack {
            SwipeButton(systemName: "xmark", color: .red) {
                swipeCard(direction: .left)
            }
            Spacer()
            SwipeButton(systemName: "heart.fill", color: .green) {
                swipeCard(direction: .right)
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 30)
    }

    private func swipeCard(direction: SwipeDirection) {
        let swipedUserId = vm.users[currentIndex].id ?? ""
        vm.addSwipedUser(swipedUserId)

        withAnimation(.easeInOut(duration: 0.3)) {
            dragOffset.width = direction == .right ? 500 : -500
            cardRotation = direction == .right ? 15 : -15
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            resetCardPosition()
        }

        if direction == .right {
            Task {
                try? await FirestoreService.shared.sendFriendRequest(to: swipedUserId)
            }
        }
    }

    private func resetCardPosition() {
        dragOffset = .zero
        cardRotation = 0
        isDragging = false
    }
}

// MARK: - Supporting Views & Types
struct UserCardView: View {
    let user: User
    let geo: GeometryProxy
    @Binding var dragOffset: CGSize
    @Binding var cardRotation: Double
    @Binding var isDragging: Bool

    var body: some View {
        UserView(user: user)
            .frame(width: geo.size.width)
            .background(Color(.systemBackground))
            .offset(x: dragOffset.width, y: dragOffset.height)
            .rotationEffect(.degrees(cardRotation))
            .scaleEffect(isDragging ? 1.02 : 1.0)
    }
}

struct SwipeButton: View {
    let systemName: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(.white)
                .padding(20)
                .background(color)
                .clipShape(Circle())
                .shadow(radius: 8)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct ErrorView: View {
    let error: String
    let retryHandler: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Error: \(error)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)

            Button("Retry", action: retryHandler)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No more users to show")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

enum SwipeDirection {
    case left, right
}

// MARK: - Preview
struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView()
            .environmentObject(AuthViewModel())
    }
}
