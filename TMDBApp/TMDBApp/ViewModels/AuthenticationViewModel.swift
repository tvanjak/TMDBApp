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
    @Published var errorMessage: String?

    @ObservedObject private var sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    // Forward computed bindings
    var email: String {
        get { sessionManager.email }
        set { sessionManager.email = newValue }
    }

    var password: String {
        get { sessionManager.password }
        set { sessionManager.password = newValue }
    }

    var confirmPassword: String {
        get { sessionManager.confirmPassword }
        set { sessionManager.confirmPassword = newValue }
    }

    var firstName: String {
        get { sessionManager.firstName }
        set { sessionManager.firstName = newValue }
    }

    var lastName: String {
        get { sessionManager.lastName }
        set { sessionManager.lastName = newValue }
    }

    var phoneNumber: String {
        get { sessionManager.phoneNumber }
        set { sessionManager.phoneNumber = newValue }
    }

    var currentUser: User? { sessionManager.currentUser }

    // Actions
    func signUp() async {
        await sessionManager.signUp()
    }
    
    func signIn() async {
        await sessionManager.signIn()
    }
    
    func signOut() {
        sessionManager.signOut()
    }
    
    func checkConfirmPassword() -> Bool {
        sessionManager.checkConfirmPassword()
    }
}
