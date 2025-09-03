//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct ProfileHeader: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var selectedSection: ProfileView.ProfileSections
    @Binding var editMode: Bool
    
    var body: some View {
        HStack {
            ZStack (alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
                Button(action: {print("Edit image")}) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.lightBlue)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Text("Hi, \(authViewModel.firstName) \(authViewModel.lastName)")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button("Edit") {
                selectedSection = .details
                editMode = true
            }
            .buttonStyle(.plain)
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .padding()
        }
    }
}


struct DetailsSection: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    @Binding var editMode: Bool
    @Binding var addPhoneNumber: Bool
    @Binding var wantToLogOut: Bool
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large){
            if editMode {
                VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                    FirstNameInput(authViewModel: authViewModel)
                    LastNameInput(authViewModel: authViewModel)
                }
            }
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                MemberSince(authViewModel: authViewModel)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                EmailInput(authViewModel: authViewModel, editMode: $editMode)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                PhoneNumberInput(authViewModel: authViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber)
            }
            
            Spacer()
            
            Button("Log out") {
                wantToLogOut = true
            }
            .buttonStyle(.plain)
            .font(AppTheme.Typography.subtitle)
            .foregroundStyle(.secondary)
            .padding()
        }
    }
}


struct ReviewsSection: View {
    var body: some View {
        Text("You have no reviews so far.")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
    }
}


struct PasswordSection: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large) {
            Text("Please enter your current password to change your password.")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CurrentPasswordInput(authViewModel: authViewModel)
            
            NewPasswordInput(authViewModel: authViewModel)
            
            ConfirmNewPasswordInput(authViewModel: authViewModel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


struct ProfileView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
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
                    ProfileHeader(authViewModel: authViewModel, selectedSection: $selectedSection, editMode: $editMode)
                    
                    SectionsBar(selectedSection: $selectedSection) { section in
                        switch section {
                        case .details: "Details"
                        case .reviews: "Reviews"
                        case .password: "Password"
                        }
                    }
                    
                    switch selectedSection {
                    case .details:
                        DetailsSection(authViewModel: authViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber, wantToLogOut: $wantToLogOut)
                    case .reviews:
                        ReviewsSection()
                    case .password:
                        PasswordSection(authViewModel: authViewModel)
                    }
                }
                .padding(AppTheme.Spacing.large)
            }
            
            if editMode {
                SaveUserDataButton(authViewModel: authViewModel, editMode: $editMode, saveAlertMessage: $saveAlertMessage, showSaveAlert: $showSaveAlert)
            }
            if selectedSection == .password {
                UpdatePasswordButton(authViewModel: authViewModel, updateAlertMessage: $updateAlertMessage, showUpdateAlert: $showUpdateAlert, selectedSection: $selectedSection)
            }
        }
        .alert("Log out?", isPresented: $wantToLogOut) {
            Button("Cancel") {
                wantToLogOut = false
            }
            Button("OK") {
                authViewModel.signOut()
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
    let authViewModel = AuthenticationViewModel(sessionRepo: SessionRepository())
    authViewModel.firstName = "John"
    authViewModel.lastName = "Doe"
    authViewModel.profileEmail = "john.doe@example.com"
    authViewModel.phoneNumber = "+1234567890"
    authViewModel.memberSince = "24/04/2022"
    
    return ProfileView(authViewModel: authViewModel)
}
