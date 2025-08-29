
import SwiftUI

class TVShowViewModel: ObservableObject {
    @Published var popularTVShows: [TVShow] = []
    @Published var topRatedTVShows: [TVShow] = []
    @Published var errorMessage: String?
    
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
}
