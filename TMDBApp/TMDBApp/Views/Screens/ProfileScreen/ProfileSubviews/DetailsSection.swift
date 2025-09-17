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
                    ProfileTextField(subtitle: "First Name", input: profileViewModel.firstName)
                    ProfileTextField(subtitle: "Last Name", input: profileViewModel.lastName)
                }
            }
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                MemberSince(profileViewModel: profileViewModel)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                if editMode {
                    ProfileTextField(subtitle: "Email address", input: profileViewModel.profileEmail)
                } else {
                    ProfileText(subtitle: "Email address", text: profileViewModel.profileEmail.wrappedValue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                if editMode || addPhoneNumber {
                    ProfileTextField(subtitle: "Phone number", input: profileViewModel.phoneNumber)
                }
                else {
                    if profileViewModel.phoneNumber.wrappedValue == "" {
                        AddPhoneNumberButton(addPhoneNumber: $addPhoneNumber)
                    }
                    else {
                        ProfileText(subtitle: "Phone number", text: profileViewModel.phoneNumber.wrappedValue)
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
