//
//  FavoritesRepository.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import Foundation

protocol FavoritesRepositoryProtocol {
    func loadFavorites(for userId: String) -> [MediaItemViewModel]
    func saveFavorites(_ favorites: [MediaItemViewModel], for userId: String)
}


class FavoritesRepository: FavoritesRepositoryProtocol {
    
    private let userDefaults: UserDefaults = .standard
    
    func loadFavorites(for userId: String) -> [MediaItemViewModel] {
        guard let data = userDefaults.data(forKey: "favorites_\(userId)") else { return [] }
        do {
            return try JSONDecoder().decode([MediaItemViewModel].self, from: data)
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    func saveFavorites(_ favorites: [MediaItemViewModel], for userId: String) {
        do {
            let data = try JSONEncoder().encode(favorites)
            userDefaults.set(data, forKey: "favorites_\(userId)")
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
