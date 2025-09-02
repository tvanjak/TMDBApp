//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


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


struct DetailsSection: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    @Binding var editMode: Bool
    @Binding var addPhoneNumber: Bool
    @Binding var wantToLogOut: Bool
    
    var body: some View {
        VStack (spacing: 25){
            if editMode {
                VStack (alignment: .leading, spacing: 10) {
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
                    
                    Text("Last name")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .fontWeight(.regular)
                    TextField("", text: $authViewModel.lastName)
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
            
            VStack (alignment: .leading, spacing: 10) {
                Text("Member since")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                Text(authViewModel.memberSince)
                    .font(.title3)
                
            } .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: 10) {
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
            } .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: 10) {
                Text("Phone number")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                if editMode {
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


struct PasswordSection: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack (spacing: 25) {
            Text("Please enter your current password to change your password.")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
        } .frame(maxWidth: .infinity, alignment: .leading)
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
    @State private var addPhoneNumber: Bool = false
    @State private var editMode: Bool = false
    
    
    @State private var wantToLogOut: Bool = false
    
    @State private var showSaveAlert = false
    @State private var saveAlertMessage = ""
    
    @State private var showUpdateAlert = false
    @State private var updateAlertMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (spacing: 20) {
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
                    
                    SectionsBar(selectedSection: $selectedSection)
                    
                    switch selectedSection {
                    case .details:
                        DetailsSection(authViewModel: authViewModel, editMode: $editMode, addPhoneNumber: $addPhoneNumber, wantToLogOut: $wantToLogOut)
                    case .reviews:
                        Text("You have no reviews so far.")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    case .password:
                        PasswordSection(authViewModel: authViewModel)
                    }
                }
                .padding(25)
            }
            
            if editMode {
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
            if selectedSection == .password {
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
