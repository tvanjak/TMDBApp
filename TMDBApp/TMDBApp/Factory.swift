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
    
    var authRepository: Factory<AuthRepositoryProtocol> {
        self { AuthRepository() }
            .singleton
    }
    
    var userRepository: Factory<UserRepositoryProtocol> {
        self { UserRepository() }
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
    
    var sessionManager: Factory<SessionManager> {
        self { @MainActor in
            SessionManager(
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
    var homeViewModel: Factory<HomeViewModel> {
        self { @MainActor in
            HomeViewModel(
                favoritesManager: self.favoritesManager(),
                navigationService: self.router()
            )
        }
        .singleton
    }
    
    var mediaViewModel: Factory<MediaViewModel> {
        self { @MainActor in
            MediaViewModel(
                favoritesManager: self.favoritesManager(),
            )
        }
        .singleton
    }
    
    var authViewModel: Factory<AuthenticationViewModel> {
        self { @MainActor in
            AuthenticationViewModel(
//                authRepo: self.authRepository(),
//                userRepo: self.userRepository()
                sessionManager: self.sessionManager()
            )
        }
        .singleton
    }
    
    var profileViewModel: Factory<ProfileViewModel> {
        self { @MainActor in
            ProfileViewModel(
//                authRepo: self.authRepository(),
//                userRepo: self.userRepository(),
                sessionManager: self.sessionManager()
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

