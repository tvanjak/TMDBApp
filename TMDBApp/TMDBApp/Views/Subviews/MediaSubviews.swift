//
//  MovieSubviews.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 02.09.2025..
//

import SwiftUI


struct RatingRing: View {
    var rating: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: rating)
                .stroke(
                    ratingColor,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(rating * 100))%")
                .font(AppTheme.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(ratingColor)
        }
        .frame(width: 60, height: 60)
    }
    
    private var ratingColor: Color {
        switch rating {
        case 0.75...: return .green
        case 0.5..<0.75: return .orange
        default: return .red
        }
    }
}


struct PosterText: View {
//    var voteAverage: Double
//    var releaseDate: String
//    var title: String
//    var genres: String
//    var runtime: String?
    @ObservedObject var mediaViewModel: MediaViewModel

    
    var body: some View {
        HStack {
            RatingRing(rating: mediaViewModel.mediaDetail!.voteAverage/10)
                .padding(.trailing, AppTheme.Spacing.small)
            Text("User score")
                .font(AppTheme.Typography.body)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
        Text(mediaViewModel.mediaDetail!.displayTitle)
            .font(AppTheme.Typography.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
        + Text(" (\(mediaViewModel.mediaDetail!.releaseDate.releaseYear()))")
            .font(AppTheme.Typography.largeTitle)
            .foregroundStyle(.white)
        Text(mediaViewModel.mediaDetail!.releaseDate.invertedDate())
            .font(AppTheme.Typography.body)
            .foregroundStyle(.white)
        
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(mediaViewModel.mediaDetail!.formattedGenres)
                .font(AppTheme.Typography.body)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            if let unwrappedRuntime = mediaViewModel.mediaDetail!.formattedRuntime {
                Text(unwrappedRuntime)
                    .font(AppTheme.Typography.body)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
    }
}

struct PosterButtons: View {
    @ObservedObject var mediaViewModel: MediaViewModel
    var movie: MediaItem {
        MediaItem(
            id: mediaViewModel.mediaDetail!.id,
            posterPath: mediaViewModel.mediaDetail!.posterPath,
        )
    }
    
    var body: some View {
        HStack {
            Button(action: {
                mediaViewModel.toggleFavorite(movie)
            }) {
                Image(systemName: mediaViewModel.getFavoriteIcon(movie))
                    .foregroundColor(mediaViewModel.getFavoriteColor(movie))
                    .padding(AppTheme.Spacing.small)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            Spacer()
            Text("Leave a review")
                .font(AppTheme.Typography.body)
                .fontWeight(.bold)
                .frame(width: 180, height: 40)
                .background(Color.gray)
                .cornerRadius(AppTheme.Radius.small)
                .foregroundStyle(.white)
        }
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


struct CastMemberCard: View {
    var castMember: CastMember
    
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
