//
//  ProfileRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 21.09.2025..
//

import FirebaseAuth
import FirebaseFirestore
import Combine

protocol ProfileRepositoryProtocol {
    var currentUserPublisher: AnyPublisher<User?, Never> { get }

    func fetchUserProfile(uid: String) async throws -> UserProfile
    func updateUserProfileData(profile: UserProfile) async throws

    func updateUserPassword(current: String, new: String, confirm: String) async throws
    
    func signOut() throws
}

final class ProfileRepository: ProfileRepositoryProtocol {
    @Published private var currentUser: User?
    var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    
    private let db: Firestore
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init(db: Firestore = Firestore.firestore()) {
        self.db = db
        self.authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func fetchUserProfile(uid: String) async throws -> UserProfile {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "SessionManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])
        }
        return UserProfile(
            uid: uid,
            firstName: data["firstName"] as? String ?? "",
            lastName: data["lastName"] as? String ?? "",
            phoneNumber: data["phoneNumber"] as? String ?? "",
            profileEmail: data["email"] as? String ?? "",
            memberSince: data["memberSince"] as? String ?? ""
        )
    }
    
    func updateUserProfileData(profile: UserProfile) async throws {
        let userDocRef = db.collection("users").document(profile.uid)
        
        let updates: [String: Any] = [
            "firstName": profile.firstName,
            "lastName": profile.lastName,
            "phoneNumber": profile.phoneNumber,
            "email": profile.profileEmail // Firestore only; does not update Auth email
        ]
        
        try await userDocRef.updateData(updates)
        print("User profile data updated successfully in Firestore.")
    }
    
    func updateUserPassword(current: String, new: String, confirm: String) async throws {
        guard !current.isEmpty else {
            throw NSError(domain: "SessionManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Enter your current password."])
        }
        guard new == confirm else {
            throw NSError(domain: "SessionManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "New passwords do not match."])
        }
        guard new.count >= 6 else {
            throw NSError(domain: "SessionManager", code: 400, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters."])
        }

        guard let user = Auth.auth().currentUser, let email = user.email else {
            throw NSError(domain: "SessionManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found."])
        }

        try await user.reload()
        let credential = EmailAuthProvider.credential(withEmail: email, password: current)
        try await user.reauthenticate(with: credential)
        try await user.updatePassword(to: new)

        print("[Profile] Password updated successfully")
    }

    func signOut() throws{
        try Auth.auth().signOut()
        currentUser = nil // REFRESH VIEW
        print("User signed out successfully.")
    }
}
