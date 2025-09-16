//
//  SearchBar.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            
            TextField("Search", text: $homeViewModel.searchTerm)
                .textFieldStyle(PlainTextFieldStyle())
                .focused(homeViewModel.$searchFocused)
                .onSubmit {
                    Task { await homeViewModel.search() }
                }
            
            if homeViewModel.searchFocused {
                Button {
                    homeViewModel.searchTerm = ""
                    homeViewModel.searchedMovies = []
                    homeViewModel.searchedTVShows = []
                    homeViewModel.searchFocused = false
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
    }
}
