//
//  AuthenticationRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import FirebaseAuth
import FirebaseFirestore
import Combine

struct UserProfile {
    var id: String {uid}
    let uid: String
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var profileEmail: String
    var memberSince: String
    init(uid: String, firstName: String, lastName: String, phoneNumber: String, profileEmail: String, memberSince: String) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.profileEmail = profileEmail
        self.memberSince = memberSince
    }
    init() {
        self.uid = ""
        self.firstName = ""
        self.lastName = ""
        self.phoneNumber = ""
        self.profileEmail = ""
        self.memberSince = ""
    }
}

protocol AuthenticationRepositoryProtocol {
    // Reactive authentication state
    var currentUserPublisher: AnyPublisher<User?, Never> { get }
    var currentUserId: String? { get }

    func signUp(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phoneNumber: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() throws
}


final class AuthenticationRepository: AuthenticationRepositoryProtocol {
    @Published private var currentUser: User?
    var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }
    var currentUserId: String? {
        currentUser?.uid
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
    
    func signUp(email: String, password: String, confirmPassword: String, firstName: String, lastName: String, phoneNumber: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        let memberSince = CustomDateFormatter.getCurrentDate()
        
        // Save additional user data to Firestore
        try await db.collection("users").document(uid).setData([
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "email": email,
            "memberSince": memberSince,
        ])
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        self.currentUser = result.user
        print("[Auth] Signed in as \(result.user.email ?? "unknown")")
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
        currentUser = nil // REFRESH VIEW
        print("User signed out successfully.")
    }
}
