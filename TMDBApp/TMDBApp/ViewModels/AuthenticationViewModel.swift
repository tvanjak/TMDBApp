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
    private var sessionManager: any SessionManagerProtocol
    @Published private(set) var currentUser: User?
    
    init(sessionManager: any SessionManagerProtocol) {
        self.sessionManager = sessionManager
        self.currentUser = sessionManager.currentUser
        
        // Keep currentUser in sync
        sessionManager.currentUserPublisher
            .assign(to: &$currentUser)
    }
    
    var email: Binding<String> {
        Binding(
            get: { self.sessionManager.email },
            set: { self.sessionManager.email = $0 }
        )
    }
    
    var firstName: Binding<String> {
        Binding(
            get: { self.sessionManager.firstName },
            set: { self.sessionManager.firstName = $0 }
        )
    }
    
    var lastName: Binding<String> {
        Binding(
            get: { self.sessionManager.lastName },
            set: { self.sessionManager.lastName = $0 }
        )
    }
    
    var phoneNumber: Binding<String> {
        Binding(
            get: { self.sessionManager.phoneNumber },
            set: { self.sessionManager.phoneNumber = $0 }
        )
    }
    
    var password: Binding<String> {
        Binding(
            get: { self.sessionManager.password },
            set: { self.sessionManager.password = $0 }
        )
    }
    
    var confirmPassword: Binding<String> {
        Binding(
            get: { self.sessionManager.confirmPassword },
            set: { self.sessionManager.confirmPassword = $0 }
        )
    }
    
    var errorMessage: Binding<String?> {
        Binding(
            get: { self.sessionManager.errorMessage },
            set: { self.sessionManager.errorMessage = $0 }
        )
    }
    

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
