//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    
    var body: some View {
        VStack  {
            HeaderView()
                .padding(.bottom)
            VStack (spacing: 30) {
                
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
                
                CustomTextField(text: $email, subtitle: "Email address", placeholder: "ex. Matt", secure: false)
                
                    
                CustomPasswordTextField(text: $password, subtitle: "Password", placeholder: "Enter your password", secure: true, forgotPasswordAction: {})
                
                HStack {
                    Toggle("Remember me", isOn: $rememberMe)
                        .toggleStyle(CheckboxToggleStyle())
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 1)
                    .padding(.horizontal)
                    .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
                
                Button(action: {})
                {
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

                HStack {
                    Text("Don't have a TMDB account?")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.regular)
                    Button("Create one here") {}
                }
                
            }
            Spacer()
        }
        .background(Color(red: 11/255, green: 37/255, blue: 63/255))
        
    }
}

#Preview {
    LoginView()
}
