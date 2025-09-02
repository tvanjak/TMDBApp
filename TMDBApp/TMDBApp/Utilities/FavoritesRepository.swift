//
//  FavoritesRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

protocol FavoritesRepositoryProtocol {
    func loadFavorites(for userId: String) -> [Movie]
    func saveFavorites(_ movie: [Movie], for userId: String)
}


class FavoritesRepository: FavoritesRepositoryProtocol {
//    static let shared = FavoritesRepository()
//    private init() {}
    
    private let userDefaults: UserDefaults = .standard
    
    func loadFavorites(for userId: String) -> [Movie] {
        guard let data = userDefaults.data(forKey: "favorites_\(userId)") else { return [] }
        do {
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    func saveFavorites(_ favorites: [Movie], for userId: String) {
        do {
            let data = try JSONEncoder().encode(favorites)
            userDefaults.set(data, forKey: "favorites_\(userId)")
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
