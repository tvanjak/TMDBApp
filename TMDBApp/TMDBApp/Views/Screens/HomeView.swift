//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {    
    @ObservedObject var movieViewModel: MovieViewModel
    @ObservedObject var tvShowViewModel: TVShowViewModel

    @EnvironmentObject var authVM: AuthenticationViewModel

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
                
//                MovieSection(title: "What's popular", popularMovies: viewModel.popularMovies) // doesnt work because it doesnt load the movies
                
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
                                    NavigationLink(value:  movie.id) {
                                        if let posterPath = movie.posterPath {
                                            let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                            if let url = URL(string: fullURLString) {
                                                AsyncImage(url: url, scale: 4) { image in
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
                                NavigationLink(value: movie.id) {
                                    ZStack(alignment: .topLeading) {
                                        if let posterPath = movie.posterPath {
                                            let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                            if let url = URL(string: fullURLString) {
                                                AsyncImage(url: url, scale: 4) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 150, height: 225)
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
                .padding()


            }
            .onAppear {
                if movieViewModel.popularMovies.isEmpty {
                    movieViewModel.loadPopularMovies()
                }
                if movieViewModel.trendingMovies.isEmpty {
                    movieViewModel.loadTrendingMovies()
                }
            }
        }
    }
}


#Preview {
    HomeView(movieViewModel: MovieViewModel(), tvShowViewModel: TVShowViewModel())
        .environmentObject(AuthenticationViewModel())
}

