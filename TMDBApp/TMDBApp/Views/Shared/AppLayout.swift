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
            HeaderView()
                .padding(.bottom)
            
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
                .navigationDestination(for: String.self) { movieID in
                    Text("Movie Details for \(movieID)")
                }
            }
            
            FooterView(selectedSection: $selectedSection)
                .padding(.top)
        }
    }
}

#Preview {
    AppLayout()
}
