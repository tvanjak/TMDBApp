//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @StateObject var authViewModel = AuthenticationViewModel()
    @State private var confirmPassword: String = ""
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
                            
                            HStack {
                                CustomTextField(text: $authViewModel.firstName, subtitle: "First name", placeholder: "ex. Matt", secure: false)
                                
                                CustomTextField(text: $authViewModel.lastName,subtitle: "Last name", placeholder: "ex. Smith", secure: false)
                            }
                            
                            CustomTextField(text: $authViewModel.email, subtitle: "Email address", placeholder: "email@example.com", secure: false)
                            
                            CustomTextField(text: $authViewModel.phoneNumber, subtitle: "Phone number", placeholder: "Enter your phone number", secure: false)
                            
                            CustomTextField(text: $authViewModel.password,subtitle: "Password", placeholder: "Enter your password", secure: true)
                            
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
                                if authViewModel.password == confirmPassword {
                                    Task {
                                        await authViewModel.signUp() // add navigation
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
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal,30)
                            
                            
                            HStack {
                                Text("Already have a TMDB account?")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                    .fontWeight(.regular)
                                NavigationLink(destination: LoginView()) {
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
    SignUpView()
}
