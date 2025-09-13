import Foundation

class TMDBService {
    static let shared = TMDBService()

    private init() {}

    //MOVIES
    func fetchPopularMovies() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }

    
    func fetchTrendingMovies() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    

    func fetchUpcomingMovies() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    

    func fetchNowPlayingMovies() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/movie/now_playing?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    
    
    // MOVIE DETAILS
    func fetchDetails(for media: MediaType) async throws -> any MediaItemDetails {
        let urlString: String
        
        switch media {
        case .movie(let id):
            urlString = "\(Constants.baseURL)/movie/\(id)?api_key=\(Constants.apiKey)&append_to_response=credits"
        case .tvShow(let id):
            urlString = "\(Constants.baseURL)/tv/\(id)?api_key=\(Constants.apiKey)&append_to_response=credits"
        }
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        switch media {
        case .movie:
            return try JSONDecoder().decode(MovieDetails.self, from: data)
        case .tvShow:
            return try JSONDecoder().decode(TVShowDetails.self, from: data)
        }
    }
    
    
    
    // TV SHOWS
    func fetchPopularTVShows() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/tv/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    
    func fetchTopRatedTVShows() async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/tv/top_rated?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    
    
    
    // SEARCH
    func fetchSearchedMovies(query: String) async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
    
    func fetchSearchedTVShows(query: String) async throws -> [MediaItem] {
        let urlString = "\(Constants.baseURL)/search/tv?api_key=\(Constants.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
        return decodedResponse.results
    }
}
