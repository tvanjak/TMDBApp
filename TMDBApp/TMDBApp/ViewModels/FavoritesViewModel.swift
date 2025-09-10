//
//  FavoritesViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var mediaDetail: (any MediaItemDetails)?
    @Published var favorites: [MediaItem] = []
    
    private let favoritesManager: FavoritesManager
    private let navigationService: NavigationServiceProtocol
    
    init(
        favoritesManager: FavoritesManager,
        navigationService: NavigationServiceProtocol
    ) {
        self.favoritesManager = favoritesManager
        self.navigationService = navigationService
        
        // Observe FavoritesManager changes
        favoritesManager.$favorites
            .assign(to: &$favorites)
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

    
    // ROUTER FUNCTIONS
    func navigateToMedia(_ media: MediaType) {
        navigationService.navigateToMedia(media)
    }
    
    func goBack() {
        navigationService.goBack()
    }
    
    func canGoBack() -> Bool {
        return navigationService.canGoBack()
    }
    // ------------------------------------------------------------
}
