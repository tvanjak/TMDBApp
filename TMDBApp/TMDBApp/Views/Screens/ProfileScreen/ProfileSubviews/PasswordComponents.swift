//
//  ProfileSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI

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
