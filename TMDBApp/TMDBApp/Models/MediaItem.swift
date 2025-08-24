import Foundation

struct MediaItem: Codable, Identifiable {
    let id: Int
    let posterPath: String?

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

