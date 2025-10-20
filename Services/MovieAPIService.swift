import Foundation
import Combine

// MARK: - API Service
class MovieAPIService: ObservableObject {
    static let shared = MovieAPIService()
    
    // Necesitarás reemplazar "YOUR_API_KEY" con tu token de TheMovieDB
    // Obtén tu API key gratuita en: https://www.themoviedb.org/settings/api
    private let apiKey = "fcf55caed48f3af81ad6a601c8c62a74"
    private let baseURL = "https://api.themoviedb.org/3"
    
    private init() {}
    
    // MARK: - Fetch Movies by Category
    func fetchMovies(category: MovieCategory, page: Int = 1) -> AnyPublisher<MovieResponse, Error> {
        let urlString = "\(baseURL)/movie/\(category.rawValue)?api_key=\(apiKey)&page=\(page)&language=es-ES"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Movie Details
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)&language=es-ES"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Movie.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Movie ViewModel
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPage = 1
    @Published var totalPages = 1
    
    private let apiService = MovieAPIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func loadMovies(category: MovieCategory, page: Int = 1) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchMovies(category: category, page: page)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    if page == 1 {
                        self?.movies = response.results
                    } else {
                        self?.movies.append(contentsOf: response.results)
                    }
                    self?.currentPage = response.page
                    self?.totalPages = response.totalPages
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreMovies(category: MovieCategory) {
        guard currentPage < totalPages && !isLoading else { return }
        loadMovies(category: category, page: currentPage + 1)
    }
    
    func refreshMovies(category: MovieCategory) {
        currentPage = 1
        loadMovies(category: category, page: 1)
    }
}
