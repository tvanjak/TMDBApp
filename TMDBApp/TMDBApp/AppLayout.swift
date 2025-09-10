//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI
import Factory

struct AppLayout: View {
    @StateObject private var router = Container.shared.router()
    @StateObject private var homeViewModel = Container.shared.homeViewModel()
    @StateObject private var mediaViewModel = Container.shared.mediaViewModel()
    @StateObject private var authViewModel = Container.shared.authViewModel()
    @StateObject private var favoritesViewModel = Container.shared.favoritesViewModel()

    var body: some View {
        if authViewModel.currentUser != nil {
            VStack(spacing: 0) {
                HeaderView(canGoBack: router.canGoBack(), onBack: { router.goBack() })
                NavigationStack(path: $router.path) {
                    HomeView(homeViewModel: homeViewModel)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home:
                                HomeView(homeViewModel: homeViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .favorites:
                                FavoritesView(favoritesViewModel: favoritesViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .profile:
                                ProfileView(authViewModel: authViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .mediaDetail(let media):
                                MediaView(media: media, mediaViewModel: mediaViewModel)
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
