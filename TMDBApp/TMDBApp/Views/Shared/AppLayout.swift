//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @State private var homePath = NavigationPath()
    @State private var favoritesPath = NavigationPath()
    @State private var profilePath = NavigationPath()
    
    @StateObject private var movieViewModel = MovieViewModel()
    @StateObject private var tvShowViewModel = TVShowViewModel()
    
    @State private var selectedSection: Section = .home
    
    enum Section {
        case home, favorites, profile
    }
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    
    var body: some View {
        VStack(spacing: 0) {
            switch selectedSection {
            case .home:
                HeaderView(canGoBack: !homePath.isEmpty, onBack: { homePath.removeLast() })
            case .favorites:
                HeaderView(canGoBack: !favoritesPath.isEmpty, onBack: { favoritesPath.removeLast() })
            case .profile:
                HeaderView(canGoBack: !profilePath.isEmpty, onBack: { profilePath.removeLast() })
            }
            
            ZStack {
                switch selectedSection {
                case .home:
                    NavigationStack(path: $homePath) {
                        HomeView(
                            movieViewModel: movieViewModel,
                            tvShowViewModel: tvShowViewModel
                        )
                        .environmentObject(authViewModel)
                        .navigationDestination(for: Int.self) { movieId in
                            MovieView(movieId: movieId)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .navigationBar)
                                .environmentObject(authViewModel)
                        }
                    }
                    
                case .favorites:
                    NavigationStack(path: $favoritesPath) {
                        FavoritesView()
                            .environmentObject(authViewModel)
                            .navigationDestination(for: Int.self) { movieId in
                                MovieView(movieId: movieId)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                                    .environmentObject(authViewModel)
                            }
                    }
                    
                case .profile:
                    NavigationStack(path: $profilePath) {
                        ProfileView()
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            
            FooterView(selectedSection: $selectedSection)
                .padding(.top)
        }
    }
}

#Preview {
    AppLayout()
        .environmentObject(AuthenticationViewModel())
}
