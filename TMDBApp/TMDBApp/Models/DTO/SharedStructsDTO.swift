//
//  SharedStructs.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 24.08.2025..
//

import SwiftUI

struct GenreDTO: Codable, Identifiable {
    let id: Int
    let name: String
}


struct CreditsDTO: Codable {
    let cast: [CastMemberDTO]
    let crew: [CrewMemberDTO]
}


struct CastMemberDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}


struct CrewMemberDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, job
        case profilePath = "profile_path"
    }
}
