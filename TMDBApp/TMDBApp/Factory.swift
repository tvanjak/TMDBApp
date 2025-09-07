//
//  Factory.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 01.09.2025..
//

import SwiftUI
import Factory

extension Container {
    // Repositories
    var favoritesRepository: Factory<FavoritesRepositoryProtocol> {
        self { FavoritesRepository() }
            .singleton  
    }
    
    var sessionRepository: Factory<SessionRepositoryProtocol> {
        self { SessionRepository() }
            .singleton
    }
    
    // Managers
    var favoritesManager: Factory<FavoritesManager> {
        self { @MainActor in
            FavoritesManager(
                favoritesRepo: self.favoritesRepository(),
                sessionRepo: self.sessionRepository(),
            )
        }
        .singleton
    }
    
    // Services
    var router: Factory<Router> {
        self { Router() }
            .singleton
    }
    
    // ViewModels
    var mediaViewModel: Factory<MediaViewModel> {
        self { @MainActor in
            MediaViewModel(
                favoritesManager: self.favoritesManager(),
                navigationService: self.router()
            )
        }
        .singleton
    }
    
    var authViewModel: Factory<AuthenticationViewModel> {
        self { @MainActor in
            AuthenticationViewModel(
                sessionRepo: self.sessionRepository()
            )
        }
        .singleton
    }
    
    var favoritesViewModel: Factory<FavoritesViewModel> {
        self { @MainActor in
            FavoritesViewModel(
                favoritesManager: self.favoritesManager(),
                navigationService: self.router()
            )
        }
        .singleton
    }
}

