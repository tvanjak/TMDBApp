//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI


struct FavoritesView: View {
    @ObservedObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Favorites")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)
            if favoritesViewModel.favorites.isEmpty {
                Text("Your favorites list is currently empty")
                    .font(.subheadline)
                    .fontWeight(.thin)
                Spacer()
            } else {
                FavoritesList(favoritesViewModel: favoritesViewModel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    FavoritesView(favoritesViewModel: FavoritesViewModel(
        favoritesManager: FavoritesManager(favoritesRepo: FavoritesRepository(), authenticationRepo: AuthenticationRepository()),
        navigationService: Router()
    ))
}
