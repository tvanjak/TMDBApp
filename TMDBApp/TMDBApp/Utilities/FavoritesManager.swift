//
//  FavoritesManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 21.08.2025..
//

import Foundation


class FavoritesManager {
    static let shared = FavoritesManager()
    private let defaults = UserDefaults.standard
    
    func loadFavorites(for userId: String) -> [MediaItem] {
        guard let data = defaults.data(forKey: "favorites_\(userId)") else { return [] }
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
            defaults.set(data, forKey: "favorites_\(userId)")
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}

