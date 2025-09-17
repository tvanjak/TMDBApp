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
    
    var releaseYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.releaseDate) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        return "N/A"
    }
    
    var invertedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self.releaseDate) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return "N/A"
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
