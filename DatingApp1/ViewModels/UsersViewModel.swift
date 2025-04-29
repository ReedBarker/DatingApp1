//
//  UsersViewModel.swift
//  DatingApp1
//
//  Created by user268071 on 4/29/25.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.users = try await FirestoreService.shared.fetchUsers()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

