import SwiftUI

// MARK: - Hero Carousel View
struct HeroCarouselView: View {
    let movies: [Movie]
    
    var body: some View {
        TabView {
            ForEach(movies.prefix(5)) { movie in
                ZStack {
                    AsyncImage(url: movie.backdropURL != nil ? URL(string: movie.backdropURL!) : nil) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .cornerRadius(16)
                                .clipped()
                        case .failure(_):
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                                .clipped()
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "photo")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                        Text("Error al cargar imagen")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                                .clipped()
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.5)
                                )
                        @unknown default:
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                                .clipped()
                        }
                    }
                    
                    // Overlay con gradiente
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(16)
                    .clipped()
                    
                    // Información de la película
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(movie.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                    .shadow(color: .black, radius: 2)
                                
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", movie.voteAverage))
                                        .foregroundColor(.white)
                                        .fontWeight(.medium)
                                        .shadow(color: .black, radius: 2)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    // Navegación
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        Color.clear
                    }
                }
                .frame(height: 250)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .padding(.horizontal, 16)
    }
}
