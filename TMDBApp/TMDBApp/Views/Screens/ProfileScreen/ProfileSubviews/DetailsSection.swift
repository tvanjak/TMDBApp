//
//  ProfileDetailsSection.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import SwiftUI

struct DetailsSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @Binding var editMode: Bool
    @Binding var addPhoneNumber: Bool
    @Binding var wantToLogOut: Bool
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large){
            if editMode {
                VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                    ProfileTextField(subtitle: "First Name", input: $profileViewModel.profile.firstName)
                    ProfileTextField(subtitle: "Last Name", input: $profileViewModel.profile.lastName)
                }
            }
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                MemberSince(profileViewModel: profileViewModel)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                if editMode {
                    ProfileTextField(subtitle: "Email address", input: $profileViewModel.profile.profileEmail)
                } else {
                    ProfileText(subtitle: "Email address", text: profileViewModel.profile.profileEmail)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                if editMode || addPhoneNumber {
                    ProfileTextField(subtitle: "Phone number", input: $profileViewModel.profile.phoneNumber)
                }
                else {
                    if profileViewModel.profile.phoneNumber == "" {
                        AddPhoneNumberButton(addPhoneNumber: $addPhoneNumber)
                    }
                    else {
                        ProfileText(subtitle: "Phone number", text: profileViewModel.profile.phoneNumber)
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
