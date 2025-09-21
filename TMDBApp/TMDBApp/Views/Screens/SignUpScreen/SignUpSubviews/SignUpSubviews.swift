//
//  SignUpSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


struct SignUpHeader: View {
    var body: some View {
        HStack {
            Text("Sign up to continue")
                .font(AppTheme.Typography.title)
                .foregroundStyle(.white)
            Spacer()
        } .padding(.horizontal)
    }
}

struct SignUpInputTextfields: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        HStack {
            AuthenticationTextField(text: $authViewModel.firstName, subtitle: "First name", placeholder: "ex. Matt", secure: false)
            
            AuthenticationTextField(text: $authViewModel.lastName,subtitle: "Last name", placeholder: "ex. Smith", secure: false)
        }
        
        AuthenticationTextField(text: $authViewModel.email, subtitle: "Email address", placeholder: "email@example.com", secure: false)
        
        AuthenticationTextField(text: $authViewModel.phoneNumber, subtitle: "Phone number", placeholder: "Enter your phone number", secure: false)
        
        AuthenticationTextField(text: $authViewModel.password, subtitle: "Password", placeholder: "Enter your password", secure: true)
        
        AuthenticationTextField(text: $authViewModel.confirmPassword, subtitle: "Confirm password", placeholder: "Repeat your password", secure: true)
        
    }
}

struct SignUpButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var alertMessage: String
    @Binding var showAlert: Bool

    var body: some View {
        Button {
            authViewModel.errorMessage = nil
            Task {
                await authViewModel.signUp()
                if let error = authViewModel.errorMessage {
                    alertMessage = error
                    showAlert = true
                } else {
                    alertMessage = "Signed up succsesfully!"
                    showAlert = true
                }
            }
        } label: {
            Text("Sign Up")
                .bold()
                .font(AppTheme.Typography.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .background(AppTheme.Colors.lightBlue)
                .cornerRadius(AppTheme.Radius.small)
        }
        .padding(.horizontal,AppTheme.Spacing.large)
    }
}


struct LoginLink: View {
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        HStack {
            Text("Already have a TMDB account?")
                .foregroundStyle(.white)
                .font(AppTheme.Typography.body)
                .fontWeight(.regular)
            NavigationLink(destination: LoginView(authViewModel: authViewModel)) {
                Text("Sign in here")
                    .foregroundColor(AppTheme.Colors.lightBlue)
                    .font(AppTheme.Typography.body)
            }
        }
    }
}
