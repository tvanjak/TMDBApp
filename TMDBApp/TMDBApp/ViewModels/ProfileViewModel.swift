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

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    // User profile fields
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

    var profileEmail: String {
        get { sessionManager.profileEmail }
        set { sessionManager.profileEmail = newValue }
    }

    var memberSince: String {
        get { sessionManager.memberSince }
    }

    // Password change fields
    var currentPassword: String {
        get { sessionManager.currentPassword }
        set { sessionManager.currentPassword = newValue }
    }

    var newPassword: String {
        get { sessionManager.newPassword }
        set { sessionManager.newPassword = newValue }
    }

    var confirmNewPassword: String {
        get { sessionManager.confirmNewPassword }
        set { sessionManager.confirmNewPassword = newValue }
    }

    var errorMessage: String? {
        get { sessionManager.errorMessage }
        set { sessionManager.errorMessage = newValue }
    }

    var currentUser: User? {
        sessionManager.currentUser
    }

    // Actions
    func fetchUserProfile(uid: String) {
        sessionManager.fetchUserProfile(uid: uid)
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
