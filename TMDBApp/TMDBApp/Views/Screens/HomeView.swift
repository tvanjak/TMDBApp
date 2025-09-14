//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @FocusState var searchFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                    
                    TextField("Search", text: $homeViewModel.searchTerm)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($searchFocused)
                        .onSubmit {
                            Task { await homeViewModel.search() }
                        }
                    
                    if searchFocused {
                        Button {
                            homeViewModel.searchTerm = ""
                            homeViewModel.searchedMovies = []
                            homeViewModel.searchedTVShows = []
                            searchFocused = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(AppTheme.Spacing.small)
                .frame(width: 360, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(AppTheme.Radius.small)
                .padding(.top)
                
                if searchFocused && homeViewModel.searchedMovies.isEmpty {
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
