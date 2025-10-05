//
//  MediaItemDTO.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

struct MediaItemViewModel: Identifiable, Codable {
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
           let date = CustomDateFormatter.fromYYYYMMdd(rawDate) {
            self.releaseYear = CustomDateFormatter.toYYYY(date)
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
    
    init(from details: any MediaDetailsViewModel) {
        self.id = details.id
        self.displayTitle = details.displayTitle
        self.overview = details.overview
        self.releaseYear = details.releaseYear
        self.fullPosterPath = details.fullPosterPath
    }
}
