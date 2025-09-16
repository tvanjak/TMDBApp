//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                SearchBar(homeViewModel: homeViewModel)
                
                if homeViewModel.searchFocused && homeViewModel.searchedMovies.isEmpty {
                    EmptyView()
                } else if !homeViewModel.searchedMovies.isEmpty || !homeViewModel.searchedTVShows.isEmpty {
                    SearchMoviesList(homeViewModel: homeViewModel)
                    SearchTVShowsList(homeViewModel: homeViewModel)
                } else {
                    MoviesList(homeViewModel: homeViewModel)
                    TVShowsList(homeViewModel: homeViewModel)
                }
                
            }
            .onAppear {
                // Data loading is now handled in ViewModel initialization
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
