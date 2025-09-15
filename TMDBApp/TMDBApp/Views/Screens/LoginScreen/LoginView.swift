//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


struct LoginView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
    @State private var rememberMe: Bool = false
    
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea(.all)
            
            NavigationStack {
                VStack (spacing: 0) {
                    HeaderView()
                    ScrollView {
                        VStack (spacing: AppTheme.Spacing.large) {
                            LoginHeader()
                            
                            LoginInputTextFields(authViewModel: authViewModel)
                            
                            RememberMe(rememberMe: $rememberMe)
                            
                            CustomDivider()
                            
                            SignInButton(authViewModel: authViewModel, alertMessage: $alertMessage, showAlert: $showAlert)
                            
                            SignUpLink(authViewModel: authViewModel)
                        }
                    }
                }
                .background(AppTheme.Colors.background)
                .alert("Sign in", isPresented: $showAlert) {
                    Button("OK") { }
                } message: {
                    Text(alertMessage)
                }
            }
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthenticationViewModel(sessionRepo: SessionRepository()))
}
