import SwiftUI

// MARK: - Horizontal Movies Section
struct HorizontalMoviesSection: View {
    let title: String
    let movies: [Movie]
    let onLoadMore: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header de la sección
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Ver más") {
                    onLoadMore()
                }
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            
            // Carrusel horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieCardHorizontal(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onAppear {
                            if movie.id == movies.last?.id {
                                onLoadMore()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
