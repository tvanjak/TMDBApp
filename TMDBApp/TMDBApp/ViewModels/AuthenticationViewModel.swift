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
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
//    @Published var memberSince = ""
    
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
}

