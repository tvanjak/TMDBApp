//
//  MediaItemDTO.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 26.09.2025..
//

import SwiftUI

struct MediaItemDTO: Codable, Identifiable {
    let id: Int
    let title: String?
    let name: String?
    let overview: String?
    let releaseDate: String?
    let firstAirDate: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
    }
}


struct MediaItemDTOResponse: Codable {
    let results: [MediaItemDTO]
}


enum MediaType: Hashable {
    case movie(id: Int)
    case tvShow(id: Int)
}
