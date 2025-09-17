//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI


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
    SignUpView(authViewModel: AuthenticationViewModel(sessionManager: SessionManager(sessionRepo: SessionRepository())))
}
