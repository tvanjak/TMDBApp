//
//  HomePage.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI


struct MovieSectionsBar: View {
    @Binding var selectedSection: HomeView.MovieTypes
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("Movies")
                .font(.title2)
                .fontWeight(.bold)
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (alignment: .top, spacing: 20) {
                    VStack (alignment: .center) {
                        Button() {
                            selectedSection = .popular
                        } label: {
                            Text("Popular")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == .popular ? .bold : .thin)
                        }
                        if selectedSection == .popular {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 4)
                        }
                    }
                    VStack (alignment: .center) {
                        Button() {
                            selectedSection = .trending
                        } label: {
                            Text("Trending")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == .trending ? .bold : .thin)
                        }
                        if selectedSection == .trending {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 4)
                        }
                    }
                    VStack (alignment: .center) {
                        Button() {
                            selectedSection = .upcoming
                        } label: {
                            Text("Upcoming")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == .upcoming ? .bold : .thin)
                        }
                        if selectedSection == .upcoming {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 4)
                        }
                    }
                    VStack (alignment: .center) {
                        Button() {
                            selectedSection = .nowPlaying
                        } label: {
                            Text("Now Playing")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == .nowPlaying ? .bold : .thin)
                        }
                        if selectedSection == .nowPlaying {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 4)
                        }
                    }
                }
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical)
            }
        }
    }
}


struct TVShowSectionsBar: View {
    @Binding var selectedSection: HomeView.TVShowTypes
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("TV Shows")
                .font(.title2)
                .fontWeight(.bold)
            HStack (alignment: .top, spacing: 20) {
                VStack (alignment: .center) {
                    Button() {
                        selectedSection = .popular
                    } label: {
                        Text("Popular")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .fontWeight(selectedSection == .popular ? .bold : .thin)
                    }
                    if selectedSection == .popular {
                        Rectangle()
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                    }
                }
                VStack (alignment: .center) {
                    Button() {
                        selectedSection = .topRated
                    } label: {
                        Text("Top Rated")
                            .font(.title3)
                            .foregroundStyle(.black)
                            .fontWeight(selectedSection == .topRated ? .bold : .thin)
                    }
                    if selectedSection == .topRated {
                        Rectangle()
                            .frame(height: 4)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical)
        }
    }
}



struct MediaItemCard: View {
    let mediaItem: MediaItem
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
                if let posterPath = mediaItem.posterPath {
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
            
            
            Button(action: {
                if authVM.isFavorite(mediaItem) {
                    authVM.removeFavorite(mediaItem)
                } else {
                    authVM.addFavorite(mediaItem)
                }
            }) {
                Image(systemName: authVM.isFavorite(mediaItem) ? "heart.fill" : "heart")
                    .foregroundColor(authVM.isFavorite(mediaItem) ? .red : .white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(8)
        }
    }
}



struct HomeView: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    
    @EnvironmentObject var authVM: AuthenticationViewModel

    @State private var searchTerm = ""
        
    enum MovieTypes {
        case popular
        case trending
        case upcoming
        case nowPlaying
    }
    @State private var selectedMovieType: MovieTypes = .popular
    
    
    enum TVShowTypes {
        case popular
        case topRated
    }
    @State private var selectedTVShowType: TVShowTypes = .popular
    
    var currentMovies: [MediaItem] {
        switch selectedMovieType {
        case .popular: 
            if mediaViewModel.popularMovies.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadPopularMovies()
                }
            }
            return mediaViewModel.popularMovies
        case .trending:
            if mediaViewModel.trendingMovies.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadTrendingMovies()
                }
            }
            return mediaViewModel.trendingMovies
        case .upcoming:
            if mediaViewModel.upcomingMovies.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadUpcomingMovies()
                }
            }
            return mediaViewModel.upcomingMovies
        case .nowPlaying:
            if mediaViewModel.nowPlayingMovies.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadNowPlayingMovies()
                }
            }
            return mediaViewModel.nowPlayingMovies
        }
    }

    var currentTVShows: [MediaItem] {
        switch selectedTVShowType {
        case .popular:
            if mediaViewModel.popularTVShows.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadPopularTVShows()
                }
            }
            return mediaViewModel.popularTVShows
        case .topRated:
            if mediaViewModel.topRatedTVShows.isEmpty {
                Task { @MainActor in
                    mediaViewModel.loadTopRatedTVShows()
                }
            }
            return mediaViewModel.topRatedTVShows
        }
    }
    
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
                    MovieSectionsBar(selectedSection: $selectedMovieType)
                    
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(currentMovies) { movie in
                                NavigationLink(value: MediaType.movie(id: movie.id)) {
                                    MediaItemCard(mediaItem: movie)
                                        .environmentObject(authVM)
                                }
                            }
                        }
                    }
                }
                .padding()
                
                VStack (alignment: .leading) {
                    TVShowSectionsBar(selectedSection: $selectedTVShowType)
                    
                    ScrollView (.horizontal) {
                        LazyHStack {
                            ForEach(currentTVShows) { tvShow in
                                NavigationLink(value: MediaType.tvShow(id: tvShow.id)) {
                                    MediaItemCard(mediaItem: tvShow)
                                        .environmentObject(authVM)
                                }
                            }
                        }
                    }
                }
                .padding()


            }
            .onAppear {
                // Data for the default selected section
                if mediaViewModel.popularMovies.isEmpty {
                    Task { @MainActor in
                        mediaViewModel.loadPopularMovies()
                    }
                }
                if mediaViewModel.popularTVShows.isEmpty {
                    Task { @MainActor in
                        mediaViewModel.loadPopularTVShows()
                    }
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        HomeView(mediaViewModel: MediaViewModel())
            .environmentObject(AuthenticationViewModel())
    }
}

