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
    @Published var mediaDetail: (any MediaDetailsUI)?
    @Published var favorites: [MediaItemUI] = []
    
    private let favoritesManager: FavoritesManager
    
    init(
        favoritesManager: FavoritesManager,
    ) {
        self.favoritesManager = favoritesManager
        
        // Observe FavoritesManager changes
        favoritesManager.$favorites
            .assign(to: &$favorites)
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItemUI) {
        favoritesManager.toggleFavorite(media)
    }
    
    func isFavorite(_ media: MediaItemUI) -> Bool {
        return favoritesManager.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItemUI) -> String {
        return favoritesManager.getFavoriteIcon(media)
    }
    
    func getFavoriteColor(_ media: MediaItemUI) -> Color {
        return favoritesManager.getFavoriteColor(media)
    }
    // ------------------------------------------------------------

    
    // MEDIA DETAILS
    func loadDetails(media: MediaType) async {
        do {
            switch media {
            case .movie(let id):
                let movie: any MediaDetailsUI = try await TMDBService.shared.fetchDetails(for: .movie(id: id))
                self.mediaDetail = movie
                
            case .tvShow(let id):
                let tvShow: any MediaDetailsUI = try await TMDBService.shared.fetchDetails(for: .tvShow(id: id))
                self.mediaDetail = tvShow
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

}
