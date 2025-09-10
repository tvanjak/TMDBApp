//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var homeViewModel: HomeViewModel

    @State private var searchTerm = ""
    
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
                
                MoviesList(homeViewModel: homeViewModel)
                
                TVShowsList(homeViewModel: homeViewModel)

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
