//
//  CastComponent.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI

struct CastView: View {
    var cast: [CastMemberUI]
    
    var body: some View {
        if !cast.isEmpty {
            VStack (alignment: .leading) {
                Text("Top Billed Cast")
                    .font(.title)
                    .fontWeight(.bold)
                ScrollView (.horizontal, showsIndicators: false) {
                    LazyHStack (spacing: AppTheme.Spacing.medium) {
                        ForEach(cast) {castMember in
                            CastMemberCard(castMember: castMember)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}


struct CastMemberCard: View {
    var castMember: CastMemberUI
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
            if let fullURLString = castMember.fullProfilePath {
                if let url = URL(string: fullURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
            Text(castMember.name)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal, AppTheme.Spacing.small)
            Text(castMember.character)
                .foregroundStyle(.gray)
                .padding(.horizontal, AppTheme.Spacing.small)
            Spacer()
        }
        .frame(width: 150, height: 250)
        .background(Color.white)
        .cornerRadius(AppTheme.Radius.medium)
        .shadow(color: Color.black.opacity(0.2), radius: AppTheme.Radius.small)
        .padding(.vertical)
    }
}
