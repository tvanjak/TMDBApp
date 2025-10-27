//
//  FavoritesManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI


final class FavoritesUseCase {
    private var favorites: [MediaItemViewModel] = []
    
    private let favoritesRepo: FavoritesRepositoryProtocol
    private let authenticationRepo: AuthenticationRepositoryProtocol
    
    init(favoritesRepo: FavoritesRepositoryProtocol, authenticationRepo: AuthenticationRepositoryProtocol) {
        self.favoritesRepo = favoritesRepo
        self.authenticationRepo = authenticationRepo
        self.favorites = loadFavorites()
    }
    
    func loadFavorites() -> [MediaItemViewModel] {
        guard let uid = authenticationRepo.currentUserId else { return [] }
        favorites = favoritesRepo.loadFavorites(for: uid)
        return favorites
    }
    
    func toggleFavorite(_ media: MediaItemViewModel) {
        guard let _ = authenticationRepo.currentUserId else { return }
        if isFavorite(media) {
            removeFavorite(media)
        } else {
            addFavorite(media)
        }
    }
    
    func isFavorite(_ media: MediaItemViewModel) -> Bool {
        return favorites.contains { $0.id == media.id }
    }
    
    private func addFavorite(_ media: MediaItemViewModel) {
        guard let uid = authenticationRepo.currentUserId else { return }
        favorites.append(media)
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
    
    private func removeFavorite(_ media: MediaItemViewModel) {
        guard let uid = authenticationRepo.currentUserId else { return }
        favorites.removeAll { $0.id == media.id }
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
}
