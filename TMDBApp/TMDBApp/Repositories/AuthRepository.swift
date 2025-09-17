//
//  AuthRepository.swift
//  TMDBApp
//
//  Created by Assistant on 17.09.2025.
//

import SwiftUI
import FirebaseAuth

protocol AuthRepositoryProtocol {
    var currentUser: User? { get }
    func addAuthStateChangeListener(_ listener: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle
    func removeAuthStateChangeListener(_ handle: AuthStateDidChangeListenerHandle)
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() throws
}

final class AuthRepository: AuthRepositoryProtocol {
    private let auth = Auth.auth()

    var currentUser: User? { auth.currentUser }

    func addAuthStateChangeListener(_ listener: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            listener(user)
        }
    }

    func removeAuthStateChangeListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }

    func signUp(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user
    }

    func signIn(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user
    }

    func signOut() throws {
        try auth.signOut()
    }
}


