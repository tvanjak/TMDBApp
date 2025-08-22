//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    let columns = [GridItem(.adaptive(minimum: 115), spacing: 10)]

    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Favorites")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)
            if authVM.favorites.isEmpty {
                Text("Your favorites list is currently empty")
                    .font(.subheadline)
                    .fontWeight(.thin)
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid (columns: columns) {
                        ForEach(authVM.favorites) { movie in
                            NavigationLink(value: movie.id) {
                                ZStack(alignment: .topLeading) {
                                    if let posterPath = movie.posterPath {
                                        let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                        if let url = URL(string: fullURLString) {
                                            AsyncImage(url: url, scale: 4) { image in
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
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        if authVM.isFavorite(movie) {
                                            authVM.removeFavorite(movie)
                                        } else {
                                            authVM.addFavorite(movie)
                                        }
                                    }) {
                                        Image(systemName: authVM.isFavorite(movie) ? "heart.fill" : "heart")
                                            .foregroundColor(authVM.isFavorite(movie) ? .red : .white)
                                            .padding(8)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    }
                                    .padding(8)
                                }
                            }
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
