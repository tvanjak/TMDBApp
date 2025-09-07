//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI


struct FavoritesView: View {
    @ObservedObject var mediaViewModel: MediaViewModel

    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Favorites")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)
            if mediaViewModel.favorites.isEmpty {
                Text("Your favorites list is currently empty")
                    .font(.subheadline)
                    .fontWeight(.thin)
                Spacer()
            } else {
                FavoritesList(mediaViewModel: mediaViewModel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    FavoritesView(mediaViewModel: MediaViewModel(
        favoritesRepo: FavoritesRepository(),
        sessionRepo: SessionRepository(),
        navigationService: Router()
    ))
}
