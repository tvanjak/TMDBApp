//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


struct ProfileSectionsBar: View {
    @Binding var selectedSection: ProfileView.sections
    
    var body: some View {
        HStack (alignment: .top, spacing: AppTheme.Spacing.large) {
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .details
                } label: {
                    Text("Details")
                        .font(AppTheme.Typography.subtitle)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.details ? .bold : .thin)
                }
                if selectedSection == .details {
                    Rectangle()
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)                    }
            }
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .reviews
                } label: {
                    Text("Reviews")
                        .font(AppTheme.Typography.subtitle)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.reviews ? .bold : .thin)
                }
                if selectedSection == .reviews {
                    Rectangle()
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)                    }
            }
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .password
                } label: {
                    Text("Password")
                        .font(AppTheme.Typography.subtitle)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.password ? .bold : .thin)
                }
                if selectedSection == .password {
                    Rectangle()
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)                    }
            }
            
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding(.vertical)
    }
}


struct DetailsSection: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var profileEmail: String
    @Binding var phoneNumber: String
    @Binding var memberSince: String
    
    @Binding var editMode: Bool
    @Binding var addPhoneNumber: Bool
    @Binding var wantToLogOut: Bool
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large){
            if editMode {
                VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                    Text("First name")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.secondary)
                        .fontWeight(.regular)
                    TextField("", text: $firstName)
                        .font(AppTheme.Typography.subtitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                                .shadow(radius: AppTheme.Radius.small)
                        )
                    
                    Text("Last name")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.secondary)
                        .fontWeight(.regular)
                    TextField("", text: $lastName)
                        .font(AppTheme.Typography.subtitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                                .shadow(radius: AppTheme.Radius.small)
                        )
                }
            }
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Member since")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                Text(memberSince)
                    .font(AppTheme.Typography.subtitle)

            } .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Email address")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                if editMode {
                    TextField("", text: $profileEmail)
                        .font(AppTheme.Typography.subtitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                                .shadow(radius: AppTheme.Radius.small)
                        )
                } else {
                    Text(profileEmail)
                        .font(AppTheme.Typography.subtitle)
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(radius: AppTheme.Radius.small)
                        )
                }
            } .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Phone number")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                if editMode {
                    TextField("", text: $phoneNumber)
                        .font(AppTheme.Typography.subtitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                                .shadow(radius: AppTheme.Radius.small)
                        )
                }
                else {
                    if phoneNumber == "" {
                        Button(action: {addPhoneNumber = true}) {
                            Text("Add phone number")
                                .font(AppTheme.Typography.subtitle)
                                .foregroundStyle(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.gray.opacity(0.2))
                                .cornerRadius(AppTheme.Radius.small)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                        .shadow(radius: AppTheme.Radius.small)
                                )
                        } .frame(maxWidth: .infinity, alignment: .leading)
                            .buttonStyle(.plain)
                    }
                    else {
                        Text(phoneNumber)
                            .font(AppTheme.Typography.subtitle)
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                    .shadow(radius: AppTheme.Radius.small)
                            )
                    }
                }
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


struct PasswordSection: View {
    @Binding var password: String
    @Binding var newPassword: String
    @Binding var confirmNewPassword: String
    
    
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large) {
            Text("Please enter your current password to change your password.")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Current password")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                SecureField("", text: $password)
                    .font(AppTheme.Typography.subtitle)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .shadow(radius: AppTheme.Radius.small)
                    )
            }
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("New password")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                SecureField("Enter new password", text: $newPassword)
                    .font(AppTheme.Typography.subtitle)
                    .foregroundStyle(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(AppTheme.Radius.small)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .shadow(radius: AppTheme.Radius.small)
                    )
            }
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Confirm new password")
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                TextField("", text: $confirmNewPassword)
                    .font(AppTheme.Typography.subtitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                            .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                            .shadow(radius: AppTheme.Radius.small)
                    )
            }
        } .frame(maxWidth: .infinity, alignment: .leading)
    }
}



struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    enum sections {
        case details
        case reviews
        case password
    }
    @State private var selectedSection: sections = .details
    @State private var addPhoneNumber: Bool = false
    @State private var editMode: Bool = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var profileEmail = ""
    @State private var phoneNumber = ""
    @State private var memberSince = ""
    
    @State private var password: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    
    @State private var wantToLogOut: Bool = false
    
    @State private var showSaveAlert = false
    @State private var saveAlertMessage = ""
    
    @State private var showUpdateAlert = false
    @State private var updateAlertMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading, spacing: AppTheme.Spacing.large) {
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
                        
                        Text("Hi, \(firstName) \(lastName)")
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
                    
                    ProfileSectionsBar(selectedSection: $selectedSection)
                    
                    switch selectedSection {
                    case .details:
                        DetailsSection(firstName: $firstName, lastName: $lastName, profileEmail: $profileEmail, phoneNumber: $phoneNumber, memberSince: $memberSince, editMode: $editMode, addPhoneNumber: $addPhoneNumber, wantToLogOut: $wantToLogOut)
                    case .reviews:
                        Text("You have no reviews so far.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    case .password:
                        PasswordSection(password: $password, newPassword: $newPassword, confirmNewPassword: $confirmNewPassword)
                    }
                }
                .padding(AppTheme.Spacing.large)
            }
            
            if editMode {
                Button(action: {
                    Task {
                        await authViewModel.updateUserProfileData(
                            newFirstName: firstName,
                            newLastName: lastName,
                            newPhoneNumber: phoneNumber,
                            newEmail: profileEmail
                        )
                        if let error = authViewModel.errorMessage {
                            saveAlertMessage = error
                            showSaveAlert = true
                        } else {
                            saveAlertMessage = "Profile updated successfully!"
                            showSaveAlert = true
                        }
                    }
                    editMode = false
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.lightBlue)
                        .foregroundColor(.white)
                        .cornerRadius(AppTheme.Radius.medium)
                        .padding()
                }
            }
            if selectedSection == .password {
                Button(action: {
                    Task {
                        await authViewModel.updateUserPassword(
                            currentPassword: password,
                            newPassword: newPassword,
                            confirmNewPassword: confirmNewPassword
                        )
                        if let error = authViewModel.errorMessage {
                            updateAlertMessage = error
                            showUpdateAlert = true
                        } else {
                            updateAlertMessage = "Password updated successfully!"
                            showUpdateAlert = true
                        }
                    }
                    selectedSection = .details
                }) {
                    Text("Update")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.lightBlue)
                        .foregroundColor(.white)
                        .cornerRadius(AppTheme.Radius.small)
                        .padding()
                }
            }
        }
        .onAppear {
            firstName = authViewModel.firstName
            lastName = authViewModel.lastName
            profileEmail = authViewModel.profileEmail
            phoneNumber = authViewModel.phoneNumber
            memberSince = authViewModel.memberSince
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
    let authViewModel = AuthenticationViewModel()
    authViewModel.firstName = "John"
    authViewModel.lastName = "Doe"
    authViewModel.profileEmail = "john.doe@example.com"
    authViewModel.phoneNumber = "+1234567890"
    authViewModel.memberSince = "24/04/2022"
    
    return ProfileView()
        .environmentObject(authViewModel)
}
