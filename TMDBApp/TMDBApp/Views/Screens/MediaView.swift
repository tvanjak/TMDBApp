//
//  MovieScreen.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
//

import SwiftUI


//MOVE THIS TO VIEWMODEL? -------------------
extension String {
    func releaseYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        return "N/A"
    }
    
    func invertedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
        return "N/A"
    }
}
// -----------------------------------------

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


struct CastView: View {
    var cast: [CastMember]
    
    var body: some View {
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


struct MediaView: View {
    let media: MediaType
    @ObservedObject var mediaViewModel: MediaViewModel

    var body: some View {
        ScrollView {
            if let mediaDetail = mediaViewModel.mediaDetail {
                
                VStack (spacing: AppTheme.Spacing.medium) {
                    
                    // POSTER AND GENERAL INFO
//                    MediaPoster(id: mediaDetail.id,
//                                                    posterPath: mediaDetail.posterPath,
//                                                    fullPosterPath: mediaDetail.fullPosterPath,
//                                                    voteAverage: mediaDetail.voteAverage,
//                                                    releaseDate: mediaDetail.releaseDate,
//                                                    title: mediaDetail.displayTitle,
//                                                    genres: mediaDetail.formattedGenres,
//                                                    runtime: mediaDetail.formattedRuntime,
//                                                    mediaViewModel: mediaViewModel)
                    MediaPoster(mediaViewModel: mediaViewModel)
                    
                    // OVERVIEW
                    VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                        Text("Overview")
                            .font(AppTheme.Typography.title)
                            .fontWeight(.bold)
                        Text(mediaDetail.overview)
                            .font(AppTheme.Typography.body)
                    }
                    .padding()
                        
                    // CREW
                    CrewView(crew: mediaDetail.credits.crew)
                    
                    // CAST
                    CastView(cast: mediaDetail.credits.cast)
                                        
                }
            }
            else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await mediaViewModel.loadDetails(media: media)
            }
        }
    }
}

#Preview {
    MediaView(media: MediaType.movie(id: 6), mediaViewModel: MediaViewModel(
            favoritesManager: FavoritesManager(favoritesRepo: FavoritesRepository(), sessionRepo: SessionRepository()),
        ))
}
