//
//  ProfileSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI


//struct ProfileButton: View {
//    @Binding var errorMessage: String?
//    @Binding var alertMessage: String
//    @Binding var showAlert: Bool
//    var userAction: () async -> Void
//
//    @Binding var selectedSection: ProfileView.ProfileSections
//    @Binding editMode: Bool
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
//            selectedSection = .details
//            editMode = false
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
                if let error = profileViewModel.errorMessage.wrappedValue {
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
                if let error = profileViewModel.errorMessage.wrappedValue {
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
