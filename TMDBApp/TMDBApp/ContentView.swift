//
//  ContentView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        if authViewModel.currentUser != nil {
            AppLayout()
                .environmentObject(authViewModel)
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
}
