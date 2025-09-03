//
//  MovieSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI


struct CrewMemberCard: View {
    var crew: [CrewMember]
    var index: Int
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(crew[index].name)
                    .fontWeight(.bold)
                Text(crew[index].job)
                    .font(.subheadline)
            }
            VStack(alignment: .leading, spacing: 5) {
                // rendering second item in this column
                if index + 1 < crew.count {
                    Text(crew[index + 1].name)
                        .fontWeight(.bold)
                    Text(crew[index + 1].job)
                        .font(.subheadline)
                }
            }
        }
        .frame(width: 150)
    }
}


struct CastMemberCard: View {
    var castMember: CastMember
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
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
                .padding(.horizontal, 5)
            Text(castMember.character)
                .foregroundStyle(.gray)
                .padding(.horizontal, 5)
            Spacer()
        }
        .frame(width: 150, height: 250)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 2, y: 4)
        .padding(.vertical)
    }
}
