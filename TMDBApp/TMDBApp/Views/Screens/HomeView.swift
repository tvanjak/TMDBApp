//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct HomeView: View {
    @Binding var path: NavigationPath

    
    @StateObject private var viewModel = MovieViewModel()
    @State private var searchTerm = ""
    
    @State private var isFavorite = false

    let columns = [GridItem(.adaptive(minimum: 120))]
    
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
                
//                MovieSection(title: "What's popular", popularMovies: viewModel.popularMovies) // doesnt work because it doesnt load the movies
                
                VStack (alignment: .leading) {
                    Text("What's popular")
                        .font(.title2)
                        .fontWeight(.bold)
                    HStack (spacing: 10) {
                            Text("Streaming")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("On TV")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            Text("For Rent")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                            Text("In Theatres")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10)
                    
                    
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(viewModel.popularMovies) { movie in
                                ZStack(alignment: .topLeading) {
                                    if let posterPath = movie.posterPath {
                                        let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                        if let url = URL(string: fullURLString) {
                                            AsyncImage(url: url, scale: 4) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    } else {
                                        // Handle no poster case, maybe show a placeholder image or empty view
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        isFavorite.toggle()
                                    }) {
                                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(isFavorite ? .red : .white)
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
                            ForEach(viewModel.trendingMovies) { movie in
                                ZStack(alignment: .topLeading) {
                                    if let posterPath = movie.posterPath {
                                        let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                                        if let url = URL(string: fullURLString) {
                                            AsyncImage(url: url, scale: 4) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .cornerRadius(10)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    } else {
                                        // Handle no poster case, maybe show a placeholder image or empty view
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        isFavorite.toggle()
                                    }) {
                                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(isFavorite ? .red : .white)
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


            }
            .onAppear {
                viewModel.loadPopularMovies()
                viewModel.loadTrendingMovies()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    @State static var path = NavigationPath()
    
    static var previews: some View {
        HomeView(path: $path)
    }
}

