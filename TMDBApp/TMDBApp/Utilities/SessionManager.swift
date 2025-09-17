//
//  SessionManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

//@MainActor
//protocol SessionManagerProtocol: ObservableObject {
//    // Auth/Login/Signup
//    var email: String { get set }
//    var password: String { get set }
//    var confirmPassword: String { get set }
//    var currentUser: User? { get }
//    var errorMessage: String? { get set }
//    func signUp() async
//    func signIn() async
//    func signOut()
//    func checkConfirmPassword() -> Bool
//
//    // Shared profile fields
//    var firstName: String { get set }
//    var lastName: String { get set }
//    var phoneNumber: String { get set }
//
//    // Profile-only fields
//    var profileEmail: String { get set }
//    var memberSince: String { get }
//    func fetchUserProfile(uid: String)
//    func updateUserProfileData() async
//
//    // Password change
//    var currentPassword: String { get set }
//    var newPassword: String { get set }
//    var confirmNewPassword: String { get set }
//    func updateUserPassword() async
//    func checkConfirmNewPassword() -> Bool
//}

@MainActor
final class SessionManager: ObservableObject/*, SessionManagerProtocol*/ {
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
        let passwordLength = password.count
        print("[Auth] signIn() called with email=\(trimmedEmail), passwordLength=\(passwordLength)")
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            print("[Auth][Error] Missing credentials: emailEmpty=\(trimmedEmail.isEmpty), passwordEmpty=\(password.isEmpty)")
            return
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: trimmedEmail, password: password)
            currentUser = result.user // REFRESH VIEW -- CHANGE HERE
            print("[Auth] User signed in: \(result.user.email ?? "N/A") (uid=\(result.user.uid))")
        } catch {
            let ns = error as NSError
            let code = AuthErrorCode(rawValue: ns.code)
            print("[Auth][Error] signIn failed code=\(code?.rawValue ?? ns.code) (\(String(describing: code))) message=\(ns.localizedDescription)")
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
                errorMessage = "Sign-in failed: \(ns.localizedDescription)"
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil // REFRESH VIEW -- CHANGE HERE
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Sign out failed: \(error.localizedDescription)"
        }
    }
    
    
    // CONFIRM PASSWORD
    func checkConfirmPassword() -> Bool {
        return password == confirmPassword
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
}
