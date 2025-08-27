//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var rememberMe: Bool = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea(.all)
            
            NavigationStack {
                VStack (spacing: 0) {
                    HeaderView()
                    ScrollView {
                        VStack (spacing: AppTheme.Spacing.large) {
                            
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

                            CustomTextField(text: $authViewModel.email, subtitle: "Email address", placeholder: "ex. Matt", secure: false)
                            
                            
                            CustomTextField(text: $authViewModel.password, subtitle: "Password", placeholder: "Enter your password", secure: true, forgotPasswordAction: {})
                            
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
                                .foregroundColor(AppTheme.Colors.lightBlue)

                            Button {
                                Task {
                                    await authViewModel.signIn() // add navigation
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
                            
                            HStack {
                                Text("Don't have a TMDB account?")
                                    .foregroundStyle(.white)
                                    .font(AppTheme.Typography.body)
                                    .fontWeight(.regular)
                                NavigationLink(destination:
                                    SignUpView()
                                        .environmentObject(authViewModel)
                                ) {
                                    Text("Create one here")
                                        .foregroundColor(.blue)
                                        .font(AppTheme.Typography.body)
                                }
                            }
                            
                        }
                    }
                }
                .background(AppTheme.Colors.background)
                // Optional: For iOS 16+ to make the actual navigation bar transparent if it's still showing white
                .toolbarBackground(.hidden, for: .navigationBar)
                // Ensures status bar text (time, battery) is visible on a dark background
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}
