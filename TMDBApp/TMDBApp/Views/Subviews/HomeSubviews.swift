//
//  HomeSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
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


struct MoviesList: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    @Binding var selectedMovieSection: HomeView.MovieSections
    var currentMovies: [MediaItem]
    
    var body: some View {
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
    }
}


struct TVShowsList: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    @Binding var selectedTVShowSection: HomeView.TVShowSections
    var currentTVShows: [MediaItem]
    
    var body: some View {
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
}
