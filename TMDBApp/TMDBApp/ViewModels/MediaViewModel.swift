
import SwiftUI

@MainActor
class MediaViewModel: ObservableObject {
    @Published var popularMovies: [MediaItem] = []
    @Published var trendingMovies: [MediaItem] = []
    @Published var upcomingMovies: [MediaItem] = []
    @Published var nowPlayingMovies: [MediaItem] = []
    @Published var popularTVShows: [MediaItem] = []
    @Published var topRatedTVShows: [MediaItem] = []
    @Published var errorMessage: String?
    @Published var mediaDetail: (any MediaItemDetails)?

    // MOVIES
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

    func loadUpcomingMovies() {
        TMDBService.shared.fetchUpcomingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.upcomingMovies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadNowPlayingMovies() {
        TMDBService.shared.fetchNowPlayingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.nowPlayingMovies = movies
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MEDIA DETAILS
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
    
    
    // TV SHOWS
    func loadPopularTVShows() {
        TMDBService.shared.fetchPopularTVShows { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shows):
                    self?.popularTVShows = shows
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadTopRatedTVShows() {
        TMDBService.shared.fetchTopRatedTVShows { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let shows):
                    self?.topRatedTVShows = shows
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
