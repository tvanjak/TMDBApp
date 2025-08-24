//
//  SharedStructs.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 24.08.2025..
//

import Foundation

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Credits: Codable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}

struct CrewMember: Codable, Identifiable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case profilePath = "profile_path"
    }
}

