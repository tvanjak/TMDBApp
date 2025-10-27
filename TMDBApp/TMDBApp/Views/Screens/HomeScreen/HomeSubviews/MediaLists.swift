//
//  HomeCards.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

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
                            MediaCard(media: movie, homeViewModel: homeViewModel)
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
                            MediaCard(media: tvShow, homeViewModel: homeViewModel)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
