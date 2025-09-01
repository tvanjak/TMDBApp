//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var movieViewModel: MovieViewModel
    
    @State private var searchTerm = ""
        
    enum movieTypes {
        case streaming
        case onTV
        case forRent
        case inTheatres
    }
    
    @State var selectedMovieType: movieTypes = movieTypes.streaming
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                    
                    TextField("Search", text: $searchTerm)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .frame(width: 360, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.top)
                
                
                VStack (alignment: .leading) {
                    Text("What's popular")
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack (spacing: 10) {
                        Button() {
                            
                        } label: {
                            Text("Streaming")
                                .font(.title3)
                                .foregroundStyle(.black)
                        }
                        Button() {
                            
                        } label: {
                            Text("On TV")
                                .font(.title3)
                                .foregroundStyle(.gray)
                        }
                        Button() {
                            
                        } label: {
                            Text("For Rent")
                                .font(.title3)
                                .foregroundStyle(.gray)
                        }
                        Button() {
                            
                        } label: {
                            Text("In Theatres")
                                .font(.title3)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(movieViewModel.popularMovies) { movie in
                                ZStack(alignment: .topLeading) {
                                    Button(action: { movieViewModel.navigateToMovie(movie.id) }) {
                                        if let fullURLString = movie.fullPosterPath {
                                            if let url = URL(string: fullURLString) {
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 225)
                                                        .clipped()
                                                        .cornerRadius(10)
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
                                                .cornerRadius(10)
                                        }
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
                }
                .padding()
                
                VStack (alignment: .leading) {
                    Text("Trending")
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack (spacing: 10) {
                            Text("Today")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("This week")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(movieViewModel.trendingMovies) { movie in
                                Button(action: { movieViewModel.navigateToMovie(movie.id) }) {
                                    ZStack(alignment: .topLeading) {
                                        if let fullURLString = movie.fullPosterPath {
                                            if let url = URL(string: fullURLString) {
                                                AsyncImage(url: url) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 225)
                                                        .clipped()
                                                        .cornerRadius(10)
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
                    }
                }
                .padding()


            }
            .onAppear {
                Task {
                    if movieViewModel.popularMovies.isEmpty {
                        await movieViewModel.loadPopularMovies()
                    }
                    if movieViewModel.trendingMovies.isEmpty {
                        await movieViewModel.loadTrendingMovies()
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView(movieViewModel: MovieViewModel(
        favoritesRepo: FavoritesRepository.shared,
        sessionRepo: SessionRepository.shared,
        navigationService: Router()
    ))
}
