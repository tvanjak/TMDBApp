//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI
import FirebaseAuth

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
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .background(Color(red: 76/255, green: 178/255, blue: 223/255))
                .cornerRadius(10)
        }
        .padding(.horizontal,30)
    }
}


struct LoginLink: View {
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        HStack {
            Text("Already have a TMDB account?")
                .foregroundStyle(.white)
                .font(.headline)
                .fontWeight(.regular)
            NavigationLink(destination: LoginView(authViewModel: authViewModel)
            ) {
                Text("Sign in here")
                    .foregroundColor(.blue)
                    .font(.headline)
            }
        }
    }
}


struct SignUpView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var localErrorMessage: String?
    
    var body: some View {
        ZStack {
            Color(red: 11/255, green: 37/255, blue: 63/255)
                .ignoresSafeArea(.all)
            NavigationStack {
                VStack  {
                    HeaderView()
                    ScrollView {
                        VStack (spacing: 30) {
                            
                            HStack {
                                Text("Sign up to continue")
                                    .font(.title)
                                    .foregroundStyle(.white)
                                Spacer()
                            } .padding(.horizontal)
                            
                            SignUpInputTextfields(authViewModel: authViewModel)
                            
                            // Display error messages
                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            } else if let localError = localErrorMessage {
                                Text(localError)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                            
                            Rectangle()
                                .frame(height: 1)
                                .padding(.horizontal)
                                .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
                            
                            SignUpButton(authViewModel: authViewModel, localErrorMessage: $localErrorMessage)
                            
                            
                            LoginLink(authViewModel: authViewModel)
                        }
                    }
                }
                .background(Color(red: 11/255, green: 37/255, blue: 63/255))
            }
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthenticationViewModel(sessionRepo: SessionRepository()))
}
