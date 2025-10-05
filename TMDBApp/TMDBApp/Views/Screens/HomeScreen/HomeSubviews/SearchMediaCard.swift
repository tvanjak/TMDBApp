//
//  HomeCards.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct SearchMediaCard: View {
    var media: MediaItemViewModel
    
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: AppTheme.Radius.large)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: AppTheme.Radius.small)
                .frame(width: 330, height: 180)
            
            HStack() {
                if let fullURLString = media.fullPosterPath {
                    if let url = URL(string: fullURLString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 180)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                                .frame(width: 120, height: 180)
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 180)
                        .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(media.displayTitle)
                            .font(AppTheme.Typography.subtitle)
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Text("(" + media.releaseYear + ")")
                            .font(AppTheme.Typography.subtitle)
                            .foregroundStyle(.black)
                            .bold()
                            .multilineTextAlignment(.leading)
                    }
                    Text(media.overview ?? "No overview")
                        .font(AppTheme.Typography.body2)
                        .foregroundStyle(.black)
                        .lineLimit(5)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                }
                .padding(AppTheme.Spacing.small)
                .frame(width: 210, height: 180)
            }
            .frame(height: 180)
            .clipShape(
                RoundedRectangle(cornerRadius: AppTheme.Radius.large)
            )
            .padding(AppTheme.Spacing.small)
        }
    }
}
