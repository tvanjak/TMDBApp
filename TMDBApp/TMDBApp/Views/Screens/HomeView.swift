//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel

    @State private var searchTerm = ""
        
    enum MovieSections: CaseIterable, Hashable {
        case popular
        case trending
        case upcoming
        case nowPlaying
    }
    @State private var selectedMovieSection: MovieSections = .popular
    
    
    enum TVShowSections: CaseIterable, Hashable {
        case popular
        case topRated
    }
    @State private var selectedTVShowSection: TVShowSections = .popular
    
    var currentMovies: [MediaItem] {
        switch selectedMovieSection {
        case .popular: 
            if homeViewModel.popularMovies.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadPopularMovies()
                }
            }
            return homeViewModel.popularMovies
        case .trending:
            if homeViewModel.trendingMovies.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadTrendingMovies()
                }
            }
            return homeViewModel.trendingMovies
        case .upcoming:
            if homeViewModel.upcomingMovies.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadUpcomingMovies()
                }
            }
            return homeViewModel.upcomingMovies
        case .nowPlaying:
            if homeViewModel.nowPlayingMovies.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadNowPlayingMovies()
                }
            }
            return homeViewModel.nowPlayingMovies
        }
    }

    var currentTVShows: [MediaItem] {
        switch selectedTVShowSection {
        case .popular:
            if homeViewModel.popularTVShows.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadPopularTVShows()
                }
            }
            return homeViewModel.popularTVShows
        case .topRated:
            if homeViewModel.topRatedTVShows.isEmpty {
                Task { @MainActor in
                    await homeViewModel.loadTopRatedTVShows()
                }
            }
            return homeViewModel.topRatedTVShows
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                    
                    TextField("Search", text: $searchTerm)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(AppTheme.Spacing.small)
                .frame(width: 360, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(AppTheme.Radius.small)
                .padding(.top)
                
                MoviesList(homeViewModel: homeViewModel, selectedMovieSection: $selectedMovieSection, currentMovies: currentMovies)
                
                TVShowsList(homeViewModel: homeViewModel, selectedTVShowSection: $selectedTVShowSection, currentTVShows: currentTVShows)

            }
            .onAppear {
                Task {
                    if homeViewModel.popularMovies.isEmpty {
                        await homeViewModel.loadPopularMovies()
                    }
                    if homeViewModel.popularTVShows.isEmpty {
                        await homeViewModel.loadTrendingMovies()
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView(homeViewModel: HomeViewModel(
        favoritesManager: FavoritesManager(favoritesRepo: FavoritesRepository(), sessionRepo: SessionRepository()),
        navigationService: Router()
    ))
}
