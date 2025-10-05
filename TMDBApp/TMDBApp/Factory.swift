//
//  Factory.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 01.09.2025..
//

import SwiftUI
import Factory
import FirebaseFirestore

extension Container {
    // Repositories
    var favoritesRepository: Factory<FavoritesRepositoryProtocol> {
        self { FavoritesRepository() }
            .singleton
    }
    
    var authenticationRepository: Factory<AuthenticationRepository> {
        self { @MainActor in
            AuthenticationRepository(
                db: Firestore.firestore()
            )
        }
        .singleton
    }
    
    var profileRepository: Factory<ProfileRepository> {
        self { @MainActor in
            ProfileRepository(
                db: Firestore.firestore()
            )
        }
        .singleton
    }
    
    var mediaRepository: Factory<MediaRepository> {
        self { @MainActor in
            MediaRepository()
        }
        .singleton
    }
    
    
    // Managers
    var favoritesManager: Factory<FavoritesManager> {
        self { @MainActor in
            FavoritesManager(
                favoritesRepo: self.favoritesRepository(),
                authenticationRepo: self.authenticationRepository()
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
                navigationService: self.router(),
                mediaRepo: self.mediaRepository()
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
                authenticationRepository: self.authenticationRepository()
            )
        }
        .singleton
    }
    
    var profileViewModel: Factory<ProfileViewModel> {
        self { @MainActor in
            ProfileViewModel(
                profileRepository: self.profileRepository(),
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

