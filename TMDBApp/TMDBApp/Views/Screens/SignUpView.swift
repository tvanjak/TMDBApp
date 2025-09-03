//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI
import FirebaseAuth

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
            CustomTextField(text: $authViewModel.firstName, subtitle: "First name", placeholder: "ex. Matt", secure: false)
            
            CustomTextField(text: $authViewModel.lastName,subtitle: "Last name", placeholder: "ex. Smith", secure: false)
        }
        
        CustomTextField(text: $authViewModel.email, subtitle: "Email address", placeholder: "email@example.com", secure: false)
        
        CustomTextField(text: $authViewModel.phoneNumber, subtitle: "Phone number", placeholder: "Enter your phone number", secure: false)
        
        CustomTextField(text: $authViewModel.password, subtitle: "Password", placeholder: "Enter your password", secure: true)
        
        CustomTextField(text: $authViewModel.confirmPassword, subtitle: "Confirm password", placeholder: "Repeat your password", secure: true)
        
    }
}

struct ErrorMessage: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var localErrorMessage: String?
    
    var body: some View {
        if let errorMessage = authViewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.horizontal)
        } else if let localError = localErrorMessage {
            Text(localError)
                .foregroundColor(.red)
                .padding(.horizontal)
        }
    }
}

struct SignUpButton: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @Binding var localErrorMessage: String?

    var body: some View {
        Button {
            localErrorMessage = nil
            if authViewModel.checkConfirmPassword() {
                Task {
                    await authViewModel.signUp()
                }
            } else {
                localErrorMessage = "Passwords do not match."
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
            NavigationLink(destination: LoginView(authViewModel: authViewModel)
            ) {
                Text("Sign in here")
                    .foregroundColor(.blue)
                    .font(AppTheme.Typography.body)
            }
        }
    }
}


struct SignUpView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var localErrorMessage: String?
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea(.all)
            NavigationStack {
                VStack  {
                    HeaderView()
                    ScrollView {
                        VStack (spacing: AppTheme.Spacing.large) {
                            SignUpHeader()
                            
                            SignUpInputTextfields(authViewModel: authViewModel)
                            
                            // Display error messages
                            ErrorMessage(authViewModel: authViewModel, localErrorMessage: $localErrorMessage)
                            
                            CustomDivider()
                            
                            SignUpButton(authViewModel: authViewModel, localErrorMessage: $localErrorMessage)
                            
                            
                            LoginLink(authViewModel: authViewModel)
                        }
                    }
                }
                .background(AppTheme.Colors.background)
            }
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthenticationViewModel(sessionRepo: SessionRepository()))
}
