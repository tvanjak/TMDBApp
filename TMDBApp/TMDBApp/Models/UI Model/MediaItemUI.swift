//
//  MediaItemDTO.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

struct MediaItemUI: Identifiable, Codable {
    let id: Int
    let displayTitle: String
    let overview: String?
    let releaseYear: String
    let fullPosterPath: String?

    init(from dto: MediaItemDTO) {
        self.id = dto.id
        self.displayTitle = dto.title ?? dto.name ?? "Untitled"
        self.overview = dto.overview

        // release year
        let rawDate = dto.releaseDate ?? dto.firstAirDate
        if let rawDate,
           let date = DateFormatter.yyyyMMdd.date(from: rawDate) {
            self.releaseYear = DateFormatter.yyyy.string(from: date)
        } else {
            self.releaseYear = "N/A"
        }

        // poster path
        if let path = dto.posterPath {
            self.fullPosterPath = "https://image.tmdb.org/t/p/w500\(path)"
        } else {
            self.fullPosterPath = nil
        }
    }
    
    init(from details: any MediaDetailsUI) {
        self.id = details.id
        self.displayTitle = details.displayTitle
        self.overview = details.overview
        self.releaseYear = details.releaseYear
        self.fullPosterPath = details.fullPosterPath
    }
}



extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    static let yyyy: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        return df
    }()
    
    static let ddMMyyyy: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
}


