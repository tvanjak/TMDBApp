//
//  Router.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

class Router: ObservableObject {
    @Published var homePath = NavigationPath()
    @Published var favoritesPath = NavigationPath()
    @Published var profilePath = NavigationPath()

    func goToMovie(from section: AppLayout.Section, id: Int) {
        switch section {
        case .home:
            homePath.append(id)
        case .favorites:
            favoritesPath.append(id)
        case .profile:
            profilePath.append(id)
        }
    }
    
    func goBack(from section: AppLayout.Section) {
        switch section {
        case .home: if !homePath.isEmpty { homePath.removeLast() }
        case .favorites: if !favoritesPath.isEmpty { favoritesPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
}
