//
//  SharedStructs.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 24.08.2025..
//

import SwiftUI

struct GenreUI: Identifiable {
    let id: Int
    let name: String

    init(from dto: GenreDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}


struct CreditsUI {
    let cast: [CastMemberUI]
    let crew: [CrewMemberUI]

    init(from dto: CreditsDTO) {
        self.cast = dto.cast.map(CastMemberUI.init)
        self.crew = dto.crew.map(CrewMemberUI.init)
    }
}


struct CastMemberUI: Identifiable {
    let id: Int
    let name: String
    let character: String
    let fullProfilePath: String?

    init(from dto: CastMemberDTO) {
        self.id = dto.id
        self.name = dto.name
        self.character = dto.character
        self.fullProfilePath = dto.profilePath.map {
            "https://image.tmdb.org/t/p/w200\($0)"
        }
    }
}


struct CrewMemberUI: Identifiable {
    let id: Int
    let name: String
    let job: String
    let fullProfilePath: String?

    init(from dto: CrewMemberDTO) {
        self.id = dto.id
        self.name = dto.name
        self.job = dto.job
        self.fullProfilePath = dto.profilePath.map {
            "https://image.tmdb.org/t/p/w200\($0)"
        }
    }
}
