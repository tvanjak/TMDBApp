//
//  Router.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 29.08.2025..
//

import SwiftUI

protocol NavigationManagerProtocol: ObservableObject {
    var path: NavigationPath { get set }
    
    func goBack()
    func canGoBack() -> Bool
    func navigateTo(_ route: Route)
}

class Router: NavigationManagerProtocol {
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
}

enum Route: Hashable {
    case home
    case favorites
    case profile
    case mediaDetail(id: Int)
}
