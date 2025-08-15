
import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var errorMessage: String?

    func loadPopularMovies() {
        TMDBService.shared.fetchPopularMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.popularMovies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loadTrendingMovies() {
        TMDBService.shared.fetchTrendingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.trendingMovies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
