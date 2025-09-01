//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @StateObject private var router: Router
    @StateObject private var movieViewModel: MovieViewModel
    @StateObject private var authViewModel = AuthenticationViewModel()

    init() {
        // Create dependencies in the correct order
        let router = Router()
        let movieViewModel = MovieViewModel(
            favoritesRepo: FavoritesRepository.shared,
            sessionRepo: SessionRepository.shared,
            navigationService: router
        )
        
        // Assign to StateObjects
        self._router = StateObject(wrappedValue: router)
        self._movieViewModel = StateObject(wrappedValue: movieViewModel)
    }

    var body: some View {
        if authViewModel.currentUser != nil {
            VStack(spacing: 0) {
                HeaderView(canGoBack: router.canGoBack(), onBack: { router.goBack() })
                NavigationStack(path: $router.path) {
                    HomeView(movieViewModel: movieViewModel)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home:
                                HomeView(movieViewModel: movieViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .favorites:
                                FavoritesView(movieViewModel: movieViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .profile:
                                ProfileView(authViewModel: authViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .mediaDetail(let id):
                                MovieView(movieId: id, movieViewModel: movieViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                        }
                }
                FooterView(router: router)
            }
        } else {
            LoginView(authViewModel: authViewModel)
        }
    }
}


#Preview {
    AppLayout()
}
