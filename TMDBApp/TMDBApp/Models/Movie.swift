
import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String?
    
    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

