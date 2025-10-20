import SwiftUI

// MARK: - Movie Detail View
struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header con imagen de fondo
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                )
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.5)
                                )
                        @unknown default:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    // Overlay con información
                    VStack(alignment: .leading, spacing: 12) {
                        Text(movie.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3)
                            .lineLimit(3)
                        
                        HStack(spacing: 16) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.voteAverage))
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                            
                            Text(movie.releaseDate)
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(20)
                        }
                        .shadow(color: .black, radius: 2)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
                // Contenido principal
                VStack(spacing: 40) {
                    // Sinopsis
                    VStack(spacing: 20) {
                        Text("Sinopsis")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(movie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(8)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 40)
                    
                    // Estadísticas en columna
                    VStack(spacing: 24) {
                        StatCard(
                            icon: "star.fill",
                            title: "Calificación",
                            value: String(format: "%.1f/10", movie.voteAverage),
                            color: .yellow
                        )
                        
                        StatCard(
                            icon: "person.3.fill",
                            title: "Votos",
                            value: "\(movie.voteCount)",
                            color: .blue
                        )
                        
                        StatCard(
                            icon: "calendar",
                            title: "Estreno",
                            value: movie.releaseDate,
                            color: .green
                        )
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

// MARK: - Movie Detail Preview
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            id: 1,
            title: "Película de Ejemplo",
            overview: "Esta es una película de ejemplo con una sinopsis muy interesante que cuenta la historia de...",
            posterPath: "/example.jpg",
            backdropPath: "/example.jpg",
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            voteCount: 1000,
            adult: false,
            genreIds: [1, 2, 3]
        )
        
        MovieDetailView(movie: sampleMovie)
    }
}
