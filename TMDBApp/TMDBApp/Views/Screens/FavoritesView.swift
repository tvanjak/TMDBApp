//
//  FavoritesView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 13.08.2025..
//

import SwiftUI

struct FavoriteCardView: View {
    @ObservedObject var movieViewModel: MovieViewModel
    var movie: Movie
    
    var body: some View {
        Button(action: { movieViewModel.navigateToMovie(movie.id) }) {
            ZStack(alignment: .topLeading) {
                if let fullURLString = movie.fullPosterPath {
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
                    movieViewModel.toggleFavorite(movie)
                }) {
                    Image(systemName: movieViewModel.getFavoriteIcon(movie))
                        .foregroundColor(movieViewModel.getFavoriteColor(movie))
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(8)
            }
        }
    }
}

struct FavoritesList: View {
    @ObservedObject var movieViewModel: MovieViewModel
    let columns = [GridItem(.adaptive(minimum: 115), spacing: 10)]

    var body: some View {
        ScrollView {
            LazyVGrid (columns: columns) {
                ForEach(movieViewModel.favorites) { movie in
                    FavoriteCardView(movieViewModel: movieViewModel, movie: movie)
                }
            }
        }
    }
}


struct FavoritesView: View {
    @ObservedObject var movieViewModel: MovieViewModel

    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Favorites")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical)
            if movieViewModel.favorites.isEmpty {
                Text("Your favorites list is currently empty")
                    .font(.subheadline)
                    .fontWeight(.thin)
                Spacer()
            } else {
                FavoritesList(movieViewModel: movieViewModel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    FavoritesView(movieViewModel: MovieViewModel(
        favoritesRepo: FavoritesRepository(),
        sessionRepo: SessionRepository(),
        navigationService: Router()
    ))
}
