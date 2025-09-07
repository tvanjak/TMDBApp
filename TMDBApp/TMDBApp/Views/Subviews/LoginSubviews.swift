//
//  LoginSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


struct LoginHeader: View {
    var body: some View {
        Text("Sign in to your ")
            .font(AppTheme.Typography.title)
            .foregroundStyle(.white)
        + Text("TMDB")
            .font(AppTheme.Typography.title)
            .bold()
            .foregroundStyle(.white)
        + Text(" account to continue.")
            .foregroundStyle(.white)
            .font(AppTheme.Typography.title)
    }
}

struct LoginInputTextFields: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        CustomTextField(text: $authViewModel.email, subtitle: "Email address", placeholder: "ex. Matt", secure: false)
        
        CustomTextField(text: $authViewModel.password, subtitle: "Password", placeholder: "Enter your password", secure: true, forgotPasswordAction: {})
        
    }
}

struct RememberMe: View {
    @Binding var rememberMe: Bool
    
    var body: some View {
        HStack {
            Toggle("Remember me", isOn: $rememberMe)
                .toggleStyle(CheckboxToggleStyle())
                .foregroundColor(.white)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct SignInButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        Button {
            Task {
                await authViewModel.signIn()
            }
        } label: {
            Text("Sign in")
                .bold()
                .font(AppTheme.Typography.body)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .background(AppTheme.Colors.lightBlue)
                .cornerRadius(AppTheme.Radius.medium)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

struct SignUpLink: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        HStack {
            Text("Don't have a TMDB account?")
                .foregroundStyle(.white)
                .font(AppTheme.Typography.body)
                .fontWeight(.regular)
            NavigationLink(destination:
                            SignUpView(authViewModel: authViewModel)
            ) {
                Text("Create one here")
                    .foregroundColor(.blue)
                    .font(AppTheme.Typography.body)
            }
        }
    }
}
