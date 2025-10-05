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
    @Published var mediaDetail: (any MediaDetailsViewModel)?
    @Published var favorites: [MediaItemViewModel] = []
    
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

    
    // MEDIA DETAILS
    func loadDetails(media: MediaType) async {
        do {
            switch media {
            case .movie(let id):
                let dtoData = try await MediaRepository.shared.fetchDetails(for: .movie(id: id))
                let movie: any MediaDetailsViewModel = MovieDetailsViewModel(from: dtoData as! MovieDetailsDTO)
                self.mediaDetail = movie
            case .tvShow(let id):
                let dtoData = try await MediaRepository.shared.fetchDetails(for: .tvShow(id: id))
                let tvShow: any MediaDetailsViewModel = TVShowDetailsViewModel(from: dtoData as! TVShowDetailsDTO)
                self.mediaDetail = tvShow
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    // ------------------------------------------------------------

}
