
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var popularMovies: [MediaItemViewModel] = []
    @Published var trendingMovies: [MediaItemViewModel] = []
    @Published var upcomingMovies: [MediaItemViewModel] = []
    @Published var nowPlayingMovies: [MediaItemViewModel] = []
    
    @Published var popularTVShows: [MediaItemViewModel] = []
    @Published var topRatedTVShows: [MediaItemViewModel] = []

    @Published var searchedMovies: [MediaItemViewModel] = []
    @Published var searchedTVShows: [MediaItemViewModel] = []

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
    
    @Published var currentMovies: [MediaItemViewModel] = []
    @Published var currentTVShows: [MediaItemViewModel] = []
    
    @Published var errorMessage: String?
    @Published var favorites: [MediaItemViewModel] = []
    
    private let favoritesViewModel: FavoritesViewModel
    private let navigationService: NavigationViewModelProtocol
    private let mediaRepo: MediaRepositoryProtocol
    
    init(
        favoritesViewModel: FavoritesViewModel,
        navigationService: NavigationViewModelProtocol,
        mediaRepo: MediaRepositoryProtocol
    ) {
        self.favoritesViewModel = favoritesViewModel
        self.navigationService = navigationService
        self.mediaRepo = mediaRepo
        
        // Observe FavoritesManager changes
        favoritesViewModel.$favorites
            .assign(to: &$favorites)
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItemViewModel) {
        favoritesViewModel.toggleFavorite(media)
    }
    
    func isFavorite(_ media: MediaItemViewModel) -> Bool {
        return favoritesViewModel.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItemViewModel) -> String {
        return favoritesViewModel.getFavoriteIcon(media)
    }
    
    func getFavoriteColor(_ media: MediaItemViewModel) -> Color {
        return favoritesViewModel.getFavoriteColor(media)
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

    
    // MOVIE LOADING FUNCTIONS ------------------------------------
    func loadPopularMovies() async {
        do {
            let dtoData = try await mediaRepo.fetchPopularMovies()
            popularMovies = dtoData.map(MediaItemViewModel.init)
            
            if selectedMovieSection == .popular {
                currentMovies = popularMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadTrendingMovies() async {
        do {
            let dtoData = try await mediaRepo.fetchTrendingMovies()
            trendingMovies = dtoData.map(MediaItemViewModel.init)

            if selectedMovieSection == .trending {
                currentMovies = trendingMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadUpcomingMovies() async {
        do {
            let dtoData = try await mediaRepo.fetchUpcomingMovies()
            upcomingMovies = dtoData.map(MediaItemViewModel.init)
            
            if selectedMovieSection == .upcoming {
                currentMovies = upcomingMovies
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadNowPlayingMovies() async {
        do {
            let dtoData = try await mediaRepo.fetchNowPlayingMovies()
            nowPlayingMovies = dtoData.map(MediaItemViewModel.init)
            
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
            let dtoData = try await mediaRepo.fetchPopularTVShows()
            popularTVShows = dtoData.map(MediaItemViewModel.init)
            
            if selectedTVShowSection == .popular {
                currentTVShows = popularTVShows
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func loadTopRatedTVShows() async {
        do {
            let dtoData = try await mediaRepo.fetchTopRatedTVShows()
            topRatedTVShows = dtoData.map(MediaItemViewModel.init)
            
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
            let dtoData1 = try await mediaRepo.fetchSearchedMovies(query: searchTerm)
            searchedMovies = dtoData1.map(MediaItemViewModel.init)
            
            let dtoData2 = try await mediaRepo.fetchSearchedTVShows(query: searchTerm)
            searchedTVShows = dtoData2.map(MediaItemViewModel.init)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
