//
//  FirestoreService.swift
//  DatingApp1
//
//  Created by user268071 on 4/29/25.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchUsers() async throws -> [User] {
        let snapshot = try await db.collection(Constants.Collections.users).getDocuments()
        return try snapshot.documents.compactMap {
            try $0.data(as: User.self)
        }
    }
}

