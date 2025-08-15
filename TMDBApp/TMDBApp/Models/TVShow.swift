
import Foundation

struct TVShow: Codable, Identifiable {
    var id: Int
    var name: String
    var overview: String
    var posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case posterPath = "poster_path"
    }
}

struct TVShowResponse: Codable {
    var results: [TVShow]
}
