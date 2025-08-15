//
//  Footer.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 12.08.2025..
//

import SwiftUI

struct FooterView: View {
    @Binding var selectedSection: AppLayout.Section
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {selectedSection = .home}) {
                VStack {
                    Image(systemName: "house")
                    Text("Home")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {selectedSection = .favorites}) {
                VStack {
                    Image(systemName: "heart")
                    Text("Favorites")
                        .font(.subheadline)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Button(action: {selectedSection = .profile}) {
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
    @Previewable @State var section: AppLayout.Section = .home
    FooterView(selectedSection: $section)
}
