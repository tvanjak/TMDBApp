//
//  ProfileView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    @Binding var path: NavigationPath

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
    @Previewable @State var path = NavigationPath()
    return ProfileView(path: $path)
        .environmentObject(AuthenticationViewModel())
}
