//
//  SessionManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
protocol SessionManagerProtocol: ObservableObject {
    // Auth/Login/Signup
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    var currentUser: User? { get }
    var currentUserPublisher: Published<User?>.Publisher { get }
    var errorMessage: String? { get set }
    func signUp() async
    func signIn() async
    func signOut()
    func checkConfirmPassword() -> Bool

    // Shared profile fields
    var firstName: String { get set }
    var lastName: String { get set }
    var phoneNumber: String { get set }

    // Profile-only fields
    var profileEmail: String { get set }
    var memberSince: String { get }
    func fetchUserProfile(uid: String, completion: (() -> Void)?)
    func updateUserProfileData() async

    // Password change
    var currentPassword: String { get set }
    var newPassword: String { get set }
    var confirmNewPassword: String { get set }
    func updateUserPassword() async
    func checkConfirmNewPassword() -> Bool
}

@MainActor
final class SessionManager: ObservableObject, SessionManagerProtocol {
    // Exclusive to login/signup
    @Published var password = ""
    @Published var confirmPassword = ""
    
    // Shared between user profile and login/signup
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    
    // User profile fields
    @Published var profileEmail = ""
    @Published var memberSince = ""
    
    // Password change fields
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    
    @Published var errorMessage: String?
    
    @Published var email = ""
    @Published public var currentUser: User? // Firebase User object
    var currentUserPublisher: Published<User?>.Publisher { $currentUser }
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    private let sessionRepo: SessionRepositoryProtocol
    
    // INITIALIZER & DEINTIALIZER
    init(sessionRepo: SessionRepositoryProtocol) {
        self.sessionRepo = sessionRepo
        // Observe authentication state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            self.currentUser = user
            if let user = user {
                self.fetchUserProfile(uid: user.uid)
                print("User is signed in: \(user.uid)")
            } else {
                // Clear fields on sign-out
                self.firstName = ""
                self.lastName = ""
                self.phoneNumber = ""
                self.profileEmail = ""
                self.memberSince = ""
                print("User is signed out.")
            }
        }
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // AUTHENTICATION VM FUNCTIONS
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
                "email": email,
                "memberSince": memberSinceDateString,
            ])
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signIn() async {
        errorMessage = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard validateCredentials(email: trimmedEmail, password: password) else { return }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: trimmedEmail, password: password)
            currentUser = result.user
            print("[Auth] Signed in as \(result.user.email ?? "unknown")")
        } catch {
            handleSignInError(error as NSError)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil // REFRESH VIEW
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Sign out failed: \(error.localizedDescription)"
        }
    }
    // ------------------------------------------------------------------
    
    
    // AUTHENTICATION VM FUNCTIONS
    func fetchUserProfile(uid: String, completion: (() -> Void)? = nil) {
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
            completion?()
        }
    }
    
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
    
    func updateUserPassword() async {
        errorMessage = nil
        
        guard validatePasswords() else { return }
        guard let user = Auth.auth().currentUser else {
            errorMessage = "No authenticated user found."
            return
        }
        guard let email = user.email else {
            errorMessage = "User email not found."
            return
        }
        
        do {
            // Always refresh state
            try await user.reload()
            // Re-authenticate
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            try await user.reauthenticate(with: credential)
            // Update password
            try await user.updatePassword(to: newPassword)
            // Reset fields
            currentPassword = ""
            newPassword = ""
            confirmNewPassword = ""
            
            print("[Profile] Password updated successfully")
        } catch {
            handlePasswordError(error as NSError)
        }
    }
    // ------------------------------------------------------------------

    
    // CONFIRM PASSWORD
    func checkConfirmPassword() -> Bool {
        return password == confirmPassword
    }
    // CONFIRM NEW PASSWORD
    func checkConfirmNewPassword() -> Bool {
        return newPassword == confirmNewPassword
    }
    
    
    // SIGN IN HELPER FUNCTIONS
    private func validateCredentials(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return false
        }
        return true
    }

    private func handleSignInError(_ error: NSError) {
        let code = AuthErrorCode(rawValue: error.code)
        switch code {
        case .wrongPassword, .invalidCredential:
            errorMessage = "Incorrect credentials."
        case .userDisabled:
            errorMessage = "This account has been disabled."
        case .userNotFound:
            errorMessage = "No user found for this email."
        case .tooManyRequests:
            errorMessage = "Too many attempts. Please try again later."
        case .invalidEmail:
            errorMessage = "Invalid email format."
        default:
            errorMessage = "Sign-in failed: \(error.localizedDescription)"
        }
        print("[Auth][Error] \(errorMessage ?? "unknown")")
    }
    // ------------------------------------------------------------------

    
    // CHANGE PASSWORD HELPER FUNCTIONS
    private func validatePasswords() -> Bool {
        guard !currentPassword.isEmpty else {
            errorMessage = "Enter your current password."
            return false
        }
        guard newPassword == confirmNewPassword else {
            errorMessage = "New passwords do not match."
            return false
        }
        guard newPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }

    private func handlePasswordError(_ error: NSError) {
        let code = AuthErrorCode(rawValue: error.code)
        switch code {
        case .wrongPassword, .invalidCredential:
            errorMessage = "Incorrect current password."
        case .weakPassword:
            errorMessage = "The new password is too weak."
        case .requiresRecentLogin:
            errorMessage = "Please sign in again to update your password."
        case .tooManyRequests:
            errorMessage = "Too many attempts. Try again later."
        default:
            errorMessage = "Error: \(error.localizedDescription)"
        }
        print("[Profile][Error] \(errorMessage ?? "unknown")")
    }
    // ------------------------------------------------------------------
}
