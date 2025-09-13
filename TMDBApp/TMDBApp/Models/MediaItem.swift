import Foundation

struct MediaItem: Codable, Identifiable {
    let id: Int
    let posterPath: String?
    let overview: String?
    private let title: String?
    private let name: String?
    private let firstAirDate: String?
    private let releaseDate: String?
    
    var displayTitle: String {
        title ?? name ?? "Untitled"
    }
    
    var releaseYear: String? { // NEED TO FINISH
        releaseDate ?? firstAirDate ?? ""
    }
    
    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview = "overview"
        case title = "title"
        case name = "name"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
    
    init(id: Int, posterPath: String?) {
        self.id = id
        self.posterPath = posterPath
        self.overview = nil
        self.title = nil
        self.name = nil
        self.releaseDate = nil
        self.firstAirDate = nil
    }
}

struct MediaItemResponse: Codable {
    let results: [MediaItem]
}

enum MediaType: Hashable {
    case movie(id: Int)
    case tvShow(id: Int)
}

