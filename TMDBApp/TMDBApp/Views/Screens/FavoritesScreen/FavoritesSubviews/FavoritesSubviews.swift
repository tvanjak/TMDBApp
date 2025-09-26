//
//  FavoritesSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


struct FavoriteCardView: View {
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    var media: MediaItemUI
    
    var body: some View {
//        Button(action: { mediaViewModel.navigateToMedia(media) }) {
            ZStack(alignment: .topLeading) {
                if let fullURLString = media.fullPosterPath {
                    if let url = URL(string: fullURLString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 115, height: 170)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 115, height: 170)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 115, height: 170)
                        .foregroundColor(.gray)
                        .cornerRadius(AppTheme.Radius.small)
                }
                
                Button(action: {
                    favoritesViewModel.toggleFavorite(media)
                }) {
                    Image(systemName: favoritesViewModel.getFavoriteIcon(media))
                        .foregroundColor(favoritesViewModel.getFavoriteColor(media))
                        .padding(AppTheme.Spacing.small)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(AppTheme.Spacing.small)
            }
//        }
    }
}

struct FavoritesList: View {
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    let columns = [GridItem(.adaptive(minimum: 115), spacing: AppTheme.Spacing.small)]

    var body: some View {
        ScrollView {
            LazyVGrid (columns: columns) {
                ForEach(favoritesViewModel.favorites) { media in
                    FavoriteCardView(favoritesViewModel: favoritesViewModel, media: media)
                }
            }
        }
    }
}
