
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var popularMovies: [MediaItem] = []
    @Published var trendingMovies: [MediaItem] = []
    @Published var upcomingMovies: [MediaItem] = []
    @Published var nowPlayingMovies: [MediaItem] = []
    
    @Published var popularTVShows: [MediaItem] = []
    @Published var topRatedTVShows: [MediaItem] = []

    @Published var searchedMovies: [MediaItem] = []
    @Published var searchedTVShows: [MediaItem] = []

    @Published var searchTerm = ""
    
    enum MovieSections: CaseIterable, Hashable {
        case popular
        case trending
        case upcoming
        case nowPlaying
    }
    @Published var selectedMovieSection: MovieSections = .popular {
        didSet {
            updateCurrentMovies()
        }
    }
    
    enum TVShowSections: CaseIterable, Hashable {
        case popular
        case topRated
    }
    @Published var selectedTVShowSection: TVShowSections = .popular {
        didSet {
            updateCurrentTVShows()
        }
    }
    
    @Published var currentMovies: [MediaItem] = []
    @Published var currentTVShows: [MediaItem] = []
    
    @Published var errorMessage: String?
    @Published var favorites: [MediaItem] = []
    
    private let favoritesManager: FavoritesManager
    private let navigationService: NavigationViewModelProtocol
    
    init(
        favoritesManager: FavoritesManager,
        navigationService: NavigationViewModelProtocol
    ) {
        self.favoritesManager = favoritesManager
        self.navigationService = navigationService
        
        // Observe FavoritesManager changes
        favoritesManager.$favorites
            .assign(to: &$favorites)
        
        // Initialize current arrays and load data
        Task { @MainActor in
            await loadPopularMovies()
            await loadPopularTVShows()
        }
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItem) {
        favoritesManager.toggleFavorite(media)
    }
    
    func isFavorite(_ media: MediaItem) -> Bool {
        return favoritesManager.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItem) -> String {
        return favoritesManager.getFavoriteIcon(media)
    }
    
    func getFavoriteColor(_ media: MediaItem) -> Color {
        return favoritesManager.getFavoriteColor(media)
    }
    // ------------------------------------------------------------
    
    // UPDATE CURRENT ARRAYS -------------------------------
    private func updateCurrentMovies() {
        switch selectedMovieSection {
        case .popular:
            currentMovies = popularMovies
            if popularMovies.isEmpty {
                Task { @MainActor in
                    await loadPopularMovies()
                }
            }
        case .trending:
            currentMovies = trendingMovies
            if trendingMovies.isEmpty {
                Task { @MainActor in
                    await loadTrendingMovies()
                }
            }
        case .upcoming:
            currentMovies = upcomingMovies
            if upcomingMovies.isEmpty {
                Task { @MainActor in
                    await loadUpcomingMovies()
                }
            }
        case .nowPlaying:
            currentMovies = nowPlayingMovies
            if nowPlayingMovies.isEmpty {
                Task { @MainActor in
                    await loadNowPlayingMovies()
                }
            }
        }
    }
    
    private func updateCurrentTVShows() {
        switch selectedTVShowSection {
        case .popular:
            currentTVShows = popularTVShows
            if popularTVShows.isEmpty {
                Task { @MainActor in
                    await loadPopularTVShows()
                }
            }
        case .topRated:
            currentTVShows = topRatedTVShows
            if topRatedTVShows.isEmpty {
                Task { @MainActor in
                    await loadTopRatedTVShows()
                }
            }
        }
    }
    // ------------------------------------------------------------

    
    // MOVIE LOADING FUNCTIONS -------------------------------
    func loadPopularMovies() async {
        do {
            popularMovies = try await TMDBService.shared.fetchPopularMovies()
            if selectedMovieSection == .popular {
                currentMovies = popularMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadTrendingMovies() async {
        do {
            trendingMovies = try await TMDBService.shared.fetchTrendingMovies()
            if selectedMovieSection == .trending {
                currentMovies = trendingMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadUpcomingMovies() async {
        do {
            upcomingMovies = try await TMDBService.shared.fetchUpcomingMovies()
            if selectedMovieSection == .upcoming {
                currentMovies = upcomingMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadNowPlayingMovies() async {
        do {
            nowPlayingMovies = try await TMDBService.shared.fetchNowPlayingMovies()
            if selectedMovieSection == .nowPlaying {
                currentMovies = nowPlayingMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

    
    // ROUTER FUNCTIONS
    func navigateToMedia(_ media: MediaType) {
        navigationService.navigateToMedia(media)
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
            if selectedTVShowSection == .popular {
                currentTVShows = popularTVShows
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadTopRatedTVShows() async {
        do {
            topRatedTVShows = try await TMDBService.shared.fetchTopRatedTVShows()
            if selectedTVShowSection == .topRated {
                currentTVShows = topRatedTVShows
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

    // SEARCH FUNCTION
    func search() async {
        do {
            searchedMovies = try await TMDBService.shared.fetchSearchedMovies(query: searchTerm)
            searchedTVShows = try await TMDBService.shared.fetchSearchedTVShows(query: searchTerm)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
