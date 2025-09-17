//
//  CastComponent.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 16.09.2025..
//

import SwiftUI


struct MediaPoster: View {
//    var id: Int
//    var posterPath: String?
//    var fullPosterPath: String?
//    var voteAverage: Double
//    var releaseDate: String
//    var title: String
//    var genres: String
//    var runtime: String?
    @ObservedObject var mediaViewModel: MediaViewModel
    
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            if let fullURLString = mediaViewModel.mediaDetail!.fullPosterPath {
                if let url = URL(string: fullURLString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 360)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width, height: 360)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 360)
                    .clipped()
                    .foregroundColor(.black)
            }
            VStack (alignment: .leading) {
//                PosterText(voteAverage: voteAverage, releaseDate: releaseDate, title: title, genres: genres, runtime: runtime)
                PosterText(mediaViewModel: mediaViewModel)
                PosterButtons(mediaViewModel: mediaViewModel)
            }
            .padding()
        }
    }
}


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
        + Text(" (\(mediaViewModel.mediaDetail!.releaseYear))")
            .font(AppTheme.Typography.largeTitle)
            .foregroundStyle(.white)
        Text(mediaViewModel.mediaDetail!.invertedDate)
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
    var media: MediaItem {
        MediaItem(
            id: mediaViewModel.mediaDetail!.id,
            posterPath: mediaViewModel.mediaDetail!.posterPath,
        )
    }
    
    var body: some View {
        HStack {
            Button(action: {
                mediaViewModel.toggleFavorite(media)
            }) {
                Image(systemName: mediaViewModel.getFavoriteIcon(media))
                    .foregroundColor(mediaViewModel.getFavoriteColor(media))
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
