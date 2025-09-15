//
//  ProfileSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI

struct ProfileTextField: View {
    var subtitle: String
    @Binding var input: String
    
    var body: some View {
        Text(subtitle)
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        TextField("", text: $input)
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

struct ProfileText: View {
    var subtitle: String
    var text: String
    
    var body: some View {
        Text(subtitle)
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        Text(text)
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

struct AddPhoneNumberButton: View {
    @Binding var addPhoneNumber: Bool
    
    var body: some View {
        Text("Phone number")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
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
}


struct MemberSince: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Text("Member since")
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        Text(profileViewModel.memberSince)
            .font(AppTheme.Typography.subtitle)
    }
}



// PASSWORD SECTION ----------------------------------
struct CurrentPasswordInput: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Current password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("", text: $profileViewModel.currentPassword)
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
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("New password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("Enter new password", text: $profileViewModel.newPassword)
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
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Confirm new password")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("", text: $profileViewModel.confirmNewPassword)
                .font(AppTheme.Typography.subtitle)
                .foregroundStyle(.black) // unnecessary
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white) // unnecessary
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.small)
                        .stroke(AppTheme.Colors.lightBlue, lineWidth: 2)
                        .shadow(radius: AppTheme.Radius.small)
                )
        }
    }
}


// BUTTONS ----------------------------------
//struct ProfileButton: View {
//    @Binding var errorMessage: String?
//    @Binding var alertMessage: String
//    @Binding var showAlert: Bool
//    var userAction: () async -> Void
//    
//    var body: some View {
//        Button(action: {
//            Task {
//                await userAction()
//                if let error = errorMessage {
//                    alertMessage = error
//                    showAlert = true
//                } else {
//                    alertMessage = "Password updated successfully!"
//                    showAlert = true
//                }
//            }
////            selectedSection = .details
//        }) {
//            Text("Update")
//                .font(AppTheme.Typography.body)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(AppTheme.Colors.lightBlue)
//                .foregroundColor(.white)
//                .cornerRadius(AppTheme.Radius.medium)
//                .padding()
//        }
//    }
//}

struct UpdatePasswordButton: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var updateAlertMessage: String
    @Binding var showUpdateAlert: Bool
    @Binding var selectedSection: ProfileView.ProfileSections
    
    var body: some View {
        Button(action: {
            Task {
                await profileViewModel.updateUserPassword()
                if let error = profileViewModel.errorMessage {
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
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var editMode: Bool
    @Binding var saveAlertMessage: String
    @Binding var showSaveAlert: Bool
    
    var body: some View {
        Button(action: {
            Task {
                await profileViewModel.updateUserProfileData()
                if let error = profileViewModel.errorMessage {
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
