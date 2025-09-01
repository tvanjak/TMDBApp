//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var confirmPassword: String = ""
    @State private var localErrorMessage: String?
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    
    
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
                            
                            HStack {
                                CustomTextField(text: $firstName, subtitle: "First name", placeholder: "ex. Matt", secure: false)
                                
                                CustomTextField(text: $lastName,subtitle: "Last name", placeholder: "ex. Smith", secure: false)
                            }
                            
                            CustomTextField(text: $email, subtitle: "Email address", placeholder: "email@example.com", secure: false)
                            
                            CustomTextField(text: $phoneNumber, subtitle: "Phone number", placeholder: "Enter your phone number", secure: false)
                            
                            CustomTextField(text: $password,subtitle: "Password", placeholder: "Enter your password", secure: true)
                            
                            CustomTextField(text: $confirmPassword,subtitle: "Confirm password", placeholder: "Repeat your password", secure: true)
                            
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
                            
                            Button {
                                localErrorMessage = nil
                                if password == confirmPassword {
                                    Task {
                                        // Sync local state with authViewModel before signing up
                                        authViewModel.firstName = firstName
                                        authViewModel.lastName = lastName
                                        authViewModel.email = email
                                        authViewModel.phoneNumber = phoneNumber
                                        authViewModel.password = password
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
                }
                .background(Color(red: 11/255, green: 37/255, blue: 63/255))
            }
        }
    }
}

#Preview {
    SignUpView(authViewModel: AuthenticationViewModel())
}
