//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    

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
            if mediaViewModel.popularMovies.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadPopularMovies()
                }
            }
            return mediaViewModel.popularMovies
        case .trending:
            if mediaViewModel.trendingMovies.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadTrendingMovies()
                }
            }
            return mediaViewModel.trendingMovies
        case .upcoming:
            if mediaViewModel.upcomingMovies.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadUpcomingMovies()
                }
            }
            return mediaViewModel.upcomingMovies
        case .nowPlaying:
            if mediaViewModel.nowPlayingMovies.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadNowPlayingMovies()
                }
            }
            return mediaViewModel.nowPlayingMovies
        }
    }

    var currentTVShows: [MediaItem] {
        switch selectedTVShowSection {
        case .popular:
            if mediaViewModel.popularTVShows.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadPopularTVShows()
                }
            }
            return mediaViewModel.popularTVShows
        case .topRated:
            if mediaViewModel.topRatedTVShows.isEmpty {
                Task { @MainActor in
                    await mediaViewModel.loadTopRatedTVShows()
                }
            }
            return mediaViewModel.topRatedTVShows
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
                
                MoviesList(mediaViewModel: mediaViewModel, selectedMovieSection: selectedMovieSection, currentMovies: currentMovies)
                
                TVShowsList(mediaViewModel: mediaViewModel, selectedTVShowSection: selectedTVShowSection, currentTVShows: currentTVShows)

            }
            .onAppear {
                Task {
                    if mediaViewModel.popularMovies.isEmpty {
                        await mediaViewModel.loadPopularMovies()
                    }
                    if mediaViewModel.popularTVShows.isEmpty {
                        await mediaViewModel.loadTrendingMovies()
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView(mediaViewModel: MediaViewModel(
        favoritesRepo: FavoritesRepository(),
        sessionRepo: SessionRepository(),
        navigationService: Router()
    ))
}
