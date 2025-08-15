//
//  LoginView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("Welcome to the TMDB App!")
                .font(.largeTitle)
            Text("Please login to continue")
                .font(.caption)
            Button("Login", action: {appState.isAuthenticated = true})
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
        }
    }
}
