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

//MOVE THIS TO VIEWMODEL? -------------------
extension String {
    func releaseYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        return "N/A"
    }
    
    func invertedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return "N/A"
    }
}
// -----------------------------------------

