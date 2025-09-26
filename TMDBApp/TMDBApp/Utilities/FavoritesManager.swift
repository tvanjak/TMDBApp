//
//  FavoritesManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI

// ADD PROTOCOL

@MainActor
final class FavoritesManager: ObservableObject {
    @Published var favorites: [MediaItemUI] = []
    
    private let favoritesRepo: FavoritesRepositoryProtocol
    private let authenticationRepo: AuthenticationRepositoryProtocol
    
    init(favoritesRepo: FavoritesRepositoryProtocol, authenticationRepo: AuthenticationRepositoryProtocol) {
        self.favoritesRepo = favoritesRepo
        self.authenticationRepo = authenticationRepo
        loadFavorites()
    }
    
    private func loadFavorites() {
        guard let uid = authenticationRepo.currentUserId else { return }
        favorites = favoritesRepo.loadFavorites(for: uid)
    }
    
    func toggleFavorite(_ media: MediaItemUI) {
        guard let _ = authenticationRepo.currentUserId else { return }
        if isFavorite(media) {
            removeFavorite(media)
        } else {
            addFavorite(media)
        }
    }
    
    func isFavorite(_ media: MediaItemUI) -> Bool {
        return favorites.contains { $0.id == media.id }
    }
    
    func getFavoriteIcon(_ media: MediaItemUI) -> String {
        return isFavorite(media) ? "heart.fill" : "heart"
    }
    
    func getFavoriteColor(_ media: MediaItemUI) -> Color {
        return isFavorite(media) ? .red : .white
    }
    
    private func addFavorite(_ media: MediaItemUI) {
        guard let uid = authenticationRepo.currentUserId else { return }
        favorites.append(media)
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
    
    private func removeFavorite(_ media: MediaItemUI) {
        guard let uid = authenticationRepo.currentUserId else { return }
        favorites.removeAll { $0.id == media.id }
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
}
