//
//  AuthenticationViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.08.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var profileEmail = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var memberSince = ""
    @Published var errorMessage: String?
    
    
    @Published var email = ""
    @Published var currentUser: User? // Firebase User object
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    private let sessionRepo: SessionRepositoryProtocol
    
    // INITIALIZER & DEINTIALIZER
    init(sessionRepo: SessionRepositoryProtocol) {
        self.sessionRepo = sessionRepo
        // Observe authentication state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.currentUser = user
            if let user = user {
                print("User is signed in: \(user.uid)")
                self?.fetchUserProfile(uid: user.uid)
            } else {
                print("User is signed out.")
            }
        }
    }
    
    deinit {
        // Remove the listener when no longer needed to prevent memory leaks
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // SIGNUP, SIGNIN & SIGNOUT
    func signUp() async {
        errorMessage = nil
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            // memberSince value
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let memberSinceDateString = dateFormatter.string(from: Date())
            
            // Save additional user data to Firestore
            let db = Firestore.firestore()
            try await db.collection("users").document(uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "phoneNumber": phoneNumber,
                "email": profileEmail,
                "memberSince": memberSinceDateString,
            ])
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signIn() async {
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("User signed in: \(result.user.email ?? "N/A")")
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            self.errorMessage = "Sign-in failed: \(error.localizedDescription)"
        }
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
    
    
    // FETCH USER PROFILE FROM FIRESTORE
    func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { (document, error) in
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
            // Security-sensitive operation requires recent login.
            guard let email = user.email else {
                errorMessage = "User email not found for re-authentication."
                return
            }
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            
            try await user.reauthenticate(with: credential)
            print("User re-authenticated successfully.")
            
            // Update password
            try await user.updatePassword(to: newPassword)
            print("Password updated successfully for \(user.email ?? "user").")
            
            self.password = ""
            
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
    
    
    // UPDATE USER DATA
    func updateUserProfileData() async {
        errorMessage = nil
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "No authenticated user to update profile for."
            return
        }
        
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(uid)
        
        let updates: [String: Any] = [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "phoneNumber": self.phoneNumber,
            "email": self.profileEmail // This updates the email in Firestore, not Auth
        ]
        
        do {
            try await userDocRef.updateData(updates)
            print("User profile data updated successfully in Firestore.")
        } catch {
            print("Error updating user profile data in Firestore: \(error.localizedDescription)")
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
        }
    }
    
    func checkConfirmPassword() -> Bool {
        return password == confirmPassword
    }
    func checkConfirmNewPassword() -> Bool {
        return newPassword == confirmNewPassword
    }
    
    
    // FAVORITES FUNCTIONS
    func addFavorite(_ mediaItem: MediaItem) {
        guard let uid = currentUser?.uid else { return }
        favorites.append(mediaItem)
        FavoritesManager.shared.saveFavorites(favorites, for: uid)
    }

    func removeFavorite(_ mediaItem: MediaItem) {
        guard let uid = currentUser?.uid else { return }
        self.favorites.removeAll { $0.id == mediaItem.id }
        FavoritesManager.shared.saveFavorites(favorites, for: uid)
    }

    func isFavorite(_ mediaItem: MediaItem) -> Bool {
        return self.favorites.contains { $0.id == mediaItem.id }
    
}

