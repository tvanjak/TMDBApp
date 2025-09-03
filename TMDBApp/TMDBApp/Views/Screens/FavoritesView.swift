//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI

struct FavoriteCardView: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    var media: MediaItem
    
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
                    mediaViewModel.toggleFavorite(media)
                }) {
                    Image(systemName: mediaViewModel.getFavoriteIcon(media))
                        .foregroundColor(mediaViewModel.getFavoriteColor(media))
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
    @ObservedObject var mediaViewModel: MediaViewModel
    let columns = [GridItem(.adaptive(minimum: 115), spacing: AppTheme.Spacing.small)]

    var body: some View {
        ScrollView {
            LazyVGrid (columns: columns) {
                ForEach(mediaViewModel.favorites) { media in
                    FavoriteCardView(mediaViewModel: mediaViewModel, media: media)
                }
            }
        }
    }
}


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
