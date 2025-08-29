
import SwiftUI

@MainActor
class MovieViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []
    @Published var errorMessage: String?
    @Published var movieDetail: MovieDetails? = nil

    func loadPopularMovies() async {
        do {
            popularMovies = try await TMDBService.shared.fetchPopularMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadTrendingMovies() async {
        do {
            trendingMovies = try await TMDBService.shared.fetchTrendingMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadUpcomingMovies() async {
        do {
            upcomingMovies = try await TMDBService.shared.fetchUpcomingMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadNowPlayingMovies() async {
        do {
            nowPlayingMovies = try await TMDBService.shared.fetchNowPlayingMovies()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadMovieDetails(movieId: Int) async {
        do {
            movieDetail = try await TMDBService.shared.fetchMovieDetails(movieId: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
