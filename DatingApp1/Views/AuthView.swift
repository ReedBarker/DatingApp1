import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isSignUpMode = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUpMode ? "Create Account" : "Welcome Back")
                .font(.largeTitle.bold())
            
            VStack(spacing: 16) {
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                
                if isSignUpMode {
                    TextField("Username", text: $viewModel.username)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Button(action: handleAuth) {
                Text(isSignUpMode ? "Sign Up" : "Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(isSignUpMode ? "Already have an account? Sign In" : "Need an account? Sign Up") {
                isSignUpMode.toggle()
                viewModel.errorMessage = nil
            }
        }
        .padding()
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private func handleAuth() {
        Task {
            if isSignUpMode {
                await viewModel.signUp()
            } else {
                await viewModel.signIn()
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(viewModel: AuthViewModel())
    }
}
