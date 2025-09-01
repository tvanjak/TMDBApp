//
//  Footer.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct FooterView: View {
    let router: Router
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {router.navigateTo(.home)}) {
                VStack {
                    Image(systemName: "house")
                    Text("Home")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {router.navigateTo(.favorites)}) {
                VStack {
                    Image(systemName: "heart")
                    Text("Favorites")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {router.navigateTo(.profile)}) {
                VStack {
                    Image(systemName: "person")
                    Text("Profile")
                        .font(.subheadline)
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
