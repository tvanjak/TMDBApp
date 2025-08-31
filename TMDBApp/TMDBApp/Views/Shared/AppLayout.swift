//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var movieViewModel = MovieViewModel(favoritesRepo: FavoritesRepository.shared, sessionRepo: SessionRepository.shared)
    @StateObject private var router = Router()


    var body: some View {
        VStack(spacing: 0) {
            HeaderView(canGoBack: router.canGoBack(), onBack: { router.goBack() })
            NavigationStack(path: $router.path) {
                HomeView()
                    .environmentObject(movieViewModel)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            HomeView()
                                .environmentObject(movieViewModel)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .navigationBar)
                        case .favorites:
                            FavoritesView()
                                .environmentObject(movieViewModel)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .navigationBar)
                        case .profile:
                            ProfileView()
                                .environmentObject(authViewModel)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .navigationBar)
                        case .mediaDetail(let id):
                            MovieView(movieId: id)
                                .environmentObject(movieViewModel)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .navigationBar)
                        }
                    }
            }
            .environmentObject(router)
            FooterView()
                .environmentObject(router)
        }
    }
}


#Preview {
    AppLayout()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(Router())
}
