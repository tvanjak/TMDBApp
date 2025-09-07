
import SwiftUI
import Combine

@MainActor
final class MediaViewModel: ObservableObject {
    @Published var popularMovies: [MediaItem] = []
    @Published var trendingMovies: [MediaItem] = []
    @Published var upcomingMovies: [MediaItem] = []
    @Published var nowPlayingMovies: [MediaItem] = []
    
    @Published var popularTVShows: [MediaItem] = []
    @Published var topRatedTVShows: [MediaItem] = []
    
    @Published var errorMessage: String?
    @Published var mediaDetail: (any MediaItemDetails)?
    @Published var favorites: [MediaItem] = []
    
    private let favoritesManager: FavoritesManager
    private let navigationService: NavigationServiceProtocol
    
    init(
        favoritesManager: FavoritesManager,
        navigationService: NavigationServiceProtocol
    ) {
        self.favoritesManager = favoritesManager
        self.navigationService = navigationService
        
        // Observe FavoritesManager changes
        favoritesManager.$favorites
            .assign(to: &$favorites)
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
    
//    func loadMovieDetails(media: MediaItem) async {
//        do {
//            mediaDetail = nil
//            mediaDetail = try await TMDBService.shared.fetchDetails(media: media)
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
    
    func loadDetails(media: MediaType) async {
        do {
            switch media {
            case .movie(let id):
                let movie: any MediaItemDetails = try await TMDBService.shared.fetchDetails(for: .movie(id: id))
                self.mediaDetail = movie
                
            case .tvShow(let id):
                let tvShow: any MediaItemDetails = try await TMDBService.shared.fetchDetails(for: .tvShow(id: id))
                self.mediaDetail = tvShow
            }
        } catch {
            self.errorMessage = error.localizedDescription
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
