//
//  UserRepository.swift
//  TMDBApp
//
//  Created by Assistant on 17.09.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct UserProfile: Codable {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var memberSince: String
}

protocol UserRepositoryProtocol {
    func fetchUserProfile(uid: String) async throws -> UserProfile
    func createUserProfile(uid: String, profile: UserProfile) async throws
    func updateUserProfile(uid: String, changes: [String: Any]) async throws
    func updateUserPassword(currentPassword: String, newPassword: String) async throws
}

final class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()

    func fetchUserProfile(uid: String) async throws -> UserProfile {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        guard let data = snapshot.data() else {
            throw NSError(domain: "UserRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])
        }
        let profile = UserProfile(
            firstName: data["firstName"] as? String ?? "",
            lastName: data["lastName"] as? String ?? "",
            phoneNumber: data["phoneNumber"] as? String ?? "",
            email: data["email"] as? String ?? "",
            memberSince: data["memberSince"] as? String ?? ""
        )
        return profile
    }

    func createUserProfile(uid: String, profile: UserProfile) async throws {
        try await db.collection("users").document(uid).setData([
            "firstName": profile.firstName,
            "lastName": profile.lastName,
            "phoneNumber": profile.phoneNumber,
            "email": profile.email,
            "memberSince": profile.memberSince
        ])
    }

    func updateUserProfile(uid: String, changes: [String : Any]) async throws {
        try await db.collection("users").document(uid).updateData(changes)
    }

    func updateUserPassword(currentPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: "UserRepository", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user"])
        }
        try await user.reload()
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        try await user.reauthenticate(with: credential)
        try await user.updatePassword(to: newPassword)
    }
}


