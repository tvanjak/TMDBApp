//
//  ProfileSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI

// DETAILS SECTION ----------------------------------
struct FirstNameInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("First name")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        TextField("", text: $authViewModel.firstName)
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

struct LastNameInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("Last name")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        TextField("", text: $authViewModel.lastName)
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

struct MemberSince: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("Member since")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        Text(authViewModel.memberSince)
            .font(AppTheme.Typography.subtitle)
    }
}

struct EmailInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var editMode: Bool
    
    var body: some View {
        Text("Email address")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        if editMode {
            TextField("", text: $authViewModel.profileEmail)
                .font(AppTheme.Typography.subtitle)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                        .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                        .shadow(radius: AppTheme.Radius.small)
                )
        } else {
            Text(authViewModel.profileEmail)
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

struct PhoneNumberInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var editMode: Bool
    @Binding var addPhoneNumber: Bool

    var body: some View {
        Text("Phone number")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        if editMode || addPhoneNumber {
            TextField("", text: $authViewModel.phoneNumber)
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
            if authViewModel.phoneNumber == "" {
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
                Text(authViewModel.phoneNumber)
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
}


// PASSWORD SECTION ----------------------------------
struct CurrentPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Current password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("", text: $authViewModel.password)
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

struct NewPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("New password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("Enter new password", text: $authViewModel.newPassword)
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
    }
}

struct ConfirmNewPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Confirm new password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("", text: $authViewModel.confirmNewPassword)
                .font(AppTheme.Typography.subtitle)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                        .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                        .shadow(radius: AppTheme.Radius.small)
                )
        }
    }
}


// BUTTONS ----------------------------------
struct UpdatePasswordButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var updateAlertMessage: String
    @Binding var showUpdateAlert: Bool
    @Binding var selectedSection: ProfileView.ProfileSections
    
    var body: some View {
        Button(action: {
            Task {
                await authViewModel.updateUserPassword()
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
                .font(AppTheme.Typography.body)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.lightBlue)
                .foregroundColor(.white)
                .cornerRadius(AppTheme.Radius.medium)
                .padding()
        }
    }
}


struct SaveUserDataButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var editMode: Bool
    @Binding var saveAlertMessage: String
    @Binding var showSaveAlert: Bool
    
    var body: some View {
        Button(action: {
            Task {
                await authViewModel.updateUserProfileData()
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
                .font(AppTheme.Typography.body)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.Colors.lightBlue)
                .foregroundColor(.white)
                .cornerRadius(AppTheme.Radius.medium)
                .padding()
        }
    }
}
