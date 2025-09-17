//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    enum ProfileSections: CaseIterable, Hashable {
        case details
        case reviews
        case password
    }
    @State private var selectedSection: ProfileSections = .details
    
    // variables that track user actions
    @State private var addPhoneNumber: Bool = false
    @State private var editMode: Bool = false
    @State private var wantToLogOut: Bool = false
    
    // variables for alerts
    @State private var showSaveAlert = false
    @State private var saveAlertMessage = ""
    @State private var showUpdateAlert = false
    @State private var updateAlertMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (spacing: AppTheme.Spacing.medium) {
                    ProfileHeader(profileViewModel: profileViewModel, selectedSection: $selectedSection, editMode: $editMode)
                    
                    SectionsBar(selectedSection: $selectedSection) { section in
                        switch section {
                        case .details: "Details"
                        case .reviews: "Reviews"
                        case .password: "Password"
                        }
                    }
                    
                    switch selectedSection {
                    case .details:
                        DetailsSection(profileViewModel: profileViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber, wantToLogOut: $wantToLogOut)
                    case .reviews:
                        ReviewsSection()
                    case .password:
                        PasswordSection(profileViewModel: profileViewModel)
                    }
                }
                .padding(AppTheme.Spacing.large)
            }
            
            if editMode {
                SaveUserDataButton(profileViewModel: profileViewModel, editMode: $editMode, saveAlertMessage: $saveAlertMessage, showSaveAlert: $showSaveAlert)
            }
            if selectedSection == .password {
                UpdatePasswordButton(profileViewModel: profileViewModel, updateAlertMessage: $updateAlertMessage, showUpdateAlert: $showUpdateAlert, selectedSection: $selectedSection)
            }
        }
        .alert("Log out?", isPresented: $wantToLogOut) {
            Button("Cancel") {
                wantToLogOut = false
            }
            Button("OK") {
                profileViewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to log out")
        }
        .alert("Profile Update", isPresented: $showSaveAlert) {
            Button("OK") { }
        } message: {
            Text(saveAlertMessage)
        }
        .alert("Password Update", isPresented: $showUpdateAlert) {
            Button("OK") { }
        } message: {
            Text(updateAlertMessage)
        }
    }
}



#Preview {
    let profileViewModel = ProfileViewModel(sessionManager: SessionManager(sessionRepo: SessionRepository()))
//    profileViewModel.firstName = "John"
//    profileViewModel.lastName = "Doe"
//    profileViewModel.profileEmail = "john.doe@example.com"
//    profileViewModel.phoneNumber = "+1234567890"
//    profileViewModel.memberSince = "24/04/2022"
    
    return ProfileView(profileViewModel: profileViewModel)
}
