//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct ProfileHeader: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var selectedSection: ProfileView.sections
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
                            .fill(Color(red: 76/255, green: 178/255, blue: 223/255),)
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
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button("Edit") {
                selectedSection = .details
                editMode = true
            }
            .buttonStyle(.plain)
            .font(.headline)
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
        VStack (spacing: 25){
            if editMode {
                VStack (alignment: .leading, spacing: 10) {
                    FirstNameInput(authViewModel: authViewModel)
                    LastNameInput(authViewModel: authViewModel)
                }
            }
            
            
            VStack (alignment: .leading, spacing: 10) {
                MemberSince(authViewModel: authViewModel)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: 10) {
                EmailInput(authViewModel: authViewModel, editMode: $editMode)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: 10) {
                PhoneNumberInput(authViewModel: authViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber)
            }
            
            Spacer()
            
            Button("Log out") {
                wantToLogOut = true
            }
            .buttonStyle(.plain)
            .font(.title2)
            .foregroundStyle(.secondary)
            .padding()
        }
    }
}


struct ReviewsSection: View {
    var body: some View {
        Text("You have no reviews so far.")
            .font(.headline)
            .foregroundStyle(.secondary)
    }
}


struct PasswordSection: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (spacing: 25) {
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
    
    enum sections {
        case details
        case reviews
        case password
    }
    @State private var selectedSection: sections = .details
    
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
                VStack (spacing: 20) {
                    ProfileHeader(authViewModel: authViewModel, selectedSection: $selectedSection, editMode: $editMode)
                    
                    SectionsBar(selectedSection: $selectedSection)
                    
                    switch selectedSection {
                    case .details:
                        DetailsSection(authViewModel: authViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber, wantToLogOut: $wantToLogOut)
                    case .reviews:
                        ReviewsSection()
                    case .password:
                        PasswordSection(authViewModel: authViewModel)
                    }
                }
                .padding(25)
            }
            
            if editMode {
                SaveUserDataButton(authViewModel: authViewModel, saveAlertMessage: $saveAlertMessage, showSaveAlert: $showSaveAlert)
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
