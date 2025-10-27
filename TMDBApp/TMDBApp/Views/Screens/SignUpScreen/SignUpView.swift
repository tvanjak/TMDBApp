//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 15.08.2025..
//

import SwiftUI


struct SignUpView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel
        
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                            
                            CustomDivider()
                            
                            SignUpButton(authViewModel: authViewModel, alertMessage: $alertMessage, showAlert: $showAlert)
                            
                            
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
    SignUpView(authViewModel: AuthenticationViewModel(authenticationRepository: AuthenticationRepository()))
}
