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
                            
                            SignInButton(authViewModel: authViewModel)
                            
                            SignUpLink(authViewModel: authViewModel)
                        }
                    }
                }
                .background(AppTheme.Colors.background)
            }
        }
    }
}

#Preview {
    LoginView(authViewModel: AuthenticationViewModel(sessionRepo: SessionRepository()))
}
