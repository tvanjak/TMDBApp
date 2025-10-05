//
//  MovieDetails.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

protocol MediaDetailsUI: Identifiable {
    var id: Int { get }
    var displayTitle: String { get }
    var overview: String { get }
    var formattedRuntime: String? { get }
    var voteAverage: Double { get }
    var fullPosterPath: String? { get }
    var formattedGenres: String { get }
    var releaseYear: String { get }
    var invertedDate: String { get }
    
    var credits: CreditsUI { get }
}



struct MovieDetailsUI: Identifiable, MediaDetailsUI {
    let id: Int
    let displayTitle: String
    let overview: String
    let formattedRuntime: String?
    let voteAverage: Double
    let fullPosterPath: String?
    let formattedGenres: String
    let releaseYear: String
    let invertedDate: String
    
    let credits: CreditsUI
    
    init(from dto: MovieDetailsDTO) {
        self.id = dto.id
        self.displayTitle = dto.title
        self.overview = dto.overview
        
        // runtime formatting
        if let minutes = dto.runtime {
            let hours = minutes / 60
            let mins = minutes % 60
            self.formattedRuntime = hours > 0 ? "\(hours)h \(mins)m" : "\(mins)m"
        } else {
            self.formattedRuntime = nil
        }
        
        self.voteAverage = dto.voteAverage
        self.fullPosterPath = dto.posterPath.map { "https://image.tmdb.org/t/p/w500\($0)" }
        self.formattedGenres = dto.genres.map(\.name).joined(separator: ", ")
        
        // dates
        if let date = CustomDateFormatter.fromYYYYMMdd(dto.releaseDate) {
            self.releaseYear = CustomDateFormatter.toYYYY(date)
            self.invertedDate = CustomDateFormatter.toDDMMYYYY(date)
        } else {
            self.releaseYear = "N/A"
            self.invertedDate = "N/A"
        }
        
        self.credits = CreditsUI(from: dto.credits)
    }
}



struct TVShowDetailsUI: Identifiable, MediaDetailsUI {
    let id: Int
    let displayTitle: String
    let overview: String
    let formattedRuntime: String?
    let voteAverage: Double
    let fullPosterPath: String?
    let formattedGenres: String
    let releaseYear: String
    let invertedDate: String
    
    let credits: CreditsUI

    init(from dto: TVShowDetailsDTO) {
        self.id = dto.id
        self.displayTitle = dto.name
        self.overview = dto.overview
        
        // runtime formatting
        if let runtimes = dto.episodeRunTime, !runtimes.isEmpty {
            let sum = runtimes.reduce(0, +)
            let minutes = sum / runtimes.count
            let hours = minutes / 60
            let mins = minutes % 60
            if hours > 0 {
                self.formattedRuntime = mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h per ep"
            } else {
                self.formattedRuntime = "\(mins)m per ep"
            }
        } else {
            self.formattedRuntime = nil
        }
    

        self.voteAverage = dto.voteAverage
        self.fullPosterPath = dto.posterPath.map { "https://image.tmdb.org/t/p/w500\($0)" }
        self.formattedGenres = dto.genres.map(\.name).joined(separator: ", ")

        // dates
        if let date = DateFormatter.yyyyMMdd.date(from: dto.firstAirDate) {
            self.releaseYear = DateFormatter.yyyy.string(from: date)
            self.invertedDate = DateFormatter.ddMMyyyy.string(from: date)
        } else {
            self.releaseYear = "N/A"
            self.invertedDate = "N/A"
        }
        
        self.credits = CreditsUI(from: dto.credits)
    }
}

