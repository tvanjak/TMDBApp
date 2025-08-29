//
//  AuthenticationViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.08.2025..
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var errorMessage: String?
    
    @Published var currentUser: User? // Firebase User object
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    @Published var favorites: [Movie] = []
    private let defaults = UserDefaults.standard

    // INITIALIZER & DEINTIALIZER
    init() {
        // Observe authentication state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.currentUser = user
            if let user = user {
                print("User is signed in: \(user.uid)")
                // Optionally fetch their full profile data here if needed on app launch
                self?.fetchUserProfile(uid: user.uid)
                self?.favorites = FavoritesManager.shared.loadFavorites(for: user.uid)
            } else {
                print("User is signed out.")
                self?.favorites = []
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

            // Save additional user data to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "phoneNumber": phoneNumber,
                "email": email
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    self.errorMessage = "Failed to save user data."
                } else {
                    print("User data successfully written!")
                    // User is signed in and data is saved. Navigate to main app.
                }
            }
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
        }
    }
    
    func signIn() async {
        errorMessage = nil
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // User is successfully signed in.
            // Optionally fetch profile data from Firestore here if needed immediately.
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
                print("Fetched user profile: \(data ?? [:])")
            } else {
                print("Document does not exist or error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    
    // FAVORITES FUNCTIONS
    
    func addFavorite(_ movie: Movie) {
        guard let uid = currentUser?.uid else { return }
        self.favorites.append(movie)
        FavoritesManager.shared.saveFavorites(favorites, for: uid)
    }

    func removeFavorite(_ movie: Movie) {
        guard let uid = currentUser?.uid else { return }
        self.favorites.removeAll { $0.id == movie.id }
        FavoritesManager.shared.saveFavorites(favorites, for: uid)
    }

    func isFavorite(_ movie: Movie) -> Bool {
        return self.favorites.contains { $0.id == movie.id }
    }
    
    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFavorite(movie)
        } else {
            addFavorite(movie)
        }
    }
}

