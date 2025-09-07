//
//  FavoritesManager.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favorites: [MediaItem] = []
    
    private let favoritesRepo: FavoritesRepositoryProtocol
    private let sessionRepo: SessionRepositoryProtocol
    
    init(favoritesRepo: FavoritesRepositoryProtocol, sessionRepo: SessionRepositoryProtocol) {
        self.favoritesRepo = favoritesRepo
        self.sessionRepo = sessionRepo
        loadFavorites()
    }
    
    private func loadFavorites() {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites = favoritesRepo.loadFavorites(for: uid)
    }
    
    func toggleFavorite(_ media: MediaItem) {
        guard let uid = sessionRepo.currentUserId else { return }
        if isFavorite(media) {
            removeFavorite(media)
        } else {
            addFavorite(media)
        }
    }
    
    func isFavorite(_ media: MediaItem) -> Bool {
        return favorites.contains { $0.id == media.id }
    }
    
    func getFavoriteIcon(_ media: MediaItem) -> String {
        return isFavorite(media) ? "heart.fill" : "heart"
    }
    
    func getFavoriteColor(_ media: MediaItem) -> Color {
        return isFavorite(media) ? .red : .white
    }
    
    private func addFavorite(_ media: MediaItem) {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites.append(media)
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
    
    private func removeFavorite(_ media: MediaItem) {
        guard let uid = sessionRepo.currentUserId else { return }
        favorites.removeAll { $0.id == media.id }
        favoritesRepo.saveFavorites(favorites, for: uid)
    }
}
