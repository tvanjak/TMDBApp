//
//  ProfileViewModel.swift
//  TMDBApp
//
//  Created by Assistant on 10.09.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class ProfileViewModel: ObservableObject {
    // User profile fields
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var profileEmail = ""
    @Published var memberSince = ""
    
    // Password change fields
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    
    @Published var errorMessage: String?
    
    private let sessionRepo: SessionRepositoryProtocol
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init(sessionRepo: SessionRepositoryProtocol) {
        self.sessionRepo = sessionRepo
        // Initial fetch if already signed in
        if let uid = sessionRepo.currentUserId {
            fetchUserProfile(uid: uid)
        }
        // Listen for auth changes to fetch after sign-in
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                self.fetchUserProfile(uid: user.uid)
            } else {
                // Clear fields on sign-out
                self.firstName = ""
                self.lastName = ""
                self.phoneNumber = ""
                self.profileEmail = ""
                self.memberSince = ""
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // FETCH USER PROFILE FROM FIRESTORE
    func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? ""
                self.lastName = data?["lastName"] as? String ?? ""
                self.phoneNumber = data?["phoneNumber"] as? String ?? ""
                self.profileEmail = data?["email"] as? String ?? ""
                self.memberSince = data?["memberSince"] as? String ?? ""
                print("Fetched user profile: \(data ?? [:])")
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    // UPDATE USER DATA
    func updateUserProfileData() async {
        errorMessage = nil
        guard let uid = sessionRepo.currentUserId else {
            errorMessage = "No authenticated user to update profile for."
            return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(uid)
        
        let updates: [String: Any] = [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "phoneNumber": self.phoneNumber,
            "email": self.profileEmail // Firestore only; does not update Auth email
        ]
        
        do {
            try await userDocRef.updateData(updates)
            print("User profile data updated successfully in Firestore.")
        } catch {
            print("Error updating user profile data in Firestore: \(error.localizedDescription)")
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
        }
    }
    
    // UPDATE USER PASSWORD
    func updateUserPassword() async {
        errorMessage = nil
        print("[Profile] updateUserPassword() called newLen=\(newPassword.count) confirmLen=\(confirmNewPassword.count) currentLen=\(currentPassword.count)")
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found."
            print("[Profile][Error] No currentUser")
            return
        }
        
        guard !currentPassword.isEmpty else {
            errorMessage = "Enter your current password to re-authenticate."
            print("[Profile][Error] currentPassword empty")
            return
        }
        
        if newPassword != confirmNewPassword {
            errorMessage = "New passwords do not match."
            print("[Profile][Error] new!=confirm")
            return
        }
        
        if newPassword.count < 6 {
            errorMessage = "Password should be at least 6 characters."
            print("[Profile][Error] new too short")
            return
        }
        
        // Ensure we have freshest auth state and reauthenticate first
        do {
            try await user.reload()
            guard let email = user.email else {
                errorMessage = "User email not found for re-authentication."
                print("[Profile][Error] user.email nil")
                return
            }
            print("[Profile] Reauth with email=\(email), currentLen=\(currentPassword.count)")
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            try await user.reauthenticate(with: credential)
            print("[Profile] Re-authenticated ok")
        } catch let error as NSError {
            let code = AuthErrorCode(rawValue: error.code)
            print("[Profile][Error] reauthenticate failed code=\(code?.rawValue ?? error.code) (\(String(describing: code))) message=\(error.localizedDescription)")
            switch code {
            case .wrongPassword, .invalidCredential:
                errorMessage = "Incorrect credentials."
            case .requiresRecentLogin:
                errorMessage = "Please sign in again to update your password."
            case .tooManyRequests:
                errorMessage = "Too many attempts. Please try again later."
            default:
                errorMessage = "Re-authentication failed: \(error.localizedDescription)"
            }
            return
        }

        // Then attempt to update the password
        do {
            try await user.updatePassword(to: newPassword)
            print("[Profile] Password updated ok for \(user.email ?? "user")")
            self.currentPassword = ""
            self.newPassword = ""
            self.confirmNewPassword = ""
        } catch let error as NSError {
            let code = AuthErrorCode(rawValue: error.code)
            print("[Profile][Error] updatePassword failed code=\(code?.rawValue ?? error.code) (\(String(describing: code))) message=\(error.localizedDescription)")
            switch code {
            case .weakPassword:
                errorMessage = "The new password is too weak. Please choose a stronger one."
            case .requiresRecentLogin:
                errorMessage = "Please sign in again to update your password."
            default:
                errorMessage = "Failed to update password: \(error.localizedDescription)"
            }
        }
    }
    
    func checkConfirmNewPassword() -> Bool {
        return newPassword == confirmNewPassword
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Sign out failed: \(error.localizedDescription)"
        }
    }
}


