//
//  ContentView.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.popularMovies) { movie in
                Text(movie.title)
            }
            .navigationTitle("Popular Movies")
            .onAppear {
                viewModel.loadPopularMovies()
            }
        }
    }
}

#Preview {
    ContentView()
}
