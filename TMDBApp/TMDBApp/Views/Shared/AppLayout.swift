//
//  AppLayout.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct AppLayout: View {
    @State private var path = NavigationPath()
    @State private var selectedSection: Section = .home
    
    enum Section {
        case home, favorites, profile
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                canGoBack: !path.isEmpty,
                onBack: { path.removeLast() }
            )
            
            NavigationStack(path: $path) {
                Group {
                    switch selectedSection {
                    case .home:
                        HomeView(path: $path)
                    case .favorites:
                        FavoritesView(path: $path)
                    case .profile:
                        ProfileView(path: $path)
                    }
                }
                .navigationDestination(for: Int.self) { movieId in
                    MovieView(movieId: movieId)
                        .navigationBarBackButtonHidden()
                        .toolbar(.hidden, for: .navigationBar)
                }
                .toolbar(.hidden, for: .navigationBar)
            }
            
            FooterView(selectedSection: $selectedSection)
                .padding(.top)
        }
    }
}

#Preview {
    AppLayout()
}
