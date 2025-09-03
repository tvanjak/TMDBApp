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
    @StateObject private var mediaViewModel = Container.shared.mediaViewModel()
    @StateObject private var authViewModel = Container.shared.authViewModel()

    var body: some View {
        if authViewModel.currentUser != nil {
            VStack(spacing: 0) {
                HeaderView(canGoBack: router.canGoBack(), onBack: { router.goBack() })
                NavigationStack(path: $router.path) {
                    HomeView(mediaViewModel: mediaViewModel)
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home:
                                HomeView(mediaViewModel: mediaViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .favorites:
                                FavoritesView(mediaViewModel: mediaViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .profile:
                                ProfileView(authViewModel: authViewModel)
                                    .navigationBarBackButtonHidden(true)
                                    .toolbar(.hidden, for: .navigationBar)
                            case .mediaDetail(let media):
                                MediaDetailsView(media: media, mediaViewModel: mediaViewModel)
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
