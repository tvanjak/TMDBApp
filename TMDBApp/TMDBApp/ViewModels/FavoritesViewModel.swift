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
    
    private let favoritesUseCase: FavoritesUseCase
    private let navigationService: NavigationViewModelProtocol
    
    init(
        favoritesUseCase: FavoritesUseCase,
        navigationService: NavigationViewModelProtocol
    ) {
        self.favoritesUseCase = favoritesUseCase
        self.navigationService = navigationService
        
        favorites = favoritesUseCase.loadFavorites()
    }
    
    // FAVORITES FUNCTIONS -------------------------------
    func toggleFavorite(_ media: MediaItemViewModel) {
        favoritesUseCase.toggleFavorite(media)
        favorites = favoritesUseCase.loadFavorites()
    }
    
    func isFavorite(_ media: MediaItemViewModel) -> Bool {
        return favoritesUseCase.isFavorite(media)
    }
    
    func getFavoriteIcon(_ media: MediaItemViewModel) -> String {
        return isFavorite(media) ? "heart.fill" : "heart"
    }
    
    func getFavoriteColor(_ media: MediaItemViewModel) -> Color {
        return isFavorite(media) ? .red : .white
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
