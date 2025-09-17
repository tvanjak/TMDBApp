//
//  ProfileHeader.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 17.09.2025..
//

import SwiftUI


struct ProfileHeader: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Binding var selectedSection: ProfileView.ProfileSections
    @Binding var editMode: Bool
    
    var body: some View {
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
                            .fill(AppTheme.Colors.lightBlue)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Text("Hi, \(profileViewModel.firstName.wrappedValue) \(profileViewModel.lastName.wrappedValue)")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button("Edit") {
                selectedSection = .details
                editMode = true
            }
            .buttonStyle(.plain)
            .font(AppTheme.Typography.body)
            .foregroundStyle(.secondary)
            .padding()
        }
    }
}
