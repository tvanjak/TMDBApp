//
//  ContentView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var router: Router

    var body: some View {
        if authViewModel.currentUser != nil {
            AppLayout()
                .environmentObject(authViewModel)
                .environmentObject(router)
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(Router())
}
