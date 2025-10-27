//
//  SearchLists.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct SearchMoviesList: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Movies")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
            ScrollView (.horizontal) {
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
            ScrollView (.horizontal) {
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
