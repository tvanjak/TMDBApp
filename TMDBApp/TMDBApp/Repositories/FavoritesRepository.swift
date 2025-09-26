//
//  FavoritesRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

protocol FavoritesRepositoryProtocol {
    func loadFavorites(for userId: String) -> [MediaItemUI]
    func saveFavorites(_ favorites: [MediaItemUI], for userId: String)
}


class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private let userDefaults: UserDefaults = .standard
    
    func loadFavorites(for userId: String) -> [MediaItemUI] {
        guard let data = userDefaults.data(forKey: "favorites_\(userId)") else { return [] }
        do {
            return try JSONDecoder().decode([MediaItemUI].self, from: data)
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    func saveFavorites(_ favorites: [MediaItemUI], for userId: String) {
        do {
            let data = try JSONEncoder().encode(favorites)
            userDefaults.set(data, forKey: "favorites_\(userId)")
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
