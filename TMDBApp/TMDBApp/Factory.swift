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
    
    // Services
    var router: Factory<Router> {
        self { Router() }
            .singleton
    }
    
    // ViewModels
    var movieViewModel: Factory<MovieViewModel> {
        self { @MainActor in
            MovieViewModel(
                favoritesRepo: self.favoritesRepository(),
                sessionRepo: self.sessionRepository(),
                navigationService: self.router()
            )
        }
        .singleton
    }
    
    @MainActor
    var authViewModel: Factory<AuthenticationViewModel> {
        self { @MainActor in
            AuthenticationViewModel(
                sessionRepo: self.sessionRepository()
            )
        }
        .singleton
    }
}

