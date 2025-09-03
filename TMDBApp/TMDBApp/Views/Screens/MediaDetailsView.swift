//
//  MovieScreen.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
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
                .font(.title3)
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


//MOVE THIS TO VIEWMODEL -------------------
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
    var id: Int
    var posterPath: String?
    var fullPosterPath: String?
    var voteAverage: Double
    var releaseDate: String
    var title: String
    var genres: String
    var runtime: String?
    @ObservedObject var mediaViewModel: MediaViewModel
    
    var movie: MediaItem {
        MediaItem(
            id: id,
            posterPath: posterPath,
        )
    }
    
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            if let fullURLString = fullPosterPath {
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
                HStack {
                    RatingRing(rating: voteAverage/10)
                        .padding(.trailing, AppTheme.Spacing.small)
                    Text("User score")
                        .font(AppTheme.Typography.body)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                Text(title)
                    .font(AppTheme.Typography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                + Text(" (\(releaseDate.releaseYear()))")
                    .font(AppTheme.Typography.largeTitle)
                    .foregroundStyle(.white)
                Text(releaseDate.invertedDate())
                    .font(.title3)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(genres)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    if let unwrappedRuntime = runtime {
                        Text(unwrappedRuntime)
                            .font(.title3)
                            .foregroundStyle(.white)
                            .bold()
                            .padding(.top, 2)
                    }
                }
                
                HStack {
                    Button(action: {
                        mediaViewModel.toggleFavorite(movie)
                    }) {
                        Image(systemName: mediaViewModel.getFavoriteIcon(movie))
                            .foregroundColor(mediaViewModel.getFavoriteColor(movie))
                            .padding(8)
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
            .padding()
        }
    }
}


struct CrewView: View {
    var crew: [CrewMember]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 15) {
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
                LazyHStack (spacing: 20) {
                    ForEach(cast) {castMember in
                        CastMemberCard(castMember: castMember)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}


struct MediaDetailsView: View {
    let media: MediaType
    @ObservedObject var mediaViewModel: MediaViewModel

    var body: some View {
        ScrollView {
            if let mediaDetail = mediaViewModel.mediaDetail {
                
                VStack (spacing: AppTheme.Spacing.medium) {
                    
                    // POSTER AND GENERAL INFO
                    MediaPoster(id: mediaDetail.id,
                                posterPath: mediaDetail.posterPath,
                                fullPosterPath: mediaDetail.fullPosterPath,
                                voteAverage: mediaDetail.voteAverage,
                                releaseDate: mediaDetail.releaseDate,
                                title: mediaDetail.displayTitle,
                                genres: mediaDetail.formattedGenres,
                                runtime: mediaDetail.formattedRuntime,
                                mediaViewModel: mediaViewModel)
                    
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
            if mediaViewModel.mediaDetail == nil {
                Task {
                    await mediaViewModel.loadDetails(media: media)
                }
            }
        }
    }
}

#Preview {
    MediaDetailsView(media: MediaType.movie(id: 6), mediaViewModel: MediaViewModel(
            favoritesRepo: FavoritesRepository(),
            sessionRepo: SessionRepository(),
            navigationService: Router(),
        ))
}
