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
    
    init(sessionRepo: SessionRepositoryProtocol) {
        self.sessionRepo = sessionRepo

        if let uid = sessionRepo.currentUserId {
            fetchUserProfile(uid: uid)
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
        
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found."
            return
        }
        
        if newPassword != confirmNewPassword {
            errorMessage = "New passwords do not match."
            return
        }
        
        if newPassword.count < 6 {
            errorMessage = "Password should be at least 6 characters."
            return
        }
        
        do {
            // Re-authenticate using current password
            guard let email = user.email else {
                errorMessage = "User email not found for re-authentication."
                return
            }
            
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            try await user.reauthenticate(with: credential)
            print("User re-authenticated successfully.")
            
            // Update password
            try await user.updatePassword(to: newPassword)
            print("Password updated successfully for \(user.email ?? "user").")
            
            // Clear sensitive fields
            self.currentPassword = ""
            self.newPassword = ""
            self.confirmNewPassword = ""
            
        } catch let error as NSError {
            print("Error updating password: \(error.localizedDescription)")
            if let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .requiresRecentLogin:
                    errorMessage = "Please sign in again to update your password."
                case .wrongPassword:
                    errorMessage = "The current password you entered is incorrect."
                case .weakPassword:
                    errorMessage = "The new password is too weak. Please choose a stronger one."
                default:
                    errorMessage = "Failed to update password: \(error.localizedDescription)"
                }
            } else {
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


