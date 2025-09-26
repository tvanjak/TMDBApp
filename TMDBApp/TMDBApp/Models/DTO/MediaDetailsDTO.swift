//
//  MovieDetailsDTO.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

struct MovieDetailsDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let posterPath: String?
    let genres: [GenreDTO]
    let credits: CreditsDTO

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}


struct TVShowDetailsDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let firstAirDate: String
    let episodeRunTime: [Int]?
    let voteAverage: Double
    let posterPath: String?
    let genres: [GenreDTO]
    let credits: CreditsDTO

    enum CodingKeys: String, CodingKey {
        case id, name, overview, genres, credits
        case firstAirDate = "first_air_date"
        case episodeRunTime = "episode_run_time"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}
