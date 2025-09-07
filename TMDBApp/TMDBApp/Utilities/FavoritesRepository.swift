//
//  FavoritesRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

protocol FavoritesRepositoryProtocol {
    func loadFavorites(for userId: String) -> [MediaItem]
    func saveFavorites(_ favorites: [MediaItem], for userId: String)
}


class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private let userDefaults: UserDefaults = .standard
    
    func loadFavorites(for userId: String) -> [MediaItem] {
        guard let data = userDefaults.data(forKey: "favorites_\(userId)") else { return [] }
        do {
            return try JSONDecoder().decode([MediaItem].self, from: data)
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    func saveFavorites(_ favorites: [MediaItem], for userId: String) {
        do {
            let data = try JSONEncoder().encode(favorites)
            userDefaults.set(data, forKey: "favorites_\(userId)")
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
