
import SwiftUI

class TVShowViewModel: ObservableObject {
    @Published var popularTVShows: [TVShow] = []
    @Published var topRatedTVShows: [TVShow] = []
    @Published var errorMessage: String?
    
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
