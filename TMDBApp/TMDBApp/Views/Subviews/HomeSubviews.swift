//
//  HomeSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


struct MediaItemCard: View {
    let mediaItem: MediaItem
    @ObservedObject var homeViewModel: HomeViewModel
    
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
                homeViewModel.toggleFavorite(mediaItem)
            }) {
                Image(systemName: homeViewModel.getFavoriteIcon(mediaItem))
                    .foregroundColor(homeViewModel.getFavoriteColor(mediaItem))
                    .padding(AppTheme.Spacing.small)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(AppTheme.Spacing.small)
        }
    }
}


struct MoviesList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading, spacing: 0){
                Text("Movies")
                    .font(AppTheme.Typography.title)
                    .fontWeight(.bold)
                SectionsBar(selectedSection: $homeViewModel.selectedMovieSection) { section in
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
                    ForEach(homeViewModel.currentMovies, id: \.id) { movie in
                        Button(action: { homeViewModel.navigateToMedia(MediaType.movie(id: movie.id)) }) {
                            MediaItemCard(mediaItem: movie, homeViewModel: homeViewModel)
                        }
                    }
                }
            }
        }
        .padding()
    }
}


struct TVShowsList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading, spacing: 0){
                Text("TV Shows")
                    .font(AppTheme.Typography.title)
                    .fontWeight(.bold)
                SectionsBar(selectedSection: $homeViewModel.selectedTVShowSection) { section in
                    switch section {
                    case .popular: "Popular"
                    case .topRated: "Top Rated"
                    }
                }
            }
            ScrollView (.horizontal) {
                LazyHStack {
                    ForEach(homeViewModel.currentTVShows, id: \.id) { tvShow in
                        Button(action: { homeViewModel.navigateToMedia(MediaType.tvShow(id: tvShow.id)) }) {
                            MediaItemCard(mediaItem: tvShow, homeViewModel: homeViewModel)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
