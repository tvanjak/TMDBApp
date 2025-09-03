//
//  MediaItemDetails.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 23.08.2025..
//

import Foundation

protocol MediaItemDetails: Identifiable {
    var id: Int { get }
    var displayTitle: String { get }
    var overview: String { get }
    var runtime: Int? { get }
    var voteAverage: Double { get }
    var posterPath: String? { get }
    var genres: [Genre] { get }
    var credits: Credits { get }
    var releaseDate: String { get }
    
    var formattedGenres: String { get }
    var formattedRuntime: String? { get }
    var fullPosterPath: String? { get }
}
