import Foundation

class TMDBService {
    static let shared = TMDBService()

    private init() {}

    //MOVIES
    
    func fetchPopularMovies() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }

    
    func fetchTrendingMovies() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }
    

    func fetchUpcomingMovies() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }
    

    func fetchNowPlayingMovies() async throws -> [Movie] {
        let urlString = "\(Constants.baseURL)/movie/now_playing?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }
    
    
    // MOVIE DETAILS
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetails {
        let urlString = "\(Constants.baseURL)/movie/\(movieId)?api_key=\(Constants.apiKey)&append_to_response=credits"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MovieDetails.self, from: data)
        return decodedResponse
    }
    
    
    
    // TV SHOWS

    func fetchPopularTVShows() async throws -> [TVShow] {
        let urlString = "\(Constants.baseURL)/tv/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
        return decodedResponse.results
    }
    
    func fetchTopRatedTVShows() async throws -> [TVShow] {
        let urlString = "\(Constants.baseURL)/tv/top_rated?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
        return decodedResponse.results
    }
    
}
