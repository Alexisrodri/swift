import Foundation

// MARK: - Movie Model
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let genreIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
    
    // Computed property para obtener la URL completa de la imagen
    var posterURL: String {
        guard let posterPath = posterPath else {
            return ""
        }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var backdropURL: String {
        guard let backdropPath = backdropPath else {
            return ""
        }
        return "https://image.tmdb.org/t/p/w1280\(backdropPath)"
    }
}

// MARK: - Movie Response Model
struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie Category Enum
enum MovieCategory: String, CaseIterable {
    case nowPlaying = "now_playing"
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    
    var displayName: String {
        switch self {
        case .nowPlaying:
            return "En Cartelera"
        case .popular:
            return "Populares"
        case .topRated:
            return "Mejor Valoradas"
        case .upcoming:
            return "Próximamente"
        }
    }
}
