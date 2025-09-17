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
        Text(profileViewModel.memberSince.wrappedValue)
            .font(AppTheme.Typography.subtitle)
    }
}

