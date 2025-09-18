//
//  ProfileViewModel.swift
//  TMDBApp
//
//  Created by Assistant on 10.09.2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    private let sessionManager: SessionManager
    @Published private(set) var currentUser: User?
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.currentUser = sessionManager.currentUser
        
        // Keep currentUser in sync
        sessionManager.$currentUser
            .assign(to: &$currentUser)
    }
    
    @Published var isProfileLoaded = false
    
    // Profile
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
    
    var profileEmail: Binding<String> {
        Binding(
            get: { self.sessionManager.profileEmail },
            set: { self.sessionManager.profileEmail = $0 }
        )
    }
    
    var memberSince: Binding<String> {
        Binding(
            get: { self.sessionManager.memberSince },
            set: { _ in } // read-only, cannot modify
        )
    }
    
    // Password Change
    var currentPassword: Binding<String> {
        Binding(
            get: { self.sessionManager.currentPassword },
            set: { self.sessionManager.currentPassword = $0 }
        )
    }
    
    var newPassword: Binding<String> {
        Binding(
            get: { self.sessionManager.newPassword },
            set: { self.sessionManager.newPassword = $0 }
        )
    }
    
    var confirmNewPassword: Binding<String> {
        Binding(
            get: { self.sessionManager.confirmNewPassword },
            set: { self.sessionManager.confirmNewPassword = $0 }
        )
    }
    
    var errorMessage: Binding<String?> {
        Binding(
            get: { self.sessionManager.errorMessage },
            set: { self.sessionManager.errorMessage = $0 }
        )
    }
    
    
    // Actions
    func fetchUserProfile(uid: String) {
        sessionManager.fetchUserProfile(uid: uid) {
            // This closure runs after data is loaded -- need to fix it
            self.isProfileLoaded = true
        }
    }
    
    func updateUserProfileData() async {
        await sessionManager.updateUserProfileData()
    }
    
    func updateUserPassword() async {
        await sessionManager.updateUserPassword()
    }
    
    func checkConfirmNewPassword() -> Bool {
        sessionManager.checkConfirmNewPassword()
    }
    
    func signOut() {
        sessionManager.signOut()
    }
}
