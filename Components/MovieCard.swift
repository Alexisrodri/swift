import SwiftUI

// MARK: - Movie Card Component (Horizontal)
struct MovieCard: View {
    let movie: Movie
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagen de la película
            AsyncImage(url: URL(string: movie.posterURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title)
                    )
            }
            .frame(width: 150, height: 225)
            .cornerRadius(12)
            .clipped()
            
            // Título de la película
            Text(movie.title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 150, alignment: .leading)
        }
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Movie Card Vertical Component
struct MovieCardVertical: View {
    let movie: Movie
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Imagen de la película
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                                Text("Error")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        )
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .clipped()
            
            // Información de la película
            VStack(alignment: .leading, spacing: 8) {
                // Título
                Text(movie.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Calificación
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Fecha de estreno
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Sinopsis (truncada)
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Movie Card Horizontal Component
struct MovieCardHorizontal: View {
    let movie: Movie
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagen de la película
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                                Text("Error")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        )
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 120, height: 180)
            .cornerRadius(12)
            .clipped()
            
            // Información de la película
            VStack(alignment: .leading, spacing: 4) {
                // Título
                Text(movie.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: 120, alignment: .leading)
                
                // Calificación
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Movie Card Preview
struct MovieCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            id: 1,
            title: "Película de Ejemplo",
            overview: "Esta es una película de ejemplo",
            posterPath: "/example.jpg",
            backdropPath: "/example.jpg",
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            adult: false,
            genreIds: [1, 2, 3]
        )
        
        MovieCard(movie: sampleMovie) {
            print("Tapped on movie")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
