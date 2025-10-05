//
//  SharedStructs.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 24.08.2025..
//

import SwiftUI

struct GenreViewModel: Identifiable {
    let id: Int
    let name: String

    init(from dto: GenreDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}


struct CreditsViewModel {
    let cast: [CastMemberViewModel]
    let crew: [CrewMemberViewModel]

    init(from dto: CreditsDTO) {
        self.cast = dto.cast.map(CastMemberViewModel.init)
        self.crew = dto.crew.map(CrewMemberViewModel.init)
    }
}


struct CastMemberViewModel: Identifiable {
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


struct CrewMemberViewModel: Identifiable {
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
