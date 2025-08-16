import Foundation

class TMDBService {
    static let shared = TMDBService()

    private init() {}

    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }

    
    func fetchTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    func fetchNowPlayingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    func fetchPopularTVShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
    
    
    func fetchTopRatedTVShows(completion: @escaping (Result<[TVShow], Error>) -> Void) {
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
                let decodedResponse = try JSONDecoder().decode(TVShowResponse.self, from: data)
                completion(.success(decodedResponse.results))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
