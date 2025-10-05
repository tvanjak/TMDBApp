//
//  FavoritesViewModel.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 07.09.2025..
//

import SwiftUI

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [MediaItemViewModel] = []
    
    private let favoritesManager: FavoritesManager
    private let navigationService: NavigationViewModelProtocol
    
    init(
        favoritesManager: FavoritesManager,
        navigationService: NavigationViewModelProtocol
    ) {
        self.favoritesManager = favoritesManager
        self.navigationService = navigationService
        
        // Observe FavoritesManager changes
        favoritesManager.$favorites
            .assign(to: &$favorites)
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItemViewModel) {
        favoritesManager.toggleFavorite(media)
    }
    
    func isFavorite(_ media: MediaItemViewModel) -> Bool {
        return favoritesManager.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItemViewModel) -> String {
        return favoritesManager.getFavoriteIcon(media)
    }
    
    func getFavoriteColor(_ media: MediaItemViewModel) -> Color {
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
