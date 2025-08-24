//
//  TVShowDetails.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 23.08.2025..
//

import Foundation

struct TVShowDetails: Codable, Identifiable, MediaItemDetails {
    var displayTitle: String { name }
    var releaseDate: String { firstAirDate }

    let id: Int
    let name: String
    let overview: String
    let firstAirDate: String
    let episodeRunTime: [Int]?
    let numberOfEpisodes: Int
    let voteAverage: Double
    let posterPath: String?
    let genres: [Genre]
    let credits: Credits
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case overview
        case firstAirDate = "first_air_date"
        case episodeRunTime = "episode_run_time"
        case numberOfEpisodes = "number_of_episodes"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case genres
        case credits
    }
    
    var runtime: Int? {
        guard let episodeRunTime = episodeRunTime,
              let averageRuntime = episodeRunTime.first else {
            return nil
        }
        return averageRuntime * numberOfEpisodes
    }
}
