//
//  Constants.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 11.08.2025..
//

import Foundation

struct Constants {
    static let baseURL = "https://api.themoviedb.org/3"

    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "TMDBApiKey") as? String else {
            fatalError("Missing TMDBApiKey in Info.plist")
        }
        return key
    }()
    
    static let readAccessToken: String = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "TMDBReadAccessToken") as? String else {
            fatalError("Missing TMDBReadAccessToken in Info.plist")
        }
        return token
    }()
}

