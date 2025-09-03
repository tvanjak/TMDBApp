//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct LoginHeader: View {
    var body: some View {
        Text("Sign in to your ")
            .font(.title)
            .foregroundStyle(.white)
        + Text("TMDB")
            .font(.title)
            .bold()
            .foregroundStyle(.white)
        + Text(" account to continue.")
            .foregroundStyle(.white)
            .font(.title)
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
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .background(Color(red: 76/255, green: 178/255, blue: 223/255))
                .cornerRadius(12)
        }
        .padding(.horizontal,30)
    }
}

struct SignUpLink: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        HStack {
            Text("Don't have a TMDB account?")
                .foregroundStyle(.white)
                .font(.headline)
                .fontWeight(.regular)
            NavigationLink(destination:
                            SignUpView(authViewModel: authViewModel)
                ) {
                Text("Create one here")
                    .foregroundColor(.blue)
                    .font(.headline)
            }
        }
    }
}

struct LoginView: View {
    
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var rememberMe: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 11/255, green: 37/255, blue: 63/255)
                .ignoresSafeArea(.all)
            
            NavigationStack {
                VStack (spacing: 0) {
                    HeaderView()
                    ScrollView {
                        VStack (spacing: 30) {
                            LoginHeader()
                            
                            LoginInputTextFields(authViewModel: authViewModel)
                            
                            RememberMe(rememberMe: $rememberMe)
                            
                            CustomDivider()
                            
                            SignInButton(authViewModel: authViewModel)
                            
                            SignUpLink(authViewModel: authViewModel)
                        }
                    }
                }
                .background(Color(red: 11/255, green: 37/255, blue: 63/255))
            }
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthenticationViewModel(sessionRepo: SessionRepository()))
}
