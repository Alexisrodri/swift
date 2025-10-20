import SwiftUI

// MARK: - Hero Carousel View
struct HeroCarouselView: View {
    let movies: [Movie]
    
    var body: some View {
        TabView {
            ForEach(movies.prefix(5)) { movie in
                AsyncImage(url: URL(string: movie.backdropURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .failure(_):
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
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
                            .overlay(
                                ProgressView()
                                    .scaleEffect(1.5)
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                }
                .frame(height: 250)
                .clipped()
                .cornerRadius(16)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(16)
                )
                .overlay(
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
                )
                .overlay(
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        Color.clear
                    }
                )
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 250)
        .padding(.horizontal, 16)
    }
}
