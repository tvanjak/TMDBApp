//
//  HomeCards.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct MediaCard: View {
    let media: MediaItemViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let fullURLString = media.fullPosterPath {
                if let url = URL(string: fullURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 225)
                            .clipped()
                            .cornerRadius(AppTheme.Radius.medium)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 225)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 225)
                    .foregroundColor(.gray)
                    .cornerRadius(AppTheme.Radius.medium)
            }
            
            
            Button(action: {
                homeViewModel.toggleFavorite(media)
            }) {
                Image(systemName: homeViewModel.getFavoriteIcon(media))
                    .foregroundColor(homeViewModel.getFavoriteColor(media))
                    .padding(AppTheme.Spacing.small)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(AppTheme.Spacing.small)
        }
    }
}

