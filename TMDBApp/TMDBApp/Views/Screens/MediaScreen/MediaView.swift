//
//  MovieScreen.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
//

import SwiftUI


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
            favoritesManager: FavoritesManager(favoritesRepo: FavoritesRepository(), authenticationRepo: AuthenticationRepository()),
        ))
}
