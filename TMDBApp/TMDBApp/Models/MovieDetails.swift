//
//  MovieDetails.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
//

import Foundation

struct MovieDetails: Codable, Identifiable, MediaItemDetails {
    var displayTitle: String { title }

    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let posterPath: String?
    let genres: [Genre]
    let credits: Credits
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case genres
        case credits
    }
}
