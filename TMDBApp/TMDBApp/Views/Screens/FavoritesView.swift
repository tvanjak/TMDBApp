//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI

struct FavoriteItemCard: View {
    let mediaItem: MediaItem
    @EnvironmentObject var authVM: AuthenticationViewModel

    var body: some View {
        NavigationLink(value: mediaItem.id) {
            ZStack(alignment: .topLeading) {
                if let posterPath = mediaItem.posterPath {
                    let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                    if let url = URL(string: fullURLString) {
                        AsyncImage(url: url, scale: 4) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 115, height: 170)
                                .cornerRadius(AppTheme.Radius.medium)
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
                        .cornerRadius(AppTheme.Radius.medium)
                }
                
                Button(action: {
                    if authVM.isFavorite(mediaItem) {
                        authVM.removeFavorite(mediaItem)
                    } else {
                        authVM.addFavorite(mediaItem)
                    }
                }) {
                    Image(systemName: authVM.isFavorite(mediaItem) ? "heart.fill" : "heart")
                        .foregroundColor(authVM.isFavorite(mediaItem) ? .red : .white)
                        .padding(AppTheme.Spacing.small)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(AppTheme.Spacing.small)
            }
        }
    }
}

struct FavoritesView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    let columns = [GridItem(.adaptive(minimum: 115), spacing: AppTheme.Spacing.small)]

    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Favorites")
                .font(AppTheme.Typography.title)
                .fontWeight(.bold)
                .padding(.vertical)
            if authVM.favorites.isEmpty {
                Text("Your favorites list is currently empty")
                    .font(AppTheme.Typography.body)
                    .fontWeight(.thin)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid (columns: columns) {
                        ForEach(authVM.favorites) { mediaItem in
                            FavoriteItemCard(mediaItem: mediaItem)
                                .environmentObject(authVM)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AuthenticationViewModel())
}
