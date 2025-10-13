//
//  MovieDetailsDTO.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

protocol MediaDetailsDTO: Identifiable {
    var id: Int { get }
    var displayTitle: String { get }
    var overview: String { get }
    var formattedRuntime: String? { get }
    var voteAverage: Double { get }
    var fullPosterPath: String? { get }
    var formattedGenres: String { get }
    var releaseYear: String { get }
    var invertedDate: String { get }
    
    var credits: CreditsDTO { get }
}

struct MovieDetailsDTO: Codable, Identifiable, MediaDetailsDTO {
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

    // MediaDetailsDTO conformance
    var displayTitle: String { title }

    var formattedRuntime: String? {
        guard let runtime else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }

    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    var formattedGenres: String {
        genres.map { $0.name }.joined(separator: ", ")
    }

    var releaseYear: String {
        guard let date = CustomDateFormatter.fromYYYYMMdd(releaseDate) else { return "N/A" }
        return CustomDateFormatter.toYYYY(date)
    }

    var invertedDate: String {
        guard let date = CustomDateFormatter.fromYYYYMMdd(releaseDate) else { return "N/A" }
        return CustomDateFormatter.toDDMMYYYY(date)
    }
}

struct TVShowDetailsDTO: Codable, Identifiable, MediaDetailsDTO {
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

    // MediaDetailsDTO conformance

    var displayTitle: String { name }

    var formattedRuntime: String? {
        guard let runtime = episodeRunTime?.first else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }

    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }

    var formattedGenres: String {
        genres.map { $0.name }.joined(separator: ", ")
    }

    var releaseYear: String {
        guard let date = CustomDateFormatter.fromYYYYMMdd(firstAirDate) else { return "N/A" }
        return CustomDateFormatter.toYYYY(date)
    }

    var invertedDate: String {
        guard let date = CustomDateFormatter.fromYYYYMMdd(firstAirDate) else { return "N/A" }
        return CustomDateFormatter.toDDMMYYYY(date)
    }
}
