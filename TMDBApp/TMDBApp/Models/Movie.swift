
import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
