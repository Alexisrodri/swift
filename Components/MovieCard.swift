import SwiftUI

// MARK: - Movie Card Component
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
