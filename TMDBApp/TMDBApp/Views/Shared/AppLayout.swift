//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @StateObject private var router = Router()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var movieViewModel = MovieViewModel(favoritesRepo: FavoritesRepository.shared, sessionRepo: SessionRepository.shared)

    @State private var selectedSection: Section = .home
    enum Section { case home, favorites, profile }

    var body: some View {
        VStack(spacing: 0) {
            switch selectedSection {
            case .home:
                HeaderView(canGoBack: router.canGoBack(from: .home), onBack: { router.goBack(from: .home) })
            case .favorites:
                HeaderView(canGoBack: router.canGoBack(from: .favorites), onBack: { router.goBack(from: .favorites) })
            case .profile:
                HeaderView(canGoBack: router.canGoBack(from: .profile), onBack: { router.goBack(from: .profile) })
            }

            ZStack {
                switch selectedSection {
                case .home:
                    NavigationStack(path: $router.homePath) {
                        HomeView()
                            .environmentObject(movieViewModel)
                            .navigationDestination(for: Int.self) { movieId in
                                MovieView(movieId: movieId)
                                    .environmentObject(movieViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                case .favorites:
                    NavigationStack(path: $router.favoritesPath) {
                        FavoritesView()
                            .environmentObject(movieViewModel)
                            .navigationDestination(for: Int.self) { movieId in
                                MovieView(movieId: movieId)
                                    .environmentObject(movieViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                case .profile:
                    NavigationStack(path: $router.profilePath) {
                        ProfileView()
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
        .environmentObject(AuthenticationViewModel())
        .environmentObject(Router())
}
