//
//  HomeSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


struct MediaItemCard: View {
    let media: MediaItem
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let fullURLString = media.fullPosterPath {
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
                homeViewModel.toggleFavorite(media)
            }) {
                Image(systemName: homeViewModel.getFavoriteIcon(media))
                    .foregroundColor(homeViewModel.getFavoriteColor(media))
                    .padding(AppTheme.Spacing.small)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(AppTheme.Spacing.small)
        }
    }
}


struct SearchMediaCard: View {
    var media: MediaItem
    
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: AppTheme.Radius.small)
                .frame(width: 330, height: 180)
            
            HStack(spacing: 0) {
                if let fullURLString = media.fullPosterPath {
                    if let url = URL(string: fullURLString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 180)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 120, height: 180)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 180)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading/*, spacing: AppTheme.Spacing.small*/) {
                    Text(media.displayTitle)
                        .font(AppTheme.Typography.subtitle)
                        .foregroundStyle(.black)
                        .bold()
                        .multilineTextAlignment(.leading)
                    
                    Text(media.overview ?? "No overview")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.black)
                        .lineLimit(5)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                }
                .frame(width: 210, height: 180)
                .padding(AppTheme.Spacing.medium)
            }
            .frame(height: 180)
            .clipShape(
                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
            )
            .padding(AppTheme.Spacing.small)
        }
    }
}

struct SearchMoviesList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Movies")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack (spacing: AppTheme.Spacing.medium) {
                    ForEach(homeViewModel.searchedMovies, id: \.id) { movie in
                        Button(action: { homeViewModel.navigateToMedia(MediaType.movie(id: movie.id)) }) {
                            SearchMediaCard(media: movie)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct SearchTVShowsList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("TVShows")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
            ScrollView (.horizontal, showsIndicators: false) {
                LazyHStack (spacing: AppTheme.Spacing.medium) {
                    ForEach(homeViewModel.searchedTVShows, id: \.id) { tvShow in
                        Button(action: { homeViewModel.navigateToMedia(MediaType.tvShow(id: tvShow.id)) }) {
                            SearchMediaCard(media: tvShow)
                        }
                    }
                }
            }
        }
        .padding()
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
                            MediaItemCard(media: movie, homeViewModel: homeViewModel)
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
                            MediaItemCard(media: tvShow, homeViewModel: homeViewModel)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
