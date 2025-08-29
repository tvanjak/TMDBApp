//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var movieViewModel: MovieViewModel
    @EnvironmentObject var tvShowViewModel: TVShowViewModel
    
    @State private var selectedSection: Section = .home
    enum Section { case home, favorites, profile }

    var body: some View {
        VStack(spacing: 0) {
            switch selectedSection {
            case .home:
                HeaderView(canGoBack: !router.homePath.isEmpty, onBack: { router.goBack(from: .home) })
            case .favorites:
                HeaderView(canGoBack: !router.favoritesPath.isEmpty, onBack: { router.goBack(from: .favorites) })
            case .profile:
                HeaderView(canGoBack: !router.profilePath.isEmpty, onBack: { router.goBack(from: .profile) })
            }

            ZStack {
                switch selectedSection {
                case .home:
                    NavigationStack(path: $router.homePath) {
                        HomeView(path: $router.homePath)
                            .environmentObject(movieViewModel)
                            .environmentObject(tvShowViewModel)
                            .navigationDestination(for: Int.self) { movieId in
                                MovieView(movieId: movieId)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                case .favorites:
                    NavigationStack(path: $router.favoritesPath) {
                        FavoritesView(path: $router.favoritesPath)
                            .navigationDestination(for: Int.self) { movieId in
                                MovieView(movieId: movieId)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                case .profile:
                    NavigationStack(path: $router.profilePath) {
                        ProfileView(path: $router.profilePath)
                            .environmentObject(authViewModel)
                    }
                }
            }

            FooterView(selectedSection: $selectedSection)
        }
    }
}


#Preview {
    AppLayout()
        .environmentObject(MovieViewModel())
        .environmentObject(TVShowViewModel())
        .environmentObject(AuthenticationViewModel())
        .environmentObject(Router())
}
