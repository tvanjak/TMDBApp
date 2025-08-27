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

struct MoviePoster: View {
    var id: Int
    var posterPath: String?
    var voteAverage: Double
    var releaseDate: String
    var title: String
    var genres: [Genre]
    var runtime: Int?
    
    var movie: MediaItem {
        MediaItem(
            id: id,
            posterPath: posterPath,
        )
    }
    
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            if let posterPath = posterPath {
                let fullURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
                if let url = URL(string: fullURLString) {
                    AsyncImage(url: url, scale: 2) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 360)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 360)
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
                VStack(alignment: .leading) {
                    Text(releaseDate.invertedDate())
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.white)
                    
                    let genresString = genres.map { $0.name }.joined(separator: ", ")
                    Text(genresString)
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let minutes = runtime {
                        let hours = minutes / 60
                        let actualMinutes = minutes % 60
                        
                        Text(hours > 0
                             ? "\(hours)h \(actualMinutes > 0 ? "\(actualMinutes)m" : "")"
                             : "\(actualMinutes)m")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(.white)
                        .bold()
                    }
                }
                
                HStack {
                    Button(action: {
                        if authVM.isFavorite(movie) {
                            authVM.removeFavorite(movie)
                        } else {
                            authVM.addFavorite(movie)
                        }
                    }) {
                        Image(systemName: authVM.isFavorite(movie) ? "heart.fill" : "heart")
                            .foregroundColor(authVM.isFavorite(movie) ? .red : .white)
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
            .padding()
        }
    }
}


struct CrewView: View {
    var crew: [CrewMember]
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                    ForEach(Array(stride(from: 0, to: crew.count, by: 2)), id: \.self) { index in
                        VStack (alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                                Text(crew[index].name)
                                    .font(AppTheme.Typography.body)
                                    .fontWeight(.bold)
                                Text(crew[index].job)
                                    .font(AppTheme.Typography.body)
                                    .font(.subheadline)
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
                HStack (spacing: AppTheme.Spacing.medium) {
                    ForEach(cast) {castMember in
                        VStack (alignment: .leading, spacing: AppTheme.Spacing.small) {
                            if let profilePath = castMember.profilePath {
                                let fullURLString = "https://image.tmdb.org/t/p/w200\(profilePath)"
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
                                .font(AppTheme.Typography.body)
                                .fontWeight(.bold)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            Text(castMember.character)
                                .font(AppTheme.Typography.body)
                                .foregroundStyle(AppTheme.Colors.textSecondary)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            Spacer()
                        }
                        .frame(width: 150, height: 250)
                        .background(Color.white) 
                        .cornerRadius(AppTheme.Radius.medium)
                        .shadow(color: Color.black.opacity(0.1), radius: AppTheme.Radius.small)
                        .padding(.vertical)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}


struct MediaDetailsView: View {
    let media: MediaType

    @StateObject private var mediaViewModel = MediaViewModel()
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        ScrollView {
            if let mediaDetail = mediaViewModel.mediaDetail {
                
                VStack (spacing: AppTheme.Spacing.medium) {
                    
                    // POSTER AND GENERAL INFO
                    MoviePoster(
                        id: mediaDetail.id,
                        posterPath: mediaDetail.posterPath,
                        voteAverage: mediaDetail.voteAverage,
                        releaseDate: mediaDetail.releaseDate,
                        title: mediaDetail.displayTitle,
                        genres: mediaDetail.genres,
                        runtime: mediaDetail.runtime
                    )
                        .environmentObject(authVM)
                    
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
    MediaDetailsView(media: MediaType.movie(id: 6))
        .environmentObject(AuthenticationViewModel())
}
