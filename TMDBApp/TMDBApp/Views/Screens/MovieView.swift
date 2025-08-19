//
//  MovieScreen.swift
//  TMDBApp
//
//  Created by Toni Vanjak on 19.08.2025..
//

import SwiftUI


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
    var posterPath: String?
    var voteAverage: Double
    var releaseDate: String
    var title: String
    var genres: [Genre]
    var runtime: Int?
    
    @Binding var isFavorite: Bool
    
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
                            .frame(height: 350)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 360)
                    .clipped()
                    .foregroundColor(.black)
            }
            
            VStack (alignment: .leading) {
                HStack {
                    ProgressRing(progress: voteAverage/10)
                        .padding(.trailing, 5)
                    Text("User score")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                + Text(" (\(releaseDate.releaseYear()))")
                    .font(.title)
                    .foregroundStyle(.white)
                Text(releaseDate.invertedDate())
                    .font(.title3)
                    .foregroundStyle(.white)
                let genresString = genres.map { $0.name }.joined(separator: ", ")
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(genresString)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if let minutes = runtime {
                        let hours = minutes / 60
                        let actualMinutes = minutes % 60
                        
                        Text(hours > 0
                             ? "\(hours)h \(actualMinutes > 0 ? "\(actualMinutes)m" : "")"
                             : "\(actualMinutes)m")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.top, 2)
                    }
                }
                
                HStack {
                    Button(action: {
                        isFavorite.toggle()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Leave a review")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 180, height: 40)
                        .background(Color.gray)
                        .cornerRadius(10)
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
                HStack(alignment: .top, spacing: 15) {
                    ForEach(Array(stride(from: 0, to: crew.count, by: 2)), id: \.self) { index in
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
                HStack (spacing: 20) {
                    ForEach(cast) {castMember in
                        VStack (alignment: .leading, spacing: 5) {
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
            }
        }
        .padding(.horizontal)
    }
}


struct ProgressRing: View {
    var progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(progress * 100))%")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(progressColor)
        }
        .frame(width: 60, height: 60)
    }
    
    private var progressColor: Color {
        switch progress {
        case 0.75...: return .green
        case 0.5..<0.75: return .orange
        default: return .red
        }
    }
}


struct MovieView: View {
    var movieId: Int
    @StateObject private var movieViewModel = MovieViewModel()
    
    @State private var isFavorite: Bool = false

    var body: some View {
        ScrollView {
            if let movieDetail = movieViewModel.movieDetail {
                
                VStack (spacing: 15) {
                    
                    // POSTER AND GENERAL INFO
                    MoviePoster(posterPath: movieDetail.posterPath, voteAverage: movieDetail.voteAverage, releaseDate: movieDetail.releaseDate, title: movieDetail.title, genres: movieDetail.genres, runtime: movieDetail.runtime, isFavorite: $isFavorite)
                    
                    // OVERVIEW
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(movieDetail.overview)
                            .font(.subheadline)
                    }
                    .padding()
                        
                    // CREW
                    CrewView(crew: movieDetail.credits.crew)
                    
                    // CAST
                    CastView(cast: movieDetail.credits.cast)
                                        
                }
            }
            else {
                ProgressView()
            }
        }
        .onAppear {
            if movieViewModel.movieDetail == nil {
                movieViewModel.loadMovieDetails(movieId: movieId)
            }
        }
    }
}

#Preview {
    MovieView(movieId: 2)
}
