//
//  ProfileSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI

// DETAILS SECTION ----------------------------------
struct SectionsBar: View {
    @Binding var selectedSection: ProfileView.sections
    
    var body: some View {
        HStack (alignment: .top, spacing: 20) {
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .details
                } label: {
                    Text("Details")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.details ? .bold : .thin)
                }
                if selectedSection == .details {
                    Rectangle()
                        .frame(width: 70, height: 4)
                }
            }
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .reviews
                } label: {
                    Text("Reviews")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.reviews ? .bold : .thin)
                }
                if selectedSection == .reviews {
                    Rectangle()
                        .frame(width: 90, height: 4)
                }
            }
            VStack (alignment: .center) {
                Button() {
                    selectedSection = .password
                } label: {
                    Text("Password")
                        .font(.title3)
                        .foregroundStyle(.black)
                        .fontWeight(selectedSection == ProfileView.sections.password ? .bold : .thin)
                }
                if selectedSection == .password {
                    Rectangle()
                        .frame(width: 110, height: 4)
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
    }
}

struct FirstNameInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("First name")
            .font(.headline)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        TextField("", text: $authViewModel.firstName)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 76/255, green: 178/255, blue: 223/255), lineWidth: 2)
                    .shadow(radius: 8)
            )
    }
}

struct LastNameInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("First name")
            .font(.headline)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        TextField("", text: $authViewModel.firstName)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 76/255, green: 178/255, blue: 223/255), lineWidth: 2)
                    .shadow(radius: 8)
            )
    }
}

struct MemberSince: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Text("Member since")
            .font(.headline)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        Text(authViewModel.memberSince)
            .font(.title3)
    }
}

struct EmailInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var editMode: Bool
    
    var body: some View {
        Text("Email address")
            .font(.headline)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        if editMode {
            TextField("", text: $authViewModel.profileEmail)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 76/255, green: 178/255, blue: 223/255), lineWidth: 2)
                        .shadow(radius: 8)
                )
        } else {
            Text(authViewModel.profileEmail)
                .font(.title3)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        .shadow(radius: 8)
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
            .font(.headline)
            .foregroundStyle(.secondary)
            .fontWeight(.regular)
        if editMode || addPhoneNumber {
            TextField("", text: $authViewModel.phoneNumber)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 76/255, green: 178/255, blue: 223/255), lineWidth: 2)
                        .shadow(radius: 8)
                )
        }
        else {
            if authViewModel.phoneNumber == "" {
                Button(action: {addPhoneNumber = true}) {
                    Text("Add phone number")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                                .shadow(radius: 8)
                        )
                } .frame(maxWidth: .infinity, alignment: .leading)
                    .buttonStyle(.plain)
            }
            else {
                Text(authViewModel.phoneNumber)
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .shadow(radius: 8)
                    )
            }
        }
    }
}


// PASSWORD SECTION ----------------------------------
struct CurrentPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Current password")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("", text: $authViewModel.password)
                .font(.title3)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        .shadow(radius: 8)
                )
        }
    }
}

struct NewPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("New password")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            SecureField("Enter new password", text: $authViewModel.newPassword)
                .font(.title3)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                        .shadow(radius: 8)
                )
        }
    }
}

struct ConfirmNewPasswordInput: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Confirm new password")
                .font(.headline)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
            TextField("", text: $authViewModel.confirmNewPassword)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 76/255, green: 178/255, blue: 223/255), lineWidth: 2)
                        .shadow(radius: 8)
                )
        }
    }
}


// BUTTONS ----------------------------------
struct UpdatePasswordButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var updateAlertMessage: String
    @Binding var showUpdateAlert: Bool
    @Binding var selectedSection: ProfileView.sections
    
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
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 76/255, green: 178/255, blue: 223/255))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding()
        }
    }
}


struct SaveUserDataButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
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
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 76/255, green: 178/255, blue: 223/255))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding()
        }
    }
}
