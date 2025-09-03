//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct MediaItemCard: View {
    let mediaItem: MediaItem
    @ObservedObject var mediaViewModel: MediaViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
                if let posterPath = mediaItem.posterPath {
                    let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                    if let url = URL(string: fullURLString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 225)
                                .clipped()
                                .cornerRadius(AppTheme.Radius.medium)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 150, height: 225)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 225)
                        .foregroundColor(.gray)
                        .cornerRadius(AppTheme.Radius.medium)
                }
            
            
            Button(action: {
                mediaViewModel.toggleFavorite(mediaItem)
            }) {
                Image(systemName: mediaViewModel.getFavoriteIcon(mediaItem))
                    .foregroundColor(mediaViewModel.getFavoriteColor(mediaItem))
                    .padding(AppTheme.Spacing.small)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(AppTheme.Spacing.small)
        }
    }
}



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
                
                VStack (alignment: .leading) {
                    VStack (alignment: .leading, spacing: 0){
                        Text("Movies")
                            .font(AppTheme.Typography.title)
                            .fontWeight(.bold)
                        SectionsBar(selectedSection: $selectedMovieSection) { section in
                            switch section {
                            case .popular: "Popular"
                            case .trending: "Trending"
                            case .nowPlaying: "Now Playing"
                            case .upcoming: "Upcoming"
                            }
                        }
                    }
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(currentMovies) { movie in
                                Button(action: { mediaViewModel.navigateToMedia(MediaType.movie(id: movie.id)) }) {
                                    MediaItemCard(mediaItem: movie, mediaViewModel: mediaViewModel)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                VStack (alignment: .leading) {
                    VStack (alignment: .leading, spacing: 0){
                        Text("TV Shows")
                            .font(AppTheme.Typography.title)
                            .fontWeight(.bold)
                        SectionsBar(selectedSection: $selectedTVShowSection) { section in
                            switch section {
                            case .popular: "Popular"
                            case .topRated: "Top Rated"
                            }
                        }
                    }
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(currentTVShows) { tvShow in
                                Button(action: { mediaViewModel.navigateToMedia(MediaType.tvShow(id: tvShow.id)) }) {
                                    MediaItemCard(mediaItem: tvShow, mediaViewModel: mediaViewModel)
                                }
                            }
                        }
                    }
                }
                .padding()


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
