//
//  Router.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

// Protocol for ViewModels
protocol NavigationViewModelProtocol {
    func navigateToMedia(_ media: MediaType)
    func goBack()
    func canGoBack() -> Bool
}

// Protocol for Views
protocol NavigationProtocol {
    var path: NavigationPath { get set }
    
    func goBack()
    func canGoBack() -> Bool
    func navigateTo(_ route: Route)
}


// Router class
class Router: NavigationProtocol, NavigationViewModelProtocol, ObservableObject {
    @Published var path = NavigationPath()
    
    func goBack() {
        if !path.isEmpty { path.removeLast() }
    }

    func canGoBack() -> Bool {
        return !path.isEmpty
    }
    
    func navigateTo(_ route: Route) {
        path.append(route)
    }
    
    // Implementation for ViewModels
    func navigateToMedia(_ media: MediaType) {
        navigateTo(.mediaDetail(media: media))
    }
}

enum Route: Hashable {
    case home
    case favorites
    case profile
    case mediaDetail(media: MediaType)
}
