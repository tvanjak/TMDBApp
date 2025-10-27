//
//  ProfileDetailsSection.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import SwiftUI

struct PasswordSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack (spacing: AppTheme.Spacing.large) {
            Text("Please enter your current password to change your password.")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CurrentPasswordInput(profileViewModel: profileViewModel)
            
            NewPasswordInput(profileViewModel: profileViewModel)
            
            ConfirmNewPasswordInput(profileViewModel: profileViewModel)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
