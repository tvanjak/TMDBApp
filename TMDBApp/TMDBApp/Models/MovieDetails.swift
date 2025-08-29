//
//  MovieDetails.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
//

import Foundation


struct MovieDetails: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let posterPath: String?
    let genres: [Genre]
    let credits: Credits
    
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

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Credits: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    var fullProfilePath: String? {
        guard let path = profilePath else { return nil }
        return "https://image.tmdb.org/t/p/w200\(path)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?
    
//    var fullProfilePath: String? {
//        guard let path = profilePath else { return nil }
//        return "https://image.tmdb.org/t/p/w500\(path)"
//    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case profilePath = "profile_path"
    }
}

