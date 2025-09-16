//  CastComponent.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI


struct CrewView: View {
    var crew: [CrewMember]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                    ForEach(Array(stride(from: 0, to: crew.count, by: 2)), id: \.self) { index in
                        CrewMemberCard(crew: crew, index: index)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 150)
        }
        .padding(.horizontal)
    }
}


struct CrewMemberCard: View {
    var crew: [CrewMember]
    var index: Int
    
    var body: some View {
        VStack (alignment: .leading, spacing: AppTheme.Spacing.medium) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text(crew[index].name)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.bold)
                Text(crew[index].job)
                    .font(AppTheme.Typography.body)
            }
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                // rendering second item in this column
                if index + 1 < crew.count {
                    Text(crew[index + 1].name)
                        .font(AppTheme.Typography.body)
                        .fontWeight(.bold)
                    Text(crew[index + 1].job)
                        .font(AppTheme.Typography.body)
                }
            }
        }
        .frame(width: 150)
    }
}
