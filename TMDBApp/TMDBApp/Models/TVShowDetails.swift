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
    
    var runtime: Int? {
        guard let episodeRunTime = episodeRunTime,
              let averageRuntime = episodeRunTime.first else {
            return nil
        }
        return averageRuntime * numberOfEpisodes
    }
    
    var formattedRuntime: String? {
        guard let minutes = runtime else { return nil }
        
        let hours = minutes / 60
        let actualMinutes = minutes % 60
        
        if hours > 0 {
            if actualMinutes > 0 {
                return "\(hours)h \(actualMinutes)m"
            } else {
                return "\(hours)h"
            }
        } else {
            return "\(actualMinutes)m"
        }
    }
    
    var formattedGenres: String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
    
    var fullPosterPath: String? {
        guard let path = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
    
    var releaseYear: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.firstAirDate) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
//        return "N/A"
        return nil
    }
    
    var invertedDate: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.firstAirDate) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
//        return "N/A"
        return nil
    }
    
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
}
