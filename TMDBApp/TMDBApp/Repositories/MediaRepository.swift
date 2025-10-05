import Foundation

protocol MediaRepositoryProtocol {
    func fetchPopularMovies() async throws -> [MediaItemDTO]
    func fetchTrendingMovies() async throws -> [MediaItemDTO]
    func fetchUpcomingMovies() async throws -> [MediaItemDTO]
    func fetchNowPlayingMovies() async throws -> [MediaItemDTO]
    
    func fetchPopularTVShows() async throws -> [MediaItemDTO]
    func fetchTopRatedTVShows() async throws -> [MediaItemDTO]
    
    func fetchDetails(for media: MediaType) async throws -> any MediaDetailsDTO
    
    func fetchSearchedMovies(query: String) async throws -> [MediaItemDTO]
    func fetchSearchedTVShows(query: String) async throws -> [MediaItemDTO]
}


final class MediaRepository: MediaRepositoryProtocol {
    static let shared = MediaRepository()

    private init() {}

    //MOVIES
    func fetchPopularMovies() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/movie/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }

    
    func fetchTrendingMovies() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/trending/movie/day?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    

    func fetchUpcomingMovies() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/movie/upcoming?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    

    func fetchNowPlayingMovies() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/movie/now_playing?api_key=\(Constants.apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    
    
    // MEDIA DETAILS
    func fetchDetails(for media: MediaType) async throws -> any MediaDetailsDTO {
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
            let dtoData = try JSONDecoder().decode(MovieDetailsDTO.self, from: data)
            return dtoData
        case .tvShow:
            let dtoData = try JSONDecoder().decode(TVShowDetailsDTO.self, from: data)
            return dtoData
        }
    }
    
    
    
    // TV SHOWS
    func fetchPopularTVShows() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/tv/popular?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    
    func fetchTopRatedTVShows() async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/tv/top_rated?api_key=\(Constants.apiKey)&language=en-US"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    
    
    
    // SEARCH
    func fetchSearchedMovies(query: String) async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/search/movie?api_key=\(Constants.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
    
    func fetchSearchedTVShows(query: String) async throws -> [MediaItemDTO] {
        let urlString = "\(Constants.baseURL)/search/tv?api_key=\(Constants.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(MediaItemDTOResponse.self, from: data)
        let dtos = decodedResponse.results
        return dtos
    }
}
