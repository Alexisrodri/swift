import SwiftUI

// MARK: - Main Home View
struct HomeView: View {
    @StateObject private var nowPlayingViewModel = MovieViewModel()
    @StateObject private var upcomingViewModel = MovieViewModel()
    @StateObject private var topRatedViewModel = MovieViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fondo blanco
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // App Bar
                    HStack {
                        Text("MoviesApp")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                    // Contenido principal
                    if nowPlayingViewModel.hasError && nowPlayingViewModel.movies.isEmpty {
                        // Vista de error principal
                        ErrorView(
                            errorMessage: nowPlayingViewModel.errorMessage,
                            onRetry: {
                                nowPlayingViewModel.retry(category: .nowPlaying)
                            }
                        )
                    } else {
                        ScrollView {
                            VStack(spacing: 32) {
                                // Hero Carousel
                                if !nowPlayingViewModel.movies.isEmpty {
                                    HeroCarouselView(movies: nowPlayingViewModel.movies)
                                }
                                
                                // Sección En Cartelera
                                HorizontalMoviesSection(
                                    title: "En Cartelera",
                                    movies: nowPlayingViewModel.movies,
                                    onLoadMore: {
                                        nowPlayingViewModel.loadMoreMovies(category: .nowPlaying)
                                    }
                                )
                                
                                // Sección Próximamente
                                HorizontalMoviesSection(
                                    title: "Próximamente",
                                    movies: upcomingViewModel.movies,
                                    onLoadMore: {
                                        upcomingViewModel.loadMoreMovies(category: .upcoming)
                                    }
                                )
                                
                                // Sección Mejor Valoradas
                                HorizontalMoviesSection(
                                    title: "Mejor Valoradas",
                                    movies: topRatedViewModel.movies,
                                    onLoadMore: {
                                        topRatedViewModel.loadMoreMovies(category: .topRated)
                                    }
                                )
                                
                                // Espacio inferior
                                Spacer(minLength: 50)
                            }
                            .padding(.top, 16) // Padding de separación con AppBar
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                nowPlayingViewModel.loadMovies(category: .nowPlaying)
                upcomingViewModel.loadMovies(category: .upcoming)
                topRatedViewModel.loadMovies(category: .topRated)
            }
        }
    }
}
