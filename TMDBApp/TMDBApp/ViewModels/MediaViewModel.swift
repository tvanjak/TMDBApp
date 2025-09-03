
import SwiftUI

@MainActor
final class MovieViewModel: ObservableObject {
    @Published var popularMovies: [Movie] = []
    @Published var trendingMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    @Published var nowPlayingMovies: [Movie] = []
    
    @Published var popularTVShows: [TVShow] = []
    @Published var topRatedTVShows: [TVShow] = []
    
    @Published var errorMessage: String?
    @Published var movieDetail: MovieDetails? = nil
    
    @Published var favorites: [Movie] = []
    
    private let favoritesRepo: FavoritesRepositoryProtocol
    private let sessionRepo: SessionRepositoryProtocol
    private let navigationService: NavigationServiceProtocol
    
    init(
        favoritesRepo: FavoritesRepositoryProtocol,
        sessionRepo: SessionRepositoryProtocol,
        navigationService: NavigationServiceProtocol
    ) {
        self.favoritesRepo = favoritesRepo
        self.sessionRepo = sessionRepo
        self.navigationService = navigationService
        loadFavorites()
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    private func loadFavorites() {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites = favoritesRepo.loadFavorites(for: uid)
    }
    
    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFavorite(movie)
        } else {
            addFavorite(movie)
        }
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }
    
    func getFavoriteIcon(_ movie: Movie) -> String {
        return isFavorite(movie) ? "heart.fill" : "heart"
    }
    
    func getFavoriteColor(_ movie: Movie) -> Color {
        return isFavorite(movie) ? .red : .white
    }
    
    private func addFavorite(_ movie: Movie) {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites.append(movie)
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
    
    private func removeFavorite(_ movie: Movie) {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites.removeAll { $0.id == movie.id }
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
    // ------------------------------------------------------------

    
    // MOVIE LOADING FUNCTIONS -------------------------------
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
            movieDetail = nil
            movieDetail = try await TMDBService.shared.fetchMovieDetails(movieId: movieId)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

    
    // ROUTER FUNCTIONS
    func navigateToMovie(_ movieId: Int) {
        navigationService.navigateToMovie(movieId)
    }
    
    func goBack() {
        navigationService.goBack()
    }
    
    func canGoBack() -> Bool {
        return navigationService.canGoBack()
    }
    // ------------------------------------------------------------
    
    
    // TVShow FUNCTIONS
    func loadPopularTVShows() async {
        do {
            popularTVShows = try await TMDBService.shared.fetchPopularTVShows()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadTopRatedTVShows() async {
        do {
            topRatedTVShows = try await TMDBService.shared.fetchTopRatedTVShows()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

}
