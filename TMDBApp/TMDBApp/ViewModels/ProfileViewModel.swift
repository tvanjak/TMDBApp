//
//  ProfileViewModel.swift
//  TMDBApp
//
//  Created by Assistant on 10.09.2025.
//

import SwiftUI
import FirebaseAuth
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    private let profileRepository: ProfileRepositoryProtocol
//    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var currentUser: User?
    
    @Published var profile: UserProfile = UserProfile()

    @Published var errorMessage: String?
    @Published var isProfileLoaded = false
    
    // Password change form
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    
    init(profileRepository: ProfileRepositoryProtocol) {
        self.profileRepository = profileRepository
        profileRepository.currentUserPublisher
            .assign(to: &$currentUser)
    }
    
    // Actions
    func fetchUserProfileData() async {
        guard let uid = currentUser?.uid else {
            errorMessage = "No authenticated user."
            return
        }
        do {
            let fetched = try await profileRepository.fetchUserProfile(uid: uid)
            self.profile = fetched
            isProfileLoaded = true
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
    }
    
    func updateUserProfileData() async {
//        guard !profile.firstName.isEmpty || !profile.lastName.isEmpty else {
//            errorMessage = "Profile is incomplete."
//            return
//        }
        do {
            try await profileRepository.updateUserProfileData(profile: profile)
        } catch {
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
        }
    }
    
    func updateUserPassword() async {
        guard !currentPassword.isEmpty else {
            errorMessage = "Enter your current password."
            return
        }
        guard newPassword == confirmNewPassword else {
            errorMessage = "New passwords do not match."
            return
        }
        
        do {
            try await profileRepository.updateUserPassword(current: currentPassword, new: newPassword, confirm: confirmNewPassword)
            currentPassword = ""
            newPassword = ""
            confirmNewPassword = ""
        } catch {
            errorMessage = "Failed to update password: \(error.localizedDescription)"
        }
    }
    
    func signOut() {
        do {
            try profileRepository.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
