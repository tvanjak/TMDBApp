import Foundation

class TMDBService {
    static let shared = TMDBService()
    
    private init() {}
    
    // MOVIES
    func fetchPopularMovies(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.apiKey)&language=en-US"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    func fetchTrendingMovies(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchNowPlayingMovies(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/movie/now_playing?api_key=\(Constants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    // MEDIA DETAILS
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
    func fetchPopularTVShows(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/tv/popular?api_key=\(Constants.apiKey)&language=en-US"

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    func fetchTopRatedTVShows(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        let urlString = "\(Constants.baseURL)/tv/top_rated?api_key=\(Constants.apiKey)&language=en-US"

        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MediaItemResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
