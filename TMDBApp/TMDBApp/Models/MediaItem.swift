import Foundation

struct MediaItem: Codable, Identifiable {
    let id: Int
    let posterPath: String?
    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
    }
}

struct MediaItemResponse: Codable {
    let results: [MediaItem]
}

enum MediaType: Hashable {
    case movie(id: Int)
    case tvShow(id: Int)
}

