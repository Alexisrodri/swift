import Foundation
import Combine

// MARK: - API Error Types
enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case invalidAPIKey
    case rateLimitExceeded
    case parseResponseError
    case connectionLost
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos del servidor"
        case .decodingError:
            return "Error al procesar los datos"
        case .networkError(let error):
            return "Error de conexión: \(error.localizedDescription)"
        case .serverError(let code):
            return "Error del servidor: \(code)"
        case .invalidAPIKey:
            return "API Key inválida. Verifica tu configuración."
        case .rateLimitExceeded:
            return "Límite de solicitudes excedido. Intenta más tarde."
        case .parseResponseError:
            return "Error al procesar la respuesta del servidor. Intenta nuevamente."
        case .connectionLost:
            return "Conexión perdida. Verifica tu conexión a internet."
        }
    }
    
    // MARK: - Equatable Implementation
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingError, .decodingError),
             (.invalidAPIKey, .invalidAPIKey),
             (.rateLimitExceeded, .rateLimitExceeded),
             (.parseResponseError, .parseResponseError),
             (.connectionLost, .connectionLost):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

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
        // Validar API Key
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY" else {
            return Fail(error: APIError.invalidAPIKey)
                .eraseToAnyPublisher()
        }
        
        // Construir URL
        let urlString = "\(baseURL)/movie/\(category.rawValue)?api_key=\(apiKey)&page=\(page)&language=es-ES"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                // Verificar respuesta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        break // Éxito
                    case 401:
                        throw APIError.invalidAPIKey
                    case 429:
                        throw APIError.rateLimitExceeded
                    case 500...599:
                        throw APIError.serverError(httpResponse.statusCode)
                    default:
                        throw APIError.serverError(httpResponse.statusCode)
                    }
                }
                
                // Verificar que hay datos
                guard !data.isEmpty else {
                    throw APIError.noData
                }
                
                return data
            }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else if error is DecodingError {
                    return APIError.decodingError
                } else if let urlError = error as? URLError {
                    // Detectar específicamente el error -1017
                    if urlError.code == .cannotParseResponse {
                        return APIError.parseResponseError
                    }
                    // Detectar específicamente el error -1005 (pérdida de conexión)
                    if urlError.code == .networkConnectionLost {
                        return APIError.connectionLost
                    }
                    return APIError.networkError(error)
                } else {
                    return APIError.networkError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Fetch Movie Details
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<Movie, Error> {
        // Validar API Key
        guard !apiKey.isEmpty && apiKey != "YOUR_API_KEY" else {
            return Fail(error: APIError.invalidAPIKey)
                .eraseToAnyPublisher()
        }
        
        // Construir URL
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)&language=es-ES"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                // Verificar respuesta HTTP
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        break // Éxito
                    case 401:
                        throw APIError.invalidAPIKey
                    case 404:
                        throw APIError.noData // Película no encontrada
                    case 429:
                        throw APIError.rateLimitExceeded
                    case 500...599:
                        throw APIError.serverError(httpResponse.statusCode)
                    default:
                        throw APIError.serverError(httpResponse.statusCode)
                    }
                }
                
                // Verificar que hay datos
                guard !data.isEmpty else {
                    throw APIError.noData
                }
                
                return data
            }
            .decode(type: Movie.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                } else if error is DecodingError {
                    return APIError.decodingError
                } else if let urlError = error as? URLError {
                    // Detectar específicamente el error -1017
                    if urlError.code == .cannotParseResponse {
                        return APIError.parseResponseError
                    }
                    // Detectar específicamente el error -1005 (pérdida de conexión)
                    if urlError.code == .networkConnectionLost {
                        return APIError.connectionLost
                    }
                    return APIError.networkError(error)
                } else {
                    return APIError.networkError(error)
                }
            }
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
    @Published var hasError = false
    @Published var isRetrying = false
    
    private let apiService = MovieAPIService.shared
    private var cancellables = Set<AnyCancellable>()
    private var retryCount = 0
    private let maxRetries = 3
    
    func loadMovies(category: MovieCategory, page: Int = 1) {
        print("📡 Loading movies - Category: \(category.rawValue), Page: \(page)")
        isLoading = true
        errorMessage = nil
        hasError = false
        
        apiService.fetchMovies(category: category, page: page)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error: error, category: category, page: page)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.hasError = false
                    self?.retryCount = 0 // Reset retry count on success
                    self?.isRetrying = false // Reset retry indicator on success
                    print("✅ Movies loaded successfully - Page: \(response.page), Total pages: \(response.totalPages), Movies count: \(response.results.count)")
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
    
    private func handleError(error: Error, category: MovieCategory, page: Int) {
        if let apiError = error as? APIError {
            switch apiError {
            case .parseResponseError, .connectionLost:
                // Retry automático para errores de parseo y pérdida de conexión
                if retryCount < maxRetries {
                    retryCount += 1
                    isRetrying = true
                    let delay: Double = apiError == .connectionLost ? 2.0 : 1.0 // Más tiempo para conexión perdida
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.isRetrying = false
                        self.loadMovies(category: category, page: page)
                    }
                    return
                }
            default:
                break
            }
            self.errorMessage = apiError.errorDescription
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.hasError = true
        self.isRetrying = false
    }
    
    func loadMoreMovies(category: MovieCategory) {
        guard currentPage < totalPages && !isLoading && !isRetrying else { return }
        print("🔄 Loading more movies - Current page: \(currentPage), Next page: \(currentPage + 1)")
        loadMovies(category: category, page: currentPage + 1)
    }
    
    func refreshMovies(category: MovieCategory) {
        currentPage = 1
        retryCount = 0
        isRetrying = false
        loadMovies(category: category, page: 1)
    }
    
    func retry(category: MovieCategory) {
        hasError = false
        errorMessage = nil
        retryCount = 0
        isRetrying = false
        refreshMovies(category: category)
    }
}