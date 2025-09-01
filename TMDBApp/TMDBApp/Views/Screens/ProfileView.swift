//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


struct ProfileView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Text("ProfileView")
                .font(.largeTitle)

            Button("Log out") {
                authViewModel.signOut()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}

#Preview {
    ProfileView(authViewModel: AuthenticationViewModel())
}
