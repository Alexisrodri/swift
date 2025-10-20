import SwiftUI

// MARK: - Movie Detail View
struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header con imagen de fondo
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: movie.backdropURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(height: 250)
                        .clipped()
                        
                        // Overlay con información
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 2)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.voteAverage))
                                    .foregroundColor(.white)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(movie.releaseDate)
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                            .shadow(color: .black, radius: 2)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    
                    // Información adicional
                    VStack(alignment: .leading, spacing: 16) {
                        // Sinopsis
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sinopsis")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(movie.overview)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        // Estadísticas
                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Calificación")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(String(format: "%.1f/10", movie.voteAverage))
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Votos")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(movie.voteCount)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Fecha")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(movie.releaseDate)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 50)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
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
