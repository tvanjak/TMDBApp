//
//  Router.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

protocol NavigationManagerProtocol: ObservableObject {
    var homePath: NavigationPath { get set }
    var favoritesPath: NavigationPath { get set }
    var profilePath: NavigationPath { get set }
    
    func goBack(from section: AppLayout.Section)
    func navigateToMovie(_ movieId: Int, in section: AppLayout.Section)
}

class Router: NavigationManagerProtocol {
    @Published var homePath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var profilePath = NavigationPath()
    
    func goBack(from section: AppLayout.Section) {
        switch section {
        case .home: 
            if !homePath.isEmpty { homePath.removeLast() }
        case .favorites: 
            if !favoritesPath.isEmpty { favoritesPath.removeLast() }
        case .profile: 
            if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }

    func canGoBack(from section: AppLayout.Section) -> Bool {
        switch section {
        case .home:
            return !homePath.isEmpty
        case .favorites:
            return !favoritesPath.isEmpty
        case .profile:
            return !profilePath.isEmpty
        }
    }
    
    func navigateToMovie(_ movieId: Int, in section: AppLayout.Section) {
        switch section {
        case .home:
            homePath.append(movieId)
        case .favorites:
            favoritesPath.append(movieId)
        case .profile:
            profilePath.append(movieId)
        }
    }
}
