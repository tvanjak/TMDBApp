//
//  Footer.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct FooterView: View {
    let router: NavigationProtocol
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {router.navigateTo(.home)}) {
                VStack {
                    Image(systemName: "house")
                    Text("Home")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {router.navigateTo(.favorites)}) {
                VStack {
                    Image(systemName: "heart")
                    Text("Favorites")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {router.navigateTo(.profile)}) {
                VStack {
                    Image(systemName: "person")
                    Text("Profile")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.light)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

#Preview {
    FooterView(router: Router())
}
