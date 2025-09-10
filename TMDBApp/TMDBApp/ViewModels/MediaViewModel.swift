//
//  MediaDetailsViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 10.09.2025..
//

import SwiftUI

@MainActor
final class MediaViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var mediaDetail: (any MediaItemDetails)?
    
    private let favoritesManager: FavoritesManager
    
    init(
        favoritesManager: FavoritesManager,
    ) {
        self.favoritesManager = favoritesManager
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItem) {
        favoritesManager.toggleFavorite(media)
    }
    
    func isFavorite(_ media: MediaItem) -> Bool {
        return favoritesManager.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItem) -> String {
        return favoritesManager.getFavoriteIcon(media)
    }
    
    func getFavoriteColor(_ media: MediaItem) -> Color {
        return favoritesManager.getFavoriteColor(media)
    }
    // ------------------------------------------------------------

    
    // MOVIE DETAILS
    func loadDetails(media: MediaType) async {
        do {
            switch media {
            case .movie(let id):
                let movie: any MediaItemDetails = try await TMDBService.shared.fetchDetails(for: .movie(id: id))
                self.mediaDetail = movie
                
            case .tvShow(let id):
                let tvShow: any MediaItemDetails = try await TMDBService.shared.fetchDetails(for: .tvShow(id: id))
                self.mediaDetail = tvShow
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

}
